import 'package:flutter_test/flutter_test.dart';
import 'package:itsbits_shared/door_code.dart';

void main() {
  const secret =
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
  const mac = 'A4:CF:12:9D:71:E2';
  final fixedTime = DateTime.utc(2026, 1, 1, 12, 0, 15); // step boundary +15 s

  test('step derives from unix time in 30 s buckets', () {
    final base = doorCodeStep(fixedTime);
    expect(doorCodeStep(fixedTime.add(const Duration(seconds: 14))), base);
    expect(doorCodeStep(fixedTime.add(const Duration(seconds: 16))), base + 1);
  });

  test('mac normalization is stable across formats', () {
    expect(normalizeDeviceMac('a4:cf:12:9d:71:e2'), 'A4CF129D71E2');
    expect(normalizeDeviceMac('A4-CF-12-9D-71-E2'), 'A4CF129D71E2');
    expect(normalizeDeviceMac('a4cf129d71e2'), 'A4CF129D71E2');
  });

  test('codes match for the same step and differ per door and step', () {
    final step = doorCodeStep(fixedTime);
    final code = computeDoorCode(
      secretHex: secret,
      step: step,
      deviceMac: mac,
    );
    expect(code, hasLength(6));
    expect(
      computeDoorCode(secretHex: secret, step: step, deviceMac: mac),
      code,
    );
    expect(
      computeDoorCode(
        secretHex: secret,
        step: step,
        deviceMac: 'AA:BB:CC:DD:EE:FF',
      ),
      isNot(code),
    );
    expect(
      computeDoorCode(secretHex: secret, step: step + 1, deviceMac: mac),
      isNot(code),
    );
  });

  test('verification accepts the code within the ±1 step window', () {
    expect(
      verifyDoorCode(
        secretHex: secret,
        code: computeDoorCode(
          secretHex: secret,
          step: doorCodeStep(fixedTime) - 1,
          deviceMac: mac,
        ),
        deviceMac: mac,
        now: fixedTime,
      ),
      isTrue,
    );
    expect(
      verifyDoorCode(
        secretHex: secret,
        code: computeDoorCode(
          secretHex: secret,
          step: doorCodeStep(fixedTime) + 1,
          deviceMac: mac,
        ),
        deviceMac: mac,
        now: fixedTime,
      ),
      isTrue,
    );
  });

  test('verification rejects foreign codes', () {
    expect(
      verifyDoorCode(
        secretHex: secret,
        code: computeDoorCode(
          secretHex: secret,
          step: doorCodeStep(fixedTime) - 2,
          deviceMac: mac,
        ),
        deviceMac: mac,
        now: fixedTime,
      ),
      isFalse,
    );
    expect(
      verifyDoorCode(
        secretHex: 'ff$secret'.substring(2),
        code: '123456',
        deviceMac: mac,
        now: fixedTime,
      ),
      isFalse,
    );
    expect(
      verifyDoorCode(
        secretHex: secret,
        code: computeDoorCode(
          secretHex: secret,
          step: doorCodeStep(fixedTime),
          deviceMac: mac,
        ),
        deviceMac: 'AA:BB:CC:DD:EE:FF',
        now: fixedTime,
      ),
      isFalse,
    );
  });

  test('matched step resolves for consumption', () {
    final current = doorCodeStep(fixedTime);
    final code = computeDoorCode(
      secretHex: secret,
      step: current - 1,
      deviceMac: mac,
    );
    expect(
      matchedDoorCodeStep(
        secretHex: secret,
        code: code,
        deviceMac: mac,
        now: fixedTime,
      ),
      current - 1,
    );
    expect(
      matchedDoorCodeStep(
        secretHex: secret,
        code: '000000',
        deviceMac: mac,
        now: fixedTime,
      ),
      isNull,
    );
  });
}
