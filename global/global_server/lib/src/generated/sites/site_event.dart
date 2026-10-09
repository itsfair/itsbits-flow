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
import 'package:serverpod/serverpod.dart' as _is;

/// Server to client event on the site connection stream.
abstract class SiteEvent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SiteEvent._({
    int? pongSentAtMs,
    int? pingSentAtMs,
    int? sentAtMs,
    bool? needsSiteSync,
  }) : pongSentAtMs = pongSentAtMs ?? 0,
       pingSentAtMs = pingSentAtMs ?? 0,
       sentAtMs = sentAtMs ?? 0,
       needsSiteSync = needsSiteSync ?? false;

  factory SiteEvent({
    int? pongSentAtMs,
    int? pingSentAtMs,
    int? sentAtMs,
    bool? needsSiteSync,
  }) = _SiteEventImpl;

  factory SiteEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return SiteEvent(
      pongSentAtMs: jsonSerialization['pongSentAtMs'] as int?,
      pingSentAtMs: jsonSerialization['pingSentAtMs'] as int?,
      sentAtMs: jsonSerialization['sentAtMs'] as int?,
      needsSiteSync: jsonSerialization['needsSiteSync'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['needsSiteSync']),
    );
  }

  /// Acknowledgement for a received ping.
  int pongSentAtMs;

  /// Round trip marker: matches `SitePing.sentAtMs` when pong.
  int pingSentAtMs;

  /// Millisecond timestamp of the senders send time.
  int sentAtMs;

  /// Set (true) when the server pushes spontaneously (queue-triggered):
  /// the client should pull pending sync tasks from `siteSync` now.
  bool needsSiteSync;

  /// Returns a shallow copy of this [SiteEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SiteEvent copyWith({
    int? pongSentAtMs,
    int? pingSentAtMs,
    int? sentAtMs,
    bool? needsSiteSync,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteEvent',
      'pongSentAtMs': pongSentAtMs,
      'pingSentAtMs': pingSentAtMs,
      'sentAtMs': sentAtMs,
      'needsSiteSync': needsSiteSync,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SiteEvent',
      'pongSentAtMs': pongSentAtMs,
      'pingSentAtMs': pingSentAtMs,
      'sentAtMs': sentAtMs,
      'needsSiteSync': needsSiteSync,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SiteEventImpl extends SiteEvent {
  _SiteEventImpl({
    int? pongSentAtMs,
    int? pingSentAtMs,
    int? sentAtMs,
    bool? needsSiteSync,
  }) : super._(
         pongSentAtMs: pongSentAtMs,
         pingSentAtMs: pingSentAtMs,
         sentAtMs: sentAtMs,
         needsSiteSync: needsSiteSync,
       );

  /// Returns a shallow copy of this [SiteEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SiteEvent copyWith({
    int? pongSentAtMs,
    int? pingSentAtMs,
    int? sentAtMs,
    bool? needsSiteSync,
  }) {
    return SiteEvent(
      pongSentAtMs: pongSentAtMs ?? this.pongSentAtMs,
      pingSentAtMs: pingSentAtMs ?? this.pingSentAtMs,
      sentAtMs: sentAtMs ?? this.sentAtMs,
      needsSiteSync: needsSiteSync ?? this.needsSiteSync,
    );
  }
}
