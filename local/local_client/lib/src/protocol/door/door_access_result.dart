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

/// Outcome of one door-access verification attempt (access log result).
enum DoorAccessResult implements _isc.SerializableModel {
  /// Code valid, membership active, not replayed — the door opens.
  granted,

  /// Well-formed request, but the credential check failed (unknown user,
  /// inactive membership, wrong/expired code, replay). Uniform denial —
  /// no information leak about WHICH check failed.
  denied,

  /// Too many denied attempts for this user in a short window.
  rateLimited,

  /// Malformed request (missing/invalid fields) — not even verifiable.
  invalid,

  /// Infrastructure failure (site not set up, database error, ...).
  error;

  static DoorAccessResult fromJson(String name) {
    switch (name) {
      case 'granted':
        return DoorAccessResult.granted;
      case 'denied':
        return DoorAccessResult.denied;
      case 'rateLimited':
        return DoorAccessResult.rateLimited;
      case 'invalid':
        return DoorAccessResult.invalid;
      case 'error':
        return DoorAccessResult.error;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DoorAccessResult"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
