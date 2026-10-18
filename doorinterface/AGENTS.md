# AGENTS.md — doorinterface

ESP32 firmware (PlatformIO + Arduino framework) for controlling door
openers (relay + NUKI smart locks via BLE), with Wi-Fi setup via
captive portal, web interface and API/WebSocket for the local backend.
Part of the itsbits-flow monorepo — repo structure and conventions:
[root AGENTS.md](../AGENTS.md).

## Build & flash — IMPORTANT FOR ALL AGENTS

```bash
pio run                 # build
pio run -t upload       # flash
pio device monitor      # serial @ 115200
```

> **DRAKONIAN RULE FOR ALL AGENTS (also applies to sub-agents):**
>
> 1. **No build after every small code change.** A `pio run` takes
>    20–60 s and massively consumes context time. Build only on explicit
>    request of the user **or** for deeper refactorings where syntax
>    errors are not obvious. If the change is trivial (e.g. a string
>    constant, a log line, a JS/HTML snippet adjustment), trust a careful
>    reading of the diff — the user compiles and flashes anyway.
> 2. **Explain changes BEFORE writing files.** The agent proposes every
>    bite-size step as code snippet + short explanation and waits for the
>    user's "okay" before actually touching files. Exception: pure
>    documentation updates (AGENTS.md, docs/*.md) that do not change code
>    semantics.
>
> Agents ignoring these rules impair working speed considerably — the
> rules are not optional.

PlatformIO configuration: `platformio.ini`, env `esp32dev`,
`monitor_speed = 115200`.

> Note: `pio` is not in the PATH. PlatformIO lives at
> `C:\Users\Simon\.platformio\penv\Scripts\platformio.exe`.

> If the build fails on a machine: first check
> `Test-Path "$env:USERPROFILE\.platformio\packages\framework-arduinoespressif32\variants"`
> (the framework package must contain `variants/`); also the Python
> module `intelhex` must be installed for `esptool` (into the PIO
> Python environment).

## Code structure

```
platformio.ini
src/
  config.h              -> FW_VERSION
  main.cpp              -> instantiates WifiManager, NukiManager, WebInterface, BackendClient
  WifiManager.h/.cpp    -> WLAN STA attempt + AP fallback + captive portal + hostname
  WebInterface.h/.cpp   -> main webserver (STA mode): dashboard, setup, API
  BackendClient.h/.cpp  -> local-instance connection: NVS "backend" (url, siteId),
                           POST /api/door/verify per BLE request, config set (setup page/push)
  NukiManager.h/.cpp    -> NUKI BLE: pairing, lock/unlock, status querying
  BleServer.h/.cpp      -> BLE peripheral (GATT server) for smartphone app, see docs/ble_interface.md
  Updater.h/.cpp        -> OTA update via GitHub release pull (WiFiClientSecure + Update lib)
  web/
    portal_html.h       -> captive portal HTML (PROGMEM)
    portal_css.h        -> captive portal CSS (PROGMEM)
    portal_js.h         -> captive portal JS  (PROGMEM)
    main_html.h         -> dashboard HTML (PROGMEM)
    main_css.h          -> dashboard + setup CSS (PROGMEM)
    main_js.h           -> dashboard JS: status poll, lock/unlock buttons
    setup_html.h        -> setup page HTML (PROGMEM)
    setup_js.h          -> setup JS: hostname, NUKI pairing, backend config, test buttons
lib/
  nuki_ble/             -> patched fork of AzonInc/NukiBleEsp32 (idf branch)
                           NimBLE API patches for NimBLE-Arduino 1.4.x
docs/
  ble_interface.md      -> spec of the BLE interface ESP<->smartphone app
                           + ESP->backend verification protocol
```

Custom partition table: `partitions.csv` (2 OTA slots of 1.875 MB each,
NVS, otadata). **Switching the partition table deletes NVS on first
flash** — Wi-Fi/NUKI credentials/hostname must be reconfigured.

## Architecture decisions

- **Web content as PROGMEM strings**, not on a filesystem (LittleFS).
  Reason: OTA updates (generated binary via GitHub push) should deliver
  web content automatically — updating a data partition separately via
  OTA would be more error-prone. Files under `src/web/`, header-only,
  one PROGMEM string per file.
- **Separation by area and type**: `portal_*.h` for the captive portal,
  `main_*.h`/`setup_*.h` for the main web interface. One file per area
  for html/css/js.
- **WifiManager as own module**, `main.cpp` stays lean.
- **WebInterface as own module**: starts when
  `wifi.isConnected() && !wifi.isApActive()`. Takes `WifiManager&` and
  `NukiManager&` by reference.
- **NukiManager as own module**: encapsulates BLE scanner + NukiLock.
  Event handler for status updates. Credentials in NVS (namespace =
  device name, managed by the NukiBleEsp32 lib). NUKI pairing name =
  device hostname (truncated to 32 chars); the name is also the NVS
  namespace of the NUKI credentials — after a hostname change
  re-pairing is required (the old namespace stays orphaned in NVS).
- **Debug logging** via `Serial.print*` with prefixes: `[WifiManager]`,
  `[HTTP]`, `[NUKI]`, `[BLE]`.
- **BLE start deferred**: `nuki.begin()` is **not** called in `setup()`
  but in `loop()` only when `wifi.isConnected() && !wifi.isApActive()`.
  Reason: the ESP32 shares one 2.4 GHz radio for Wi-Fi and Bluetooth —
  initializing BLE parallel to an active setup AP **blocks the AP**. In
  STA mode Wi-Fi/BT coexistence works (time slicing). Accordingly,
  `WebInterface` also starts only after a successful STA connection.
- **BleServer starts before NukiManager**: `BleServer.begin()` calls
  `NimBLEDevice::init(name)` first — this call only takes effect the
  first time, afterwards it is a no-op. NimBLE is thus named = ESP
  hostname. BleServer deliberately uses **no own member pointers** to
  service/characteristics but fetches them via
  `NimBLEDevice::getServer()` / `getServiceByUUID()` — that prevents
  stale pointer issues.
- **BleServer = peripheral, NukiManager = central** on the same NimBLE
  stack. NimBLE allows max. 3 connections and all roles by default.
  BleServer holds exactly one smartphone connection, NukiManager one
  central connection to the lock — both work simultaneously (time
  slicing in the controller). Stability under parallel connects must be
  observed; if needed adjust connection params of the client later.
- **Protocol**: JSON over GATT (write on request characteristic, notify
  on response characteristic). Every credential request is verified via
  the local instance (one `POST /api/door/verify` per request) before
  the door action; spec in `docs/ble_interface.md`.
- **BackendClient** (own module, NVS namespace `"backend"`: keys
  `url` = `host[:port]` + `siteId`): holds the local-instance address
  and site ID. Config set either manually via the setup page
  (`/api/backend/config` GET/POST) or pushed by the local server
  (same POST endpoint, form-urlencoded; ACK returns `{ok, mac,
  hostname}`). `verify()` posts `{userKey, code, siteId, deviceMac}`
  and mirrors the backend response. Plain HTTP into the LAN (MVP; the
  whole ESP surface auth + TLS is one coherent hardening package).

## NUKI BLE integration — important details

- **Library**: `lib/nuki_ble/` = patched fork of
  `https://github.com/AzonInc/NukiBleEsp32.git` (idf branch).
  Supports **all NUKI models**: Smart Lock 1.0–4.0, 5.0 Pro, Ultra, Go,
  Opener, Keypad.
- **7 NimBLE API patches** for compatibility with `NimBLE-Arduino @ ^1.4.1`
  (callback signatures, notify_callback type, `isInitialized` removal,
  `setPower(esp_power_level_t)`, `setData(std::string)`,
  `getNative()` instead of `getVal()`).
- **`NukiBle.cpp onResult` — edge detection for the status-updated
  flag**: the original fires the status-updated event on every
  advertising packet with the bit set (every few hundred ms). Patch:
  gate so the event only fires once on a real edge (false→true). Fixes
  a permanent state-request loop that drained the lock's battery.
- **Preferences conflict solved**: the idf branch ships its own
  `Preferences.h/.cpp` with a `std::string` API that collides with the
  Arduino-framework `Preferences` — own files deleted; the Arduino
  framework version is a drop-in replacement.
- **No framework switch**: `framework = arduino` (no espidf), no
  sdkconfig.defaults.
- **Dependencies**: `NimBLE-Arduino @ ^1.4.1`, `BleScanner` (I-Connect),
  `Crc16` (vinmenn).
- **Ultra/5th-gen PIN**: for Smart Lock Ultra/5th Gen/Go/Pro the
  6-digit PIN must be set before pairing (`saveUltraPincode()`, via
  `/api/nuki/pin` in the setup page); standard locks (1.0–4.0) need no
  PIN. Without a PIN the lib refuses pairing (`No pairing PIN code
  set`).
- **No platform upgrade to Arduino Core 3.x**: tested, failed on Python
  dependency problems in PlatformIO — the patched-fork solution
  bypasses that completely.

## Captive portal — implemented flow

1. `begin()`: load NVS hostname (namespace `"system"`) + credentials
   (namespace `"wifi"`). Default hostname: `doorinterface-XXXX` (last
   2 MAC bytes). Hostname validation: only `a-z`, `0-9`, `-`; 1–63
   chars; must not start/end with `-`.
2. If SSID present: STA attempt, 15 s timeout; `WiFi.setHostname()`
   before every `WiFi.begin()`.
3. On failure: fallback AP `DoorSetup-AP` (`WIFI_AP_STA`;
   `setAutoReconnect(false)` + `disconnect(false)` frees the radio for
   scanning).
4. Portal: DNS catch-all, routes `/`, `/portal.css`, `/portal.js`,
   `/scan`, `/save`, `/status`, `/config`, `/close`;
   `UriGlob("*")` + HTTP_ANY catch-all to avoid log spam.
5. `/scan` (GET): `WiFi.scanNetworks()` blocking, JSON array.
6. `/save` (POST): SSID/password + optional hostname to NVS,
   `WiFi.begin()`, responds immediately `{"status":"connecting"}`;
   invalid hostname → HTTP 400 + JSON error, nothing stored.
7. `/close` (POST): close the AP (frontend copies the STA IP to the
   clipboard first).
8. Portal state machine: shutdown request flag (button + 30 s timer)
   → `shutdownAp()` (`setAutoReconnect(true)` for pure STA operation).

## Main web interface (STA mode)

- mDNS with dynamic hostname (`MDNS.begin(hostname)`).
- Routes: `/`, `/main.css`, `/main.js`, `/setup`, `/setup.js`,
  `/display`, `/display.js`, `/qr.js`, `/api/status`, `/api/ble/info`,
  `/api/backend/config` (GET+POST), `/api/hostname` (GET+POST),
  `/api/nuki/pair`, `/api/nuki/cancel`, `/api/nuki/unlock`,
  `/api/nuki/lock`, `/api/nuki/open`, `/api/nuki/unpair`,
  `/api/nuki/pin` (GET/POST), `/api/nuki/poll` (GET/POST),
  `/api/update/check`, `/api/update/start`, `/api/update/progress`,
  `/api/reboot`.
- `/api/status` JSON: `{wifi, relay, locks, firmware, ble}`;
  `locks`: `{available, count, paired, pairing, lockState, batteryPct,
  batteryCritical, rssi, hasUltraPin, pollInterval}`; `ble` carries the
  `qrContent`.
- QR content (single helper `WebInterface::qrContent()`):
  `doorinterface|<BLE_MAC>|<siteId>` — siteId empty while the backend
  is unconfigured.
- Dashboard: 3 cards (Wi-Fi, door opener, firmware), poll every 3 s;
  ⚙ dropdown → `/setup`.
- Setup page: change device name (→ reboot), NUKI pairing
  (instructions + start/cancel), PIN field for Ultra/Go/Pro locks,
  backend config (server URL + site ID), test buttons, firmware update
  section; poll every 2 s.

## Backend verification flow (BLE request → local instance)

1. App writes `{action, userId, code, deviceId}` to the request
   characteristic (`credential` field removed with the prototype).
2. BleServer (loop, one request at a time): checks configured backend
   (`DEVICE_UNCONFIGURED`), and for `open` the NUKI pairing FIRST
   (`NOT_PAIRED` — before verification so the single-use code is not
   wasted), then `BackendClient::verify()` → `POST /api/door/verify`.
3. On granted + `open`: `unlatch()` → `OK` / `LOCK_FAILED`; granted +
   `test`: `TEST_OK`; denied: backend code passed through
   (`ACCESS_DENIED` / `RATE_LIMITED` / `CRED_INVALID`); unreachable:
   `BACKEND_UNREACHABLE`.
4. Response JSON to the app via notify; advertising restarts on
   disconnect. Full contract: `docs/ble_interface.md`.

## NUKI pairing flow

1. Nuki app: enable Bluetooth pairing (Settings → Features &
   Configuration → Button and LED); for Ultra/Go/Pro set the PIN first
   (setup page).
2. Press the NUKI button 10 s (LED ring lights up).
3. Setup page → "start pairing" → `POST /api/nuki/pair`.
4. `NukiManager::startPairing()` → loop calls `pairNuki()` until
   success or 10 min timeout; cancel via `/api/nuki/cancel`.
5. On success: `requestKeyTurnerState()` → status in the dashboard.
6. Credentials (ECDH key, auth ID) stored in NVS (managed by the lib,
   namespace = device name). After restart: no re-pairing needed.

## OTA update

- `src/Updater.cpp` polls the GitHub releases of this repo for the
  latest `fw-v*` release, compares the tag (without `fw-v` prefix)
  with `FW_VERSION`, downloads `firmware.bin` and flashes it into the
  inactive OTA slot via the `Update` lib. TLS via
  `WiFiClientSecure::setInsecure` (embedded CA bundle = possible
  later improvement).
- GitHub workflow `firmware.yml`: builds on tag push `fw-v*`,
  creates a GitHub release with `firmware.bin` as asset; version
  extracted from the tag and injected via `FW_VERSION_FLAGS`
  (`platformio.ini` `${sysenv.FW_VERSION_FLAGS}`; local build without
  CI → fallback version via `config.h`).
- Setup page: "check for update" + progress display + separate
  "reboot" button; dashboard menu "reboot".
- **OTA recovery trap**: if OTA installs a firmware that does not run,
  the lib writes the other slot to `otadata` as "active on next boot";
  a subsequent `pio run -t upload` writes the fix to slot 0, but the
  bootloader keeps starting the (broken) slot 1 until `otadata` is
  erased. **Solution**: `pio run -t erase` → `pio run -t upload`.

## Conventions / notes

- No comments in the code (by agreement).
- `Serial` prefixes: `[WifiManager]`, `[HTTP]`, `[NUKI]`, `[BLE]`.
- NVS namespaces: `"wifi"`, `"system"`; NUKI manages its own (namespace
  = device name).
- Own files live in `src/`, not `lib/` — exception: `lib/nuki_ble/`
  (patched fork, not own code).

## Working rules

- Small bites, each step proposed as code snippet + explained, only
  written to files after "okay". **No exceptions** — not even for "just
  one tiny thing".
- Steps are explained before being created, not auto-committed.
- `git commit` only on explicit request.

## Open TODOs (roughly ordered by priority)

### NUKI
- [ ] Unpair function (`unPairNuki()` + setup button).
- [ ] Several locks in parallel (list of NukiLock instances on the same
        scanner).
- [ ] Keypad management, auth entries, time control.
- [ ] Event log (requires PIN).

### Wi-Fi / setup
- [ ] Configurable AP password for the setup AP (currently open).
- [ ] Reset option for stored Wi-Fi credentials (button/erase flag).
- [ ] Reconnect logic on STA connection loss.

### Web interface
- [ ] Login / session auth (e.g. basic auth, token, session cookie).
- [ ] Relay configuration (pin, level) in the setup page.
- [ ] SSID escaping in the status JSON.

### Backend connection
- [ ] DECIDED (this session): ESP = plain HTTP client on demand (one
        verify call per BLE request) — WS only if push/status features
        need it later.
- [ ] Hardening package (ESP surface + transport): device auth/token,
        TLS or HMAC challenge, web interface auth, BLE GATT encryption
        (`*_ENC` flags + NimBLE security callbacks), config-push auth.
        Tracked as ONE item because the ESP web API is currently
        unauthenticated as a whole — protecting single hops adds
        nothing until the surface is closed.

### Relay
- [ ] GPIO control (pin, timing, interference suppression). Needs
        hardware info.

### Door sensor
- [ ] **Option A — NUKI's own door sensor:** evaluate the field
        `Door sensor state` (uint8: 0x00 unavailable, 0x02 closed,
        0x03 opened, 0x10 uncalibrated, 0xF0 tampered, 0xFF unknown)
        contained in the NUKI API's `Keyturner States (0x000C)` frame
        and display it in the dashboard. Requires a paired NUKI door
        sensor. Updates only in the poll interval (`locks.pollInterval`).
- [ ] **Option B — own reed/magnetic sensor on the ESP GPIO:** reed
        switch on the door leaf (magnet on the frame) on a GPIO pin
        with internal pull-up, firmware polls the pin and fires an
        event on edge. Real-time (independent of the NUKI poll
        interval), new class e.g. `DoorSensor.h/.cpp` in `src/`. Pin
        configurable in the setup page. Needs hardware info (which
        GPIO).

### OTA
- [ ] ESP periodically checks GitHub for a new version (currently only
        manually via the setup page; automatic background poll later).

### Logging / robustness
- [ ] Central debug macro (`#define DEBUG_SERIAL` + `LOGI/LOGW/LOGE`).

### Docs
- [ ] Rewrite `docs/interfaces.md` once the HTTP API / NVS / BLE GATT
        spec of the current state is stable.

## Continuation

Next recommended step:
**Hardening package** (device auth/token + TLS/HMAC challenge + ESP
web interface auth + BLE GATT encryption — see Backend connection
TODO) or **relay GPIO / door sensor** — depending on priority.
