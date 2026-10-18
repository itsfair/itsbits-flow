BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "door_devices" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "address" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "door_devices_address_unique_idx" ON "door_devices" USING btree ("address");


--
-- MIGRATION VERSION FOR local
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('local', '20261014143124346-door_devices', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261014143124346-door_devices', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
