import 'package:flutter_test/flutter_test.dart';
import 'package:itsbits_shared/door_code.dart';

void main() {
  const secret =
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
  const mac = 'A4:CF:12:9D:71:E2';
  final now = DateTime.utc(2026, 1, 1, 12, 0, 0);
  final timestampMs = now.millisecondsSinceEpoch;

  test('mac normalization is stable across formats', () {
    expect(normalizeDeviceMac('a4:cf:12:9d:71:e2'), 'A4CF129D71E2');
    expect(normalizeDeviceMac('A4-CF-12-9D-71-E2'), 'A4CF129D71E2');
    expect(normalizeDeviceMac('a4cf129d71e2'), 'A4CF129D71E2');
  });

  test('codes are deterministic per timestamp and unique per scan', () {
    final code = computeDoorCode(
      secretHex: secret,
      timestampMs: timestampMs,
      deviceMac: mac,
    );
    expect(code, hasLength(6));
    expect(
      computeDoorCode(secretHex: secret, timestampMs: timestampMs, deviceMac: mac),
      code,
    );
  });

  test('codes differ per door and per timestamp', () {
    final code = computeDoorCode(
      secretHex: secret,
      timestampMs: timestampMs,
      deviceMac: mac,
    );
    expect(
      computeDoorCode(
        secretHex: secret,
        timestampMs: timestampMs,
        deviceMac: 'AA:BB:CC:DD:EE:FF',
      ),
      isNot(code),
    );
    expect(
      computeDoorCode(
        secretHex: secret,
        timestampMs: timestampMs + 1,
        deviceMac: mac,
      ),
      isNot(code),
    );
  });

  test('verification accepts the timestamp within the skew window', () {
    expect(
      verifyDoorCode(
        secretHex: secret,
        code: computeDoorCode(
          secretHex: secret,
          timestampMs: timestampMs - 25 * 1000,
          deviceMac: mac,
        ),
        deviceMac: mac,
        timestampMs: timestampMs - 25 * 1000,
        now: now.toLocal(),
      ),
      isTrue,
    );
  });

  test('verification flags out-of-window timestamps as skew-only', () {
    final staleTs = timestampMs - 45 * 1000;
    final code = computeDoorCode(
      secretHex: secret,
      timestampMs: staleTs,
      deviceMac: mac,
    );
    expect(
      verifyDoorCode(
        secretHex: secret,
        code: code,
        deviceMac: mac,
        timestampMs: staleTs,
        now: now.toLocal(),
      ),
      isFalse,
    );
    expect(
      isTimeSkewOnly(
        secretHex: secret,
        code: code,
        deviceMac: mac,
        timestampMs: staleTs,
        now: now.toLocal(),
      ),
      isTrue,
    );
  });

  test('verification rejects foreign codes', () {
    expect(
      verifyDoorCode(
        secretHex: secret,
        code: '000000',
        deviceMac: mac,
        timestampMs: timestampMs,
        now: now.toLocal(),
      ),
      isFalse,
    );
    expect(
      isTimeSkewOnly(
        secretHex: secret,
        code: '000000',
        deviceMac: mac,
        timestampMs: timestampMs,
        now: now.toLocal(),
      ),
      isFalse,
    );
  });
}
