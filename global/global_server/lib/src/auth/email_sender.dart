import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart' hide ExceptionEvent, Message;

/// Sends the Email IdP verification codes over SMTP.
///
/// Configuration comes from password keys (`smtpHost`, `smtpPort`,
/// `smtpSsl`, `smtpUsername`, `smtpPassword`, `smtpFromAddress`,
/// optionally `smtpFromName`, `smtpAllowInsecure`), each overridable via
/// `SERVERPOD_PASSWORD_<key>` env vars (deployment/docker env).
///
/// Without `smtpHost` the codes are only logged (dev/test behavior).
/// Password resets always swallow send failures (no account enumeration);
/// registration failures are rethrown so the request fails visibly and
/// rolls back cleanly.
class EmailSender {
  const EmailSender({required this.appDisplayName});

  final String appDisplayName;

  Future<void> sendRegistrationCode(
    Session session, {
    required String email,
    required String verificationCode,
  }) {
    return _sendCode(
      session,
      email: email,
      code: verificationCode,
      subject: 'Dein Bestätigungscode für $appDisplayName',
      intro:
          'Dein Bestätigungscode zum Abschluss der Registrierung '
          'bei $appDisplayName:',
      rethrowOnFailure: true,
    );
  }

  Future<void> sendPasswordResetCode(
    Session session, {
    required String email,
    required String verificationCode,
  }) {
    return _sendCode(
      session,
      email: email,
      code: verificationCode,
      subject:
          'Dein Code zum Zurücksetzen deines Passworts für $appDisplayName',
      intro: 'Dein Code zum Zurücksetzen deines $appDisplayName-Passworts:',
      rethrowOnFailure: false,
    );
  }

  Future<void> _sendCode(
    Session session, {
    required String email,
    required String code,
    required String subject,
    required String intro,
    required bool rethrowOnFailure,
  }) async {
    final config = _resolveConfig();
    if (config == null) {
      session.log('[EmailIdp] Code ($email): $code');
      return;
    }

    try {
      await send(
        _buildMessage(
          config,
          email: email,
          code: code,
          subject: subject,
          intro: intro,
        ),
        config.server,
        timeout: const Duration(seconds: 15),
      );
      session.log('[EmailIdp] Verification email sent to $email');
    } catch (e, stackTrace) {
      session.log(
        'Failed to send verification email to $email',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      if (rethrowOnFailure) {
        rethrow;
      }
    }
  }

  Message _buildMessage(
    _SmtpConfig config, {
    required String email,
    required String code,
    required String subject,
    required String intro,
  }) {
    final message = Message()
      ..from = Address(
        config.fromAddress,
        Serverpod.instance.getPassword('smtpFromName') ?? appDisplayName,
      )
      ..recipients.add(email)
      ..subject = subject
      ..text =
          'Hallo,\n\n'
          '$intro\n\n'
          '$code\n\n'
          'Der Code ist nur kurze Zeit gültig. Wenn du diese Anfrage nicht '
          'ausgelöst hast, kannst du diese E-Mail ignorieren.\n\n'
          'Dein $appDisplayName Team';

    final logo = _logoPngFile();
    if (logo != null) {
      message.html =
          '<p>Hallo,</p><p>$intro</p>'
          '<p><span style="font-size:32px;font-weight:bold;'
          'font-family:monospace;background-color:#f2f2f2;'
          'padding:8px 16px;letter-spacing:4px;">$code</span></p>'
          '<img src="cid:logo@itsbits-flow" width="120" '
          'alt="$appDisplayName" />';
      message.attachments.add(
        FileAttachment(
            logo,
            contentType: 'image/png',
            fileName: 'logo.png',
          )
          ..cid = 'logo@itsbits-flow'
          ..location = Location.inline,
      );
    }

    return message;
  }

  File? _logoPngFile() {
    final file = File(
      p.join(
        Serverpod.instance.serverDirectory.path,
        'assets',
        'logo.png',
      ),
    );
    return file.existsSync() && file.lengthSync() > 0 ? file : null;
  }
}

class _SmtpConfig {
  const _SmtpConfig({required this.server, required this.fromAddress});

  final SmtpServer server;
  final String fromAddress;
}

/// `null` = SMTP not configured, keep the log-only dev fallback.
/// Throws on values that fail to parse (misconfiguration is surfaced).
_SmtpConfig? _resolveConfig() {
  final pod = Serverpod.instance;
  final host = pod.getPassword('smtpHost');
  if (host == null || host.isEmpty) {
    return null;
  }

  bool flag(String key) =>
      (pod.getPassword(key) ?? 'false').toLowerCase() == 'true';

  final smtpUsername = pod.getPassword('smtpUsername');
  final fromAddress = pod.getPassword('smtpFromAddress') ?? smtpUsername;
  if (fromAddress == null || fromAddress.isEmpty) {
    throw ArgumentError(
      'smtpFromAddress (or smtpUsername as the sender address) is '
      'required when smtpHost is configured',
    );
  }

  return _SmtpConfig(
    server: SmtpServer(
      host,
      port: int.tryParse(pod.getPassword('smtpPort') ?? '587') ?? 587,
      ssl: flag('smtpSsl'),
      allowInsecure: flag('smtpAllowInsecure'),
      username: smtpUsername,
      password: pod.getPassword('smtpPassword'),
    ),
    fromAddress: fromAddress,
  );
}
