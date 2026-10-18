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

/// The signed-in user's own TOTP door secret for one site, delivered to
/// the end-user app on demand (cached there in secure storage; door
/// codes are then computed offline).
abstract class MyDoorSecretInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MyDoorSecretInfo._({
    required this.siteId,
    required this.siteName,
    required this.secret,
  });

  factory MyDoorSecretInfo({
    required int siteId,
    required String siteName,
    required String secret,
  }) = _MyDoorSecretInfoImpl;

  factory MyDoorSecretInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyDoorSecretInfo(
      siteId: jsonSerialization['siteId'] as int,
      siteName: jsonSerialization['siteName'] as String,
      secret: jsonSerialization['secret'] as String,
    );
  }

  /// The site the secret belongs to (matches the QR's site field).
  int siteId;

  /// Display name of the site.
  String siteName;

  /// The per-(person, site) secret (hex, 32 bytes) for HMAC code
  /// computation.
  String secret;

  /// Returns a shallow copy of this [MyDoorSecretInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MyDoorSecretInfo copyWith({
    int? siteId,
    String? siteName,
    String? secret,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyDoorSecretInfo',
      'siteId': siteId,
      'siteName': siteName,
      'secret': secret,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyDoorSecretInfo',
      'siteId': siteId,
      'siteName': siteName,
      'secret': secret,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MyDoorSecretInfoImpl extends MyDoorSecretInfo {
  _MyDoorSecretInfoImpl({
    required int siteId,
    required String siteName,
    required String secret,
  }) : super._(
         siteId: siteId,
         siteName: siteName,
         secret: secret,
       );

  /// Returns a shallow copy of this [MyDoorSecretInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MyDoorSecretInfo copyWith({
    int? siteId,
    String? siteName,
    String? secret,
  }) {
    return MyDoorSecretInfo(
      siteId: siteId ?? this.siteId,
      siteName: siteName ?? this.siteName,
      secret: secret ?? this.secret,
    );
  }
}
