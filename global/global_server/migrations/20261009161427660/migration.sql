BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "site_memberships" ADD COLUMN "endedAt" timestamp without time zone;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "site_sync_tasks" (
    "id" bigserial PRIMARY KEY,
    "siteId" bigint NOT NULL,
    "profileId" bigint NOT NULL,
    "attempts" bigint NOT NULL,
    "lastError" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "site_profile_unique_idx" ON "site_sync_tasks" USING btree ("siteId", "profileId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "sites" ADD COLUMN "imageUrl" text;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "site_sync_tasks"
    ADD CONSTRAINT "site_sync_tasks_fk_0"
    FOREIGN KEY("siteId")
    REFERENCES "sites"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "site_sync_tasks"
    ADD CONSTRAINT "site_sync_tasks_fk_1"
    FOREIGN KEY("profileId")
    REFERENCES "member_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR global
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('global', '20261009161427660', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261009161427660', "timestamp" = now();

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
