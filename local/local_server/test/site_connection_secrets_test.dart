import 'package:local_server/src/site/site_connection_secrets.dart';
import 'package:test/test.dart';

void main() {
  const password = 'test-cipher-password';
  const sessionKey = 'testkey1234567890abcdef-testkey12345678';

  setUp(() {
    SiteConnectionSecrets.debugPasswordOverride = password;
  });
  tearDown(() {
    SiteConnectionSecrets.debugPasswordOverride = null;
  });

  test('encrypt/decrypt roundtrip restores the session key', () async {
    final encrypted = await SiteConnectionSecrets.encrypt(sessionKey);
    expect(encrypted, isNot(sessionKey));
    expect(encrypted.startsWith('enc:v1.'), isTrue);
    expect(
      await SiteConnectionSecrets.decrypt(encrypted),
      sessionKey,
    );
  });

  test('each encryption uses a fresh nonce', () async {
    final first = await SiteConnectionSecrets.encrypt(sessionKey);
    final second = await SiteConnectionSecrets.encrypt(sessionKey);
    expect(first, isNot(second));
    expect(
      await SiteConnectionSecrets.decrypt(second),
      sessionKey,
    );
  });

  test('legacy plaintext rows pass through unchanged', () async {
    final plain = 'legacy-plaintext-sas-key';
    expect(await SiteConnectionSecrets.decrypt(plain), plain);
  });

  test(
    'decrypt without configured password fails with a clear error',
    () async {
      final encrypted = await SiteConnectionSecrets.encrypt(sessionKey);
      SiteConnectionSecrets.debugPasswordOverride = null;
      expect(
        () => SiteConnectionSecrets.decrypt(encrypted),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('siteDeviceKeyCipherPassword is not configured'),
          ),
        ),
      );
    },
  );

  test('decrypt with a WRONG password fails', () async {
    final encrypted = await SiteConnectionSecrets.encrypt(sessionKey);
    SiteConnectionSecrets.debugPasswordOverride = 'other-password';
    expect(
      () => SiteConnectionSecrets.decrypt(encrypted),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('could not be decrypted'),
        ),
      ),
    );
  });

  test('encrypt without a configured password stores plaintext', () async {
    SiteConnectionSecrets.debugPasswordOverride = null;
    final stored = await SiteConnectionSecrets.encrypt(sessionKey);
    expect(stored, sessionKey);
  });
}
