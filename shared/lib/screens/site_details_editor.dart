import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../site_directory.dart';
import '../widgets/site_card.dart';

/// Backend contract for editing a site's properties at the LOCAL instance
/// (the local one owns site data and pushes it to the global one — the
/// reversed direction of the member-profile rule). Validation/propagation
/// are enforced server-side; hosts surface thrown errors as snack bars.
abstract interface class SiteDetailsApi {
  Future<SiteData> get();

  Future<SiteData> save({
    required final String name,
    required final String street,
    required final String zipCode,
    required final String city,
    required final String country,
    required final String companyEmail,
  });

  Future<SiteData> setSiteImage({required final Uint8List image});

  Future<SiteData> removeSiteImage();
}

/// Site-details editor (or read-only view): fields + JPEG image, mirroring
/// the shared profile screen's patterns (image picker, save button).
/// Editing is host-decided via [editingEnabled]; connectivity is enforced
/// SERVER-side (offline saves are rejected with an explanatory message in
/// the snack bar; the hint below notes the offline state upfront).
class SiteDetailsEditorScreen extends StatefulWidget {
  final SiteDetailsApi api;

  /// Show edit controls (fields + image + save). Hosts run a static
  /// detail view with `false`.
  final bool editingEnabled;

  const SiteDetailsEditorScreen({
    required this.api,
    this.editingEnabled = true,
    super.key,
  });

  @override
  State<SiteDetailsEditorScreen> createState() =>
      _SiteDetailsEditorScreenState();
}

class _SiteDetailsEditorScreenState extends State<SiteDetailsEditorScreen> {
  SiteData? _site;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  Uint8List? _pickedImage;

  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _emailController = TextEditingController();

  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    [
      _nameController,
      _streetController,
      _zipCodeController,
      _cityController,
      _countryController,
      _emailController,
    ].forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final site = await widget.api.get();
      if (!mounted) return;
      setState(() {
        _site = site;
        _nameController.text = site.name;
        _streetController.text = site.street;
        _zipCodeController.text = site.zipCode;
        _cityController.text = site.city;
        _countryController.text = site.country;
        _emailController.text = site.companyEmail;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickImage() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => _pickedImage = bytes);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final street = _streetController.text.trim();
    final zipCode = _zipCodeController.text.trim();
    final city = _cityController.text.trim();
    final country = _countryController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty ||
        street.isEmpty ||
        zipCode.isEmpty ||
        city.isEmpty ||
        country.isEmpty ||
        email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alle Felder sind Pflichtfelder.')),
      );
      return;
    }

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      var site = await widget.api.save(
        name: name,
        street: street,
        zipCode: zipCode,
        city: city,
        country: country,
        companyEmail: email,
      );

      if (_pickedImage != null) {
        site = await widget.api.setSiteImage(image: _pickedImage!);
      }

      if (!mounted) return;
      setState(() => _site = site);
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Standort gespeichert und an die globale Instanz übertragen.',
          ),
        ),
      );
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Speichern fehlgeschlagen: $e')),
      );
    } finally {
      if (mounted)
        setState(() {
          _saving = false;
          _pickedImage = null;
        });
    }
  }

  @override
  Widget build(final BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Laden fehlgeschlagen: $_error'),
            TextButton(onPressed: _load, child: const Text('Erneut versuchen')),
          ],
        ),
      );
    }

    final site = _site!;
    final editing = widget.editingEnabled;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageSection(site, editing),
          _buildFields(site, editing),
          _buildConnectionHint(editing),
          if (editing) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Speichern'),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildImageSection(final SiteData site, final bool editing) {
    final Widget preview = _pickedImage != null
        ? Image.memory(_pickedImage!, fit: BoxFit.cover)
        : SiteImage(imageUrl: site.imageUrl);

    return Column(
      children: [
        SizedBox(height: 150, child: ClipRRect(child: preview)),
        if (editing) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _saving ? null : _pickImage,
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Standortbild wählen'),
          ),
          const Text('(optional, JPEG)', style: TextStyle(fontSize: 12)),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFields(final SiteData site, final bool editing) {
    if (!editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(site.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('${site.street}\n${site.zipCode} ${site.city}\n${site.country}'),
          const SizedBox(height: 8),
          Text('Kontakt: ${site.companyEmail}'),
          const SizedBox(height: 16),
        ],
      );
    }

    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.storefront_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _streetController,
          decoration: const InputDecoration(
            labelText: 'Straße',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.signpost_outlined),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'PLZ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Stadt',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _countryController,
          decoration: const InputDecoration(
            labelText: 'Land',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Firmen-E-Mail',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.alternate_email),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Connectivity note — the exact failure surface stays server-side.
  Widget _buildConnectionHint(final bool editing) {
    if (!editing || (_site?.isOnline ?? false)) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: 18, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Die globale Instanz ist gerade nicht erreichbar — '
              'Speichern ist erst bei bestehender Verbindung möglich.',
            ),
          ),
        ],
      ),
    );
  }
}
