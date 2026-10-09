/// Package-level switches for the shared frontend components.
///
/// `kProfileEditingEnabled`: profiles are edited via the global instance's
/// `memberProfile` endpoints. Apps embedding the shared widgets against a
/// backend whose profile data they must not edit (mirrors) should only use
/// the read-only display branch; the flag is a package-level default and can
/// be overruled by the host by not wiring the editing calls.
const bool kProfileEditingEnabled = true;
