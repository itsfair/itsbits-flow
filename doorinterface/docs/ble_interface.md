# DoorInterface — BLE-Schnittstelle (ESP → Smartphone-App)

Schnittstelle für die direkte Kommunikation zwischen der Enduser-Smartphone-App
und dem ESP32 per Bluetooth Low Energy (BLE). Status: **mit Backend-Anbindung**
— jede Credential-Prüfung läuft über die lokale Instanz (`/api/door/verify`),
Türöffnung per NUKI (`unlatch()`).

## Übersicht

```
Smartphone-App                ESP32 (Peripheral)              Lokale Instanz
     │                              │                              │
     │── BLE Scan ─────────────────>│                              │
     │── BLE Connect ─────────────>│ (onConnect)                  │
     │── Write Request ───────────>│ (onWrite)                    │
     │                              │── POST /api/door/verify ───>│ (TOTP-Prüfung)
     │                              │<── {ok, code, message} ─────│ (offline, kein Global-
     │<── Notify Response ─────────│                              │  Round-Trip)
     │── BLE Disconnect ──────────>│ (onDisconnect → Adv restart) │
```

## GATT-Struktur

| Element              | UUID                                  | Bedeutung / Richtung                                |
|----------------------|---------------------------------------|-----------------------------------------------------|
| **Service**          | `5f6d4f5a-0001-0001-8000-00805f9b34fb` | DoorInterface-Befehlsservice                        |
| **Char. Request**    | `5f6d4f5a-0002-0001-8000-00805f9b34fb` | `WRITE` + `WRITE_NR` — Smartphone → ESP             |
| **Char. Response**   | `5f6d4f5a-0003-0001-8000-00805f9b34fb` | `NOTIFY` — ESP → Smartphone (Client muss subscriben) |

- **Encoding:** UTF-8 JSON, kein Längenpräfix, kein Chunking (max. MTU 128).
- **MTU:** die App verhandelt nach dem Connect explizit (`requestMTU 185`,
  Android defaultet sonst auf 23 = 20 Nutzbytes — Requests UND Responses
  würden abgeschnitten); die Verhandlung kappt der ESP bei seinem lokalen
  `NimBLEDevice::setMTU(128)` → ~125 Nutzbytes je Richtung.
- **Keine Verschlüsselung / Pairing** im Prototyp — die Characteristic-Flags
  setzen nur `WRITE*` / `NOTIFY`, keine `*_ENC` / `*_AUTHEN`. Hardening
  (Verschlüsselung, Device-Auth, TLS) ist ein bekanntes Backlog-Item.
- **Service im Advertising:** Die Service-UUID wird ins Advertising gepackt,
  die App kann also schon beim Scan prüfen, ohne verbinden zu müssen.
- **Advertising-Name:** = konfigurierter Hostname des ESP (z.B.
  `doorinterface-a1b2`). Default: `doorinterface-XXXX` (letzte 2 MAC-Bytes).

## Request-Format (Smartphone → ESP, Write auf Request-Characteristic)

```json
{
  "action": "open",
  "userId": "<globalAuthUserId (UUID) des Endnutzers>",
  "code": "<6-stelliger rollierender Code>",
  "deviceId": "<freitext, Logging/Echo>"
}
```

| Feld      | Typ | Pflicht | Bedeutung |
|-----------|-----|---------|-----------|
| `action`  | str | ja      | `"open"` (verifizieren + Tür öffnen) oder `"test"` (nur verifizieren, keine Türaktion) |
| `userId`  | str | ja      | `globalAuthUserId` der Person (Tür-Schlüssel, aus dem Profil) |
| `code`    | str | ja      | Der rollierende Code: 6 Ziffern aus `HMAC-SHA256(secret, "<step>:<MAC ohne Doppelpunkte, uppercase>")`, Schrittweite 30 s |
| `deviceId`| str | nein    | Geräte-ID des Smartphones, nur fürs Logging / Echo |

Das alte Feld `credential` (Prototyp) ist entfallen. Der Code ist **an die Tür
gebunden** (MAC im HMAC-Input) und **einmalig** — der lokale Server verbraucht
jeden `(user, step)`-Code genau einmal (Replay-Schutz). Türen kurz
nacheinander funktionieren, da die App pro Tür einen frischen Code aus dem
gleichen Secret berechnet.

## Response-Format (ESP → Smartphone, Notify auf Response-Characteristic)

```json
{
  "success": true,
  "code": "OK",
  "message": "Tuer geoeffnet"
}
```

