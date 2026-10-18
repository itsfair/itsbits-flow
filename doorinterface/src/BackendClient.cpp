#include "BackendClient.h"
#include <HTTPClient.h>
#include <WiFiClient.h>

static String extractJsonString(const String& json, const String& key) {
    String needle = "\"" + key + "\"";
    int k = json.indexOf(needle);
    if (k < 0) return "";
    int c = json.indexOf(':', k);
    if (c < 0) return "";
    c = json.indexOf('"', c);
    if (c < 0) return "";
    int end = json.indexOf('"', c + 1);
    if (end < 0) return "";
    return json.substring(c + 1, end);
}

static String jsonEscape(const String& value) {
    String out;
    out.reserve(value.length());
    for (size_t i = 0; i < value.length(); i++) {
        char c = value.charAt(i);
        if (c == '"' || c == '\\') {
            out += '\\';
            out += c;
        } else if (c < 0x20) {
            out += ' ';
        } else {
            out += c;
        }
    }
    return out;
}

void BackendClient::begin() {
    Preferences prefs;
    prefs.begin("backend", true);
    _url = prefs.getString("url", "");
    _siteId = prefs.getInt("siteId", 0);
    prefs.end();
    if (isConfigured()) {
        Serial.printf("[BE] backend=%s siteId=%d\n", _url.c_str(), _siteId);
    } else {
        Serial.println("[BE] nicht konfiguriert");
    }
}

bool BackendClient::isConfigured() const {
    return _url.length() > 0 && _siteId > 0;
}

bool BackendClient::setConfig(const String& urlIn, const String& siteIdIn, String& error) {
    String url = urlIn;
    url.trim();
    url.toLowerCase();
    if (url.startsWith("https://")) {
        error = "Nur http wird unterstuetzt";
        return false;
    }
    if (url.startsWith("http://")) url = url.substring(7);
    while (url.endsWith("/")) url.remove(url.length() - 1);
    if (url.isEmpty() || url.indexOf('/') >= 0 || url.indexOf(' ') >= 0) {
        error = "Ungueltige URL (nur host[:port])";
        return false;
    }
    int siteId = siteIdIn.toInt();
    if (siteId <= 0) {
        error = "Ungueltige Site-ID";
        return false;
    }

    Preferences prefs;
    prefs.begin("backend", false);
    prefs.putString("url", url);
    prefs.putInt("siteId", siteId);
    prefs.end();

    _url = url;
    _siteId = siteId;
    Serial.printf("[BE] Konfiguration gespeichert: url=%s siteId=%d\n", url.c_str(), siteId);
    return true;
}

BackendClient::VerifyResult BackendClient::verify(const String& userKey, const String& code, const String& timestampMs, const String& deviceMac) {
    VerifyResult r;
    if (!isConfigured()) {
        r.code = "DEVICE_UNCONFIGURED";
        r.message = "Backend nicht konfiguriert";
        return r;
    }

    String body = "{";
    body += "\"userKey\":\"" + jsonEscape(userKey) + "\"";
    body += ",\"code\":\"" + jsonEscape(code) + "\"";
    body += ",\"timestampMs\":" + jsonEscape(timestampMs);
    body += ",\"siteId\":" + String(_siteId);
    body += ",\"deviceMac\":\"" + jsonEscape(deviceMac) + "\"";
    body += "}";

    WiFiClient wifiClient;
    HTTPClient http;
    http.setReuse(false);
    http.setTimeout(8000);
    String endpoint = "http://" + _url + "/api/door/verify";
    if (!http.begin(wifiClient, endpoint)) {
        r.code = "BACKEND_UNREACHABLE";
        r.message = "Verbindung fehlgeschlagen";
        return r;
    }
    http.addHeader("Content-Type", "application/json");
    Serial.printf("[BE] verify user=%s code=%s ts=%s\n", userKey.c_str(), code.c_str(), timestampMs.c_str());
    int status = http.POST(body);
    if (status <= 0) {
        Serial.printf("[BE] Fehler: %s\n", HTTPClient::errorToString(status).c_str());
        http.end();
        r.code = "BACKEND_UNREACHABLE";
        r.message = "Backend nicht erreichbar";
        return r;
    }
    String response = http.getString();
    http.end();
    Serial.printf("[BE] Antwort (%d): %s\n", status, response.c_str());

    r.httpOk = true;
    r.ok = response.indexOf("\"ok\":true") >= 0;
    r.code = extractJsonString(response, "code");
    r.message = extractJsonString(response, "message");
    if (r.code.isEmpty()) {
        r.code = r.ok ? "OK" : "ACCESS_DENIED";
    }
    if (r.message.isEmpty()) {
        r.message = r.ok ? "Zugang gewaehrt" : "Zugang verweigert";
    }
    return r;
}
