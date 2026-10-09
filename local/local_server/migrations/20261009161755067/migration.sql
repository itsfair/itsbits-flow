BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "member_memberships" (
    "id" bigserial PRIMARY KEY,
    "memberProfileId" bigint NOT NULL,
    "globalAuthUserId" uuid NOT NULL,
    "role" text NOT NULL,
    "active" boolean NOT NULL,
    "endedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "member_membership_profile_unique_idx" ON "member_memberships" USING btree ("memberProfileId");
CREATE INDEX "member_membership_global_auth_user_idx" ON "member_memberships" USING btree ("globalAuthUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "member_memberships"
    ADD CONSTRAINT "member_memberships_fk_0"
    FOREIGN KEY("memberProfileId")
    REFERENCES "member_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR local
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('local', '20261009161755067', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261009161755067', "timestamp" = now();

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
