#pragma once

#include <Arduino.h>
#include <NimBLEDevice.h>

class NukiManager;
class BackendClient;

/// BLE peripheral for the smartphone app: receives JSON requests,
/// verifies the credential against the local backend and — on success —
/// unlatches the NUKI lock. Spec: docs/ble_interface.md.
class BleServer {
public:
    void begin(const String& deviceName, NukiManager* nuki, BackendClient* backend);
    void loop();
    void sendResponse(const String& resp);
    String getAddress();
    void queueRequest(const String& action, const String& userId, const String& code, const String& timestampMs, const String& deviceId);

private:
    NukiManager* _nuki = nullptr;
    BackendClient* _backend = nullptr;
    String _pendingAction = "";
    String _pendingUserId = "";
    String _pendingCode = "";
    String _pendingTimestampMs = "";
    String _pendingDeviceId = "";

    void handleRequest(const String& action, const String& userId, const String& code, const String& timestampMs, bool& success, String& codeOut, String& messageOut);
};
