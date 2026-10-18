import 'package:flutter/material.dart';

/// Add/edit dialog for one doorinterface (name + LAN address). Used
/// empty (add) and pre-filled (edit) from the host app.
class DoorDeviceDialog extends StatefulWidget {
  final String? initialName;
  final String? initialAddress;

  const DoorDeviceDialog({this.initialName, this.initialAddress, super.key});

  /// Returns the entered values, or null when cancelled/not valid.
  static Future<(String, String)?> show(
    final BuildContext context, {
    final String? initialName,
    final String? initialAddress,
  }) {
    return showDialog<(String, String)>(
      context: context,
      builder: (_) => DoorDeviceDialog(
        initialName: initialName,
        initialAddress: initialAddress,
      ),
    );
  }

  @override
  State<DoorDeviceDialog> createState() => _DoorDeviceDialogState();
}

class _DoorDeviceDialogState extends State<DoorDeviceDialog> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );
  late final TextEditingController _addressController = TextEditingController(
    text: widget.initialAddress ?? '',
  );

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isAdd = widget.initialName == null && widget.initialAddress == null;

    return AlertDialog(
      title: Text(isAdd ? 'Gerät hinzufügen' : 'Gerät bearbeiten'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'z. B. Hauseingang',
              ),
              validator: (value) => (value ?? '').trim().isEmpty
                  ? 'Bitte einen Namen angeben.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                hintText: 'IP oder hostname.local (:port optional)',
              ),
              validator: (value) {
                final v = (value ?? '').trim();
                if (v.isEmpty) return 'Bitte eine Adresse angeben.';
                if (v.contains('/')) return 'Keine Pfade — nur host[:port].';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isAdd ? 'Hinzufügen' : 'Speichern'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(
      context,
    ).pop((_nameController.text.trim(), _addressController.text.trim()));
  }
}