### Status-Codes

| `code`                | `success` | Bedeutung |
|-----------------------|-----------|-----------|
| `OK`                  | true      | Verifiziert + Tür geöffnet (`open`, NUKI `unlatch()`) |
| `TEST_OK`             | true      | Verifiziert, keine Türaktion (`test`) |
| `DEVICE_UNCONFIGURED`| false     | Kein Backend konfiguriert (Setup offen) |
| `NOT_PAIRED`          | false     | Kein NUKI-Schloss gepaart (wird VOR der Prüfung gecheckt — verbraucht keinen Code) |
| `CRED_INVALID`        | false     | Anfrage unvollständig oder vom Backend als malform zurückgewiesen |
| `ACCESS_DENIED`       | false     | Verifizierung fehlgeschlagen (unbekannter User, inaktive Mitgliedschaft, falscher Code, Replay — bewusst nicht unterscheidbar) |
| `RATE_LIMITED`        | false     | Zu viele fehlgeschlagene Versuche für diesen User (Backdoor-Bruteforce-Schutz) |
| `BACKEND_UNREACHABLE` | false     | Lokale Instanz nicht erreichbar (Timeout/Verbindungsfehler) |
| `LOCK_FAILED`         | false     | Verifiziert, aber `unlatch()` wurde nicht angenommen |
| `UNKNOWN_ACTION`      | false     | `action` fehlt oder wurde nicht erkannt |

## Backend-Verifikation (ESP → lokale Instanz)

`POST http://<localApiUrl>/api/door/verify` (JSON):

```json
{
  "userKey": "<userId aus dem BLE-Request>",
  "code": "<code aus dem BLE-Request>",
  "siteId": 42,
  "deviceMac": "<BLE-MAC des ESP, z.B. A4:CF:12:9D:71:E2>"
}
```

Antwort: `{ "ok": bool, "code": str, "message": str }` — `code` wie oben
(Backend-Seite: `OK` / `ACCESS_DENIED` / `RATE_LIMITED` / `CRED_INVALID` /
`SERVER_ERROR`). Die Prüflogik (Mirror-Datenbank, aktive Mitgliedschaft,
TOTP-Fenster ±1 Schritt, Einmalverbrauch, Rate-Limit, Access-Log) liegt
komplett auf der lokalen Instanz und funktioniert ohne Internet.

Backend-Config auf dem ESP: NVS-Namespace `backend` (`url`, `siteId`),
gesetzt entweder manuell über die Setup-Seite (`/setup` → Backend-Anbindung)
oder automatisch per `POST /api/backend/config`
(`url=<..>&siteId=<..>` → ACK `{ok, mac, hostname}` — der lokale Server pusht
dies beim Anlegen des Geräts in der Standort-Verwaltung).

## Serial-Monitor-Ausgaben (ESP)

```
[BE] backend=192.168.1.109:8182 siteId=42
[BLE] init server
[BLE] advertising name='doorinterface-a1b2'
[BLE] client connected
[BLE] RX (98 bytes): {"action":"open","userId":"...","code":"123456","deviceId":"pixel7"}
[BLE] parsed: action=open userId=... code=123456 deviceId=pixel7
[BE] verify user=... code=123456
[BE] Antwort (200): {"ok":true,"code":"OK","message":"Zugang gewaehrt"}
[BLE] TX: {"success":true,"code":"OK","message":"Tuer geoeffnet"}
[BLE] client disconnected
```

## QR-Code

Statisch ausgedruckt (Setup-Seite → Kundendisplay) oder dynamisch unter
`/display`. Inhalt:

```
doorinterface|<BLE_MAC>|<siteId>
```

- **Trennzeichen:** `|` (Pipe) — NICHT `:`, da die MAC selbst Colons enthält
  (`A4:CF:12:9D:71:E2`) und ein `:`-Split die MAC zerstören würde.
- **MAC-Format:** 6 Hex-Gruppen à 2 Stellen, getrennt durch `:`. Die App
  normalisiert (ohne Doppelpunkte, uppercase) für die Code-Berechnung —
  identisch zur Backend-Prüfung.
- **siteId:** die Site-ID der lokalen Instanz, damit die App das richtige
  (Person, Site)-Secret für die Code-Berechnung wählt. Solange das Backend
  nicht konfiguriert ist, bleibt das Feld leer (`doorinterface|<MAC>|`) —
  die App weist solche QRs mit "Gerät nicht konfiguriert" ab.
