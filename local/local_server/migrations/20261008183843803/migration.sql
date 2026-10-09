BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "member_profile" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid,
    "globalAuthUserId" uuid NOT NULL,
    "email" text NOT NULL,
    "firstName" text,
    "lastName" text,
    "birthday" timestamp without time zone,
    "imageUrl" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "member_profile_auth_user_unique_idx" ON "member_profile" USING btree ("authUserId");
CREATE UNIQUE INDEX "member_profile_global_auth_user_unique_idx" ON "member_profile" USING btree ("globalAuthUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "site_connections" (
    "id" bigserial PRIMARY KEY,
    "globalApiUrl" text NOT NULL,
    "siteId" bigint NOT NULL,
    "siteName" text NOT NULL,
    "siteStreet" text,
    "siteZipCode" text,
    "siteCity" text,
    "siteCountry" text,
    "siteCompanyEmail" text,
    "adminAuthUserId" uuid,
    "deviceSessionKey" text,
    "enrolledAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "member_profile"
    ADD CONSTRAINT "member_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR local
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('local', '20261008183843803', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261008183843803', "timestamp" = now();

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
