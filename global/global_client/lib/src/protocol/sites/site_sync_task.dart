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
import 'package:global_client/src/protocol/protocol.dart' as _i03ltx34;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../profile/member_profile.dart' as _ieelrt66;
import '../sites/site.dart' as _ie3onmsc;

/// One pending member-data delivery to a site's local instance. Written
/// ALWAYS first (queue is the source of truth); a connected site is
/// additionally kicked over its method stream so it pulls immediately.
/// The pull response assembles the CURRENT global state (profile fields,
/// role, active) from the live database, so entries for the same
/// person+site collapse via the unique index — no per-change history.
/// Rows are deleted only after the local instance confirmed processing
/// (no lost updates when the site dies mid-transfer).
abstract class SiteSyncTask
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SiteSyncTask._({
    this.id,
    required this.siteId,
    this.site,
    required this.profileId,
    this.profile,
    int? attempts,
    this.lastError,
    DateTime? createdAt,
  }) : attempts = attempts ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory SiteSyncTask({
    int? id,
    required int siteId,
    _ie3onmsc.Site? site,
    required int profileId,
    _ieelrt66.MemberProfile? profile,
    int? attempts,
    String? lastError,
    DateTime? createdAt,
  }) = _SiteSyncTaskImpl;

  factory SiteSyncTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return SiteSyncTask(
      id: jsonSerialization['id'] as int?,
      siteId: jsonSerialization['siteId'] as int,
      site: jsonSerialization['site'] == null
          ? null
          : _i03ltx34.Protocol().deserialize<_ie3onmsc.Site>(
              jsonSerialization['site'],
            ),
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i03ltx34.Protocol().deserialize<_ieelrt66.MemberProfile>(
              jsonSerialization['profile'],
            ),
      attempts: jsonSerialization['attempts'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int siteId;

  /// The site the data must be delivered to.
  _ie3onmsc.Site? site;

  int profileId;

  /// The person whose profile/membership changed.
  _ieelrt66.MemberProfile? profile;

  /// Delivery attempts so far (capped; keeps the row on failure).
  int attempts;

  /// Last delivery error (processing/diagnostics).
  String? lastError;

  /// When the pending delivery was noted (refreshed on collapse).
  DateTime createdAt;

  /// Returns a shallow copy of this [SiteSyncTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SiteSyncTask copyWith({
    int? id,
    int? siteId,
    _ie3onmsc.Site? site,
    int? profileId,
    _ieelrt66.MemberProfile? profile,
    int? attempts,
    String? lastError,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteSyncTask',
      if (id != null) 'id': id,
      'siteId': siteId,
      if (site != null) 'site': site?.toJson(),
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
      'attempts': attempts,
      if (lastError != null) 'lastError': lastError,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SiteSyncTask',
      if (id != null) 'id': id,
      'siteId': siteId,
      if (site != null) 'site': site?.toJsonForProtocol(),
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      'attempts': attempts,
      if (lastError != null) 'lastError': lastError,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SiteSyncTaskImpl extends SiteSyncTask {
  _SiteSyncTaskImpl({
    int? id,
    required int siteId,
    _ie3onmsc.Site? site,
    required int profileId,
    _ieelrt66.MemberProfile? profile,
    int? attempts,
    String? lastError,
    DateTime? createdAt,
  }) : super._(
         id: id,
         siteId: siteId,
         site: site,
         profileId: profileId,
         profile: profile,
         attempts: attempts,
         lastError: lastError,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SiteSyncTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SiteSyncTask copyWith({
    Object? id = _Undefined,
    int? siteId,
    Object? site = _Undefined,
    int? profileId,
    Object? profile = _Undefined,
    int? attempts,
    Object? lastError = _Undefined,
    DateTime? createdAt,
  }) {
    return SiteSyncTask(
      id: id is int? ? id : this.id,
      siteId: siteId ?? this.siteId,
      site: site is _ie3onmsc.Site? ? site : this.site?.copyWith(),
      profileId: profileId ?? this.profileId,
      profile: profile is _ieelrt66.MemberProfile?
          ? profile
          : this.profile?.copyWith(),
      attempts: attempts ?? this.attempts,
      lastError: lastError is String? ? lastError : this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
