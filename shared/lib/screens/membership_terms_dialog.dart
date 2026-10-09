import 'package:flutter/material.dart';

/// Legal consent dialog before subscribing to a site. Lists exactly the
/// data transferred to the site's local instance and the purpose (door
/// access + local membership handling), plus the affected DSGVO rights.
///
/// !!! Privacy-review TODO (root AGENTS.md): the default text is a simple
/// draft in line with current German data protection law (DSGVO/BDSG) and
/// must be revisited (a) once the data set changes (new fields, image
/// semantics, deletion concepts) and (b) by the legal review before
/// production. Arts. 13/14 obligations (full information duty) are NOT
/// fully covered here in detail — intentionally kept short for the first
/// version.
Future<bool> showMembershipTermsDialog(
  final BuildContext context, {
  required final String siteName,
  final String? companyEmail,
}) async {
  final result = await showAdaptiveDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Mitgliedschaft abschließen'),
      scrollable: true,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wenn du dich bei "$siteName" als Mitglied registrierst, '
              'werden folgende Daten an den Betreiber übermittelt und dort '
              'gespeichert:',
            ),
            const SizedBox(height: 8),
            const Text(
              '· Dein personenbezogener Identifikator (Zugangscode)\n'
              '· E-Mail-Adresse\n'
              '· Vor- und Nachname\n'
              '· Geburtsdatum\n'
              '· Profilbild (falls hinterlegt)',
            ),
            const SizedBox(height: 12),
            const Text(
              'Zweck: Der Identifikator dient der Zugangskontrolle (Tür-'
              'öffnung am Standort) und der Verwaltung deiner Mitgliedschaft '
              'vor Ort. Ohne diese Datenübermittlung ist kein digitaler '
              'Zutritt möglich.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Speicherung: Die Daten verbleiben beim Site-Betreiber, '
              'solange deine Mitgliedschaft besteht. Änderungen an deinem '
              'Profil werden automatisch an die Site übertragen.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Widerruf: Du kannst deine Mitgliedschaft in der App '
              'jederzeit beenden. Bereits übermittelte Daten werden dabei '
              'nicht gelöscht, sondern nur aus der Nutzungsfähigkeit '
              'entfernt, damit späterer Einblick möglich bleibt — unsere '
              'endgültigen Löschfristen/Abläufe (Art. 17 DSGVO) sind noch '
              'nicht abgeschlossen.',
            ),
            const SizedBox(height: 12),
            Text(
              'Betroffenenrechte (Auskunft, Berichtigung, Löschung etc.) '
              'machst du gegenüber dem Site-Betreiber geltend:'
              '${companyEmail == null ? '' : '\n$companyEmail'}',
            ),
            const SizedBox(height: 12),
            const Text(
              'Mit dem Bestätigen stimmst du der beschriebenen '
              'Datenübermittlung und -verarbeitung zu.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Einverstanden'),
        ),
      ],
    ),
  );
  return result ?? false;
}
