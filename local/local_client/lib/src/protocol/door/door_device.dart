/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// One doorinterface (ESP32) in the site's LAN, registered by the local
/// admin. MVP: LAN-only, manually managed — the address is entered by
/// hand (IP or hostname incl. local network domain, optional port); the
/// server calls the device's HTTP API from here.
abstract class DoorDevice
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DoorDevice._({
    this.id,
    required this.name,
    required this.address,
    this.mac,
    this.configuredAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DoorDevice({
    int? id,
    required String name,
    required String address,
    String? mac,
    DateTime? configuredAt,
    DateTime? createdAt,
  }) = _DoorDeviceImpl;

  factory DoorDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorDevice(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      mac: jsonSerialization['mac'] as String?,
      configuredAt: jsonSerialization['configuredAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['configuredAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Display name of the device (e.g. "Hauseingang"); free text.
  String name;

  /// Address as entered by the admin: `192.168.1.50`, `door-1a2b.local`,
  /// optionally `host:port` (leading scheme is stripped).
  String address;

  /// The device's BLE MAC (reported in the config-push ACK) — used to
  /// attribute access-log entries to a registered device.
  String? mac;

  /// When the backend config (serverUrl + siteId) was last pushed to the
  /// device successfully (null = not yet configured).
  DateTime? configuredAt;

  /// When the device row was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [DoorDevice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DoorDevice copyWith({
    int? id,
    String? name,
    String? address,
    String? mac,
    DateTime? configuredAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorDevice',
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      if (mac != null) 'mac': mac,
      if (configuredAt != null) 'configuredAt': configuredAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorDevice',
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      if (mac != null) 'mac': mac,
      if (configuredAt != null) 'configuredAt': configuredAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorDeviceImpl extends DoorDevice {
  _DoorDeviceImpl({
    int? id,
    required String name,
    required String address,
    String? mac,
    DateTime? configuredAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         address: address,
         mac: mac,
         configuredAt: configuredAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DoorDevice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DoorDevice copyWith({
    Object? id = _Undefined,
    String? name,
    String? address,
    Object? mac = _Undefined,
    Object? configuredAt = _Undefined,
    DateTime? createdAt,
  }) {
    return DoorDevice(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      mac: mac is String? ? mac : this.mac,
      configuredAt: configuredAt is DateTime?
          ? configuredAt
          : this.configuredAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
