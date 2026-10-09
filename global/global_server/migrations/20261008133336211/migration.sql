BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "site_device_sessions" (
    "id" bigserial PRIMARY KEY,
    "siteId" bigint NOT NULL,
    "serverSideSessionId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "site_unique_idx" ON "site_device_sessions" USING btree ("siteId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "site_memberships" (
    "id" bigserial PRIMARY KEY,
    "siteId" bigint NOT NULL,
    "profileId" bigint NOT NULL,
    "role" text NOT NULL,
    "active" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "site_role_idx" ON "site_memberships" USING btree ("siteId", "profileId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sites" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "street" text NOT NULL,
    "zipCode" text NOT NULL,
    "city" text NOT NULL,
    "country" text NOT NULL,
    "companyEmail" text NOT NULL,
    "status" text NOT NULL,
    "firstAdminId" uuid NOT NULL,
    "registeredAt" timestamp without time zone,
    "lastSeenAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "company_email_idx" ON "sites" USING btree ("companyEmail");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "site_device_sessions"
    ADD CONSTRAINT "site_device_sessions_fk_0"
    FOREIGN KEY("siteId")
    REFERENCES "sites"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "site_memberships"
    ADD CONSTRAINT "site_memberships_fk_0"
    FOREIGN KEY("siteId")
    REFERENCES "sites"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "site_memberships"
    ADD CONSTRAINT "site_memberships_fk_1"
    FOREIGN KEY("profileId")
    REFERENCES "member_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "sites"
    ADD CONSTRAINT "sites_fk_0"
    FOREIGN KEY("firstAdminId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR global
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('global', '20261008133336211', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261008133336211', "timestamp" = now();

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
