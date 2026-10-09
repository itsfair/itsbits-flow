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

/// Public projection of a site for the end-user directory (`siteDirectory`
/// endpoint — no login required for browsing). Deliberately omits internal
/// linkage (firstAdmin, raw heartbeat timestamps); the connectivity state
/// travels as a computed boolean.
abstract class SitePublic
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SitePublic._({
    required this.id,
    required this.name,
    required this.street,
    required this.zipCode,
    required this.city,
    required this.country,
    required this.companyEmail,
    this.imageUrl,
    required this.isOnline,
    required this.createdAt,
  });

  factory SitePublic({
    required int id,
    required String name,
    required String street,
    required String zipCode,
    required String city,
    required String country,
    required String companyEmail,
    String? imageUrl,
    required bool isOnline,
    required DateTime createdAt,
  }) = _SitePublicImpl;

  factory SitePublic.fromJson(Map<String, dynamic> jsonSerialization) {
    return SitePublic(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      street: jsonSerialization['street'] as String,
      zipCode: jsonSerialization['zipCode'] as String,
      city: jsonSerialization['city'] as String,
      country: jsonSerialization['country'] as String,
      companyEmail: jsonSerialization['companyEmail'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      isOnline: _isc.BoolJsonExtension.fromJson(jsonSerialization['isOnline']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  String name;

  String street;

  String zipCode;

  String city;

  String country;

  String companyEmail;

  /// Public site image URL (placeholder until the upload feature exists).
  String? imageUrl;

  /// Computed server-side from the lastSeenAt heartbeat freshness.
  bool isOnline;

  /// When the site record was created (carousel order: newest first).
  DateTime createdAt;

  /// Returns a shallow copy of this [SitePublic]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SitePublic copyWith({
    int? id,
    String? name,
    String? street,
    String? zipCode,
    String? city,
    String? country,
    String? companyEmail,
    String? imageUrl,
    bool? isOnline,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SitePublic',
      'id': id,
      'name': name,
      'street': street,
      'zipCode': zipCode,
      'city': city,
      'country': country,
      'companyEmail': companyEmail,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'isOnline': isOnline,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SitePublic',
      'id': id,
      'name': name,
      'street': street,
      'zipCode': zipCode,
      'city': city,
      'country': country,
      'companyEmail': companyEmail,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'isOnline': isOnline,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SitePublicImpl extends SitePublic {
  _SitePublicImpl({
    required int id,
    required String name,
    required String street,
    required String zipCode,
    required String city,
    required String country,
    required String companyEmail,
    String? imageUrl,
    required bool isOnline,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         street: street,
         zipCode: zipCode,
         city: city,
         country: country,
         companyEmail: companyEmail,
         imageUrl: imageUrl,
         isOnline: isOnline,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SitePublic]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SitePublic copyWith({
    int? id,
    String? name,
    String? street,
    String? zipCode,
    String? city,
    String? country,
    String? companyEmail,
    Object? imageUrl = _Undefined,
    bool? isOnline,
    DateTime? createdAt,
  }) {
    return SitePublic(
      id: id ?? this.id,
      name: name ?? this.name,
      street: street ?? this.street,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      country: country ?? this.country,
      companyEmail: companyEmail ?? this.companyEmail,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
