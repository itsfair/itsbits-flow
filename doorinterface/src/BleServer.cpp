#include "BleServer.h"
#include "NukiManager.h"
#include "BackendClient.h"

#define SERVICE_UUID        "5f6d4f5a-0001-0001-8000-00805f9b34fb"
#define CHAR_REQUEST_UUID   "5f6d4f5a-0002-0001-8000-00805f9b34fb"
#define CHAR_RESPONSE_UUID  "5f6d4f5a-0003-0001-8000-00805f9b34fb"

static String extractField(const String& json, const String& key) {
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

class ServerCallbacks : public NimBLEServerCallbacks {
    void onConnect(NimBLEServer*) override {
        Serial.println("[BLE] client connected");
    }
    void onDisconnect(NimBLEServer*) override {
        Serial.println("[BLE] client disconnected");
        NimBLEDevice::getAdvertising()->start();
    }
};

class RequestCallbacks : public NimBLECharacteristicCallbacks {
    BleServer* _owner;
public:
    RequestCallbacks(BleServer* o) : _owner(o) {}
    void onWrite(NimBLECharacteristic* pChar) override {
        std::string val = pChar->getValue();
        String payload = String(val.c_str());
        Serial.printf("[BLE] RX (%d bytes): %s\n", (int)val.size(), payload.c_str());

        String action   = extractField(payload, "action");
        String userId   = extractField(payload, "userId");
        String code     = extractField(payload, "code");
        String deviceId = extractField(payload, "deviceId");
        Serial.printf("[BLE] parsed: action=%s userId=%s code=%s deviceId=%s\n",
            action.c_str(), userId.c_str(), code.c_str(), deviceId.c_str());
        _owner->queueRequest(action, userId, code, deviceId);
    }
};

void BleServer::begin(const String& deviceName, NukiManager* nuki, BackendClient* backend) {
    _nuki = nuki;
    _backend = backend;
    Serial.println("[BLE] init server");
    NimBLEDevice::init(deviceName.c_str());
    NimBLEDevice::setMTU(128);

    NimBLEServer* server = NimBLEDevice::createServer();
    server->setCallbacks(new ServerCallbacks());

    NimBLEService* service = server->createService(SERVICE_UUID);
    NimBLECharacteristic* requestChar = service->createCharacteristic(
        CHAR_REQUEST_UUID, NIMBLE_PROPERTY::WRITE | NIMBLE_PROPERTY::WRITE_NR);
    requestChar->setCallbacks(new RequestCallbacks(this));
    NimBLECharacteristic* responseChar = service->createCharacteristic(
        CHAR_RESPONSE_UUID, NIMBLE_PROPERTY::NOTIFY);
    service->start();

    NimBLEAdvertising* adv = NimBLEDevice::getAdvertising();
    adv->addServiceUUID(SERVICE_UUID);
    adv->setScanResponse(true);
    adv->setMinInterval(0x20);
    adv->setMaxInterval(0x40);
    adv->start();
    Serial.printf("[BLE] advertising name='%s'\n", deviceName.c_str());
    Serial.printf("[BLE] mac=%s\n", getAddress().c_str());
}

String BleServer::getAddress() {
    return String(NimBLEDevice::getAddress().toString().c_str());
}

void BleServer::loop() {
    if (_pendingAction.isEmpty()) return;
    String action = _pendingAction;
    String userId = _pendingUserId;
    String code = _pendingCode;
    _pendingAction = "";
    _pendingUserId = "";
    _pendingCode = "";
    _pendingDeviceId = "";

    bool success = false;
    String respCode, message;
    handleRequest(action, userId, code, success, respCode, message);

    String resp = "{\"success\":";
    resp += success ? "true" : "false";
    resp += ",\"code\":\"" + respCode + "\"";
    resp += ",\"message\":\"" + message + "\"";
    resp += "}";
    Serial.printf("[BLE] TX: %s\n", resp.c_str());
    sendResponse(resp);
}

/// Real credential flow: every verification goes through the local
/// backend (door-bound TOTP, single-use). A granted 'open' consumes the
/// code and unlatches; 'test' verifies without a door action. The
/// NOT_PAIRED check runs BEFORE verification so a failed open does not
/// waste the user's single-use code.
void BleServer::handleRequest(const String& action, const String& userId, const String& code, bool& success, String& codeOut, String& messageOut) {
    if (action != "open" && action != "test") {
        success = false; codeOut = "UNKNOWN_ACTION"; messageOut = "Aktion unbekannt";
        return;
    }
    if (!_backend || !_backend->isConfigured()) {
        success = false; codeOut = "DEVICE_UNCONFIGURED"; messageOut = "Backend nicht konfiguriert";
        return;
    }
    if (action == "open" && (!_nuki || !_nuki->isPaired())) {
        success = false; codeOut = "NOT_PAIRED"; messageOut = "Kein Schloss gepaart";
        return;
    }
    if (userId.isEmpty() || code.isEmpty()) {
        success = false; codeOut = "CRED_INVALID"; messageOut = "Zugangsdaten unvollstaendig";
        return;
    }

    BackendClient::VerifyResult v = _backend->verify(userId, code, getAddress());
    if (!v.httpOk) {
        success = false; codeOut = "BACKEND_UNREACHABLE";
        messageOut = v.message.isEmpty() ? String("Backend nicht erreichbar") : v.message;
        return;
    }
    if (!v.ok) {
        success = false;
        codeOut = v.code.isEmpty() ? String("ACCESS_DENIED") : v.code;
        messageOut = v.message.isEmpty() ? String("Zugang verweigert") : v.message;
        return;
    }

    if (action == "test") {
        success = true; codeOut = "TEST_OK"; messageOut = "Zugang gueltig (Test ohne Tueraktion)";
        return;
    }
    if (_nuki->unlatch()) {
        success = true; codeOut = "OK"; messageOut = "Tuer geoeffnet";
        return;
    }
    success = false; codeOut = "LOCK_FAILED"; messageOut = "Oeffnen fehlgeschlagen";
}

void BleServer::queueRequest(const String& action, const String& userId, const String& code, const String& deviceId) {
    _pendingAction = action;
    _pendingUserId = userId;
    _pendingCode = code;
    _pendingDeviceId = deviceId;
}

void BleServer::sendResponse(const String& resp) {
    NimBLECharacteristic* responseChar = NimBLEDevice::getServer()->getServiceByUUID(SERVICE_UUID)->getCharacteristic(CHAR_RESPONSE_UUID);
    if (responseChar && responseChar->getSubscribedCount() > 0) {
        responseChar->setValue(std::string(resp.c_str()));
        responseChar->notify();
    }
}
