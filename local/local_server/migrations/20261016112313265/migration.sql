BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "door_access_consumed" (
    "id" bigserial PRIMARY KEY,
    "userKey" uuid NOT NULL,
    "step" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "door_access_consumed_unique_idx" ON "door_access_consumed" USING btree ("userKey", "step");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "door_access_logs" (
    "id" bigserial PRIMARY KEY,
    "deviceMac" text,
    "userKey" uuid,
    "result" text NOT NULL,
    "detail" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "door_access_logs_user_created_idx" ON "door_access_logs" USING btree ("userKey", "createdAt");
CREATE INDEX "door_access_logs_result_created_idx" ON "door_access_logs" USING btree ("result", "createdAt");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "door_devices" ADD COLUMN "mac" text;
ALTER TABLE "door_devices" ADD COLUMN "configuredAt" timestamp without time zone;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "member_profile" ADD COLUMN "doorCodeSecret" text;

--
-- MIGRATION VERSION FOR local
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('local', '20261016112313265', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112313265', "timestamp" = now();

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
