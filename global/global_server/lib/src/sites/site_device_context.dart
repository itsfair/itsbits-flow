import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Resolves the site of the calling device session via the SAS session id
/// (`session.authenticated!.authId` → SiteDeviceSession → Site). Shared by
/// the device-scoped endpoints (`siteConnection`, `siteSync`, `siteDetails`)
/// — previously duplicated three times.
Future<Site> requireDeviceSite(final Session session) async {
  final authInfo = session.authenticated;
  final sessionId = authInfo?.authId;
  if (authInfo == null || sessionId == null) {
    throw SiteAdminException(message: 'Nicht authentifiziert.');
  }

  final deviceSession = await SiteDeviceSession.db.findFirstRow(
    session,
    where: (t) => t.serverSideSessionId.equals(UuidValue.fromString(sessionId)),
  );
  if (deviceSession == null) {
    throw SiteAdminException(
      message:
          'Device-Session unbekannt oder widerrufen — bitte neu '
          'einrichten.',
    );
  }

  final site = await Site.db.findFirstRow(
    session,
    where: (t) => t.id.equals(deviceSession.siteId),
  );
  if (site == null) {
    throw SiteAdminException(message: 'Site fehlt — bitte neu einrichten.');
  }
  return site;
}
