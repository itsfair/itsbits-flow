#pragma once

#include <Arduino.h>
#include <Preferences.h>

/// Connection to the local instance (itsbits-flow local server): stores
/// the backend config in NVS (namespace "backend") and performs the
/// access-verification calls for BLE requests. Plain HTTP into the LAN
/// (MVP; device auth/TLS is a known hardening item).
class BackendClient {
public:
    struct VerifyResult {
        bool httpOk = false;   // the backend was reached and answered
        bool ok = false;       // access granted
        String code;           // OK / ACCESS_DENIED / RATE_LIMITED / CRED_INVALID / SERVER_ERROR
        String message;
    };

    void begin();
    bool isConfigured() const;
    String getUrl() const { return _url; }
    int getSiteId() const { return _siteId; }

    /// Validates and stores the config (url = host[:port] or with
    /// http:// prefix; siteId = positive int). Returns false + [error]
    /// on invalid input — nothing is stored then.
    bool setConfig(const String& url, const String& siteId, String& error);

    /// POSTs one verification request to `<url>/api/door/verify`.
    VerifyResult verify(const String& userKey, const String& code, const String& deviceMac);

private:
    String _url;
    int _siteId = 0;
};
