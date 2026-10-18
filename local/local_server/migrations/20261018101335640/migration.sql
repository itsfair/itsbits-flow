BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "access_policies" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "access_policy_members" (
    "id" bigserial PRIMARY KEY,
    "policyId" bigint NOT NULL,
    "memberProfileId" bigint NOT NULL,
    "globalAuthUserId" uuid NOT NULL,
    "validFrom" timestamp without time zone NOT NULL,
    "validUntil" timestamp without time zone
);

-- Indexes
CREATE INDEX "access_policy_members_user_idx" ON "access_policy_members" USING btree ("globalAuthUserId");
CREATE UNIQUE INDEX "access_policy_members_policy_user_unique_idx" ON "access_policy_members" USING btree ("policyId", "globalAuthUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "access_policy_rules" (
    "id" bigserial PRIMARY KEY,
    "policyId" bigint NOT NULL,
    "deviceId" bigint,
    "weekday" bigint NOT NULL,
    "startMinute" bigint NOT NULL,
    "endMinute" bigint NOT NULL
);

-- Indexes
CREATE INDEX "access_policy_rules_policy_idx" ON "access_policy_rules" USING btree ("policyId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "access_policy_members"
    ADD CONSTRAINT "access_policy_members_fk_0"
    FOREIGN KEY("policyId")
    REFERENCES "access_policies"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "access_policy_members"
    ADD CONSTRAINT "access_policy_members_fk_1"
    FOREIGN KEY("memberProfileId")
    REFERENCES "member_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "access_policy_rules"
    ADD CONSTRAINT "access_policy_rules_fk_0"
    FOREIGN KEY("policyId")
    REFERENCES "access_policies"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "access_policy_rules"
    ADD CONSTRAINT "access_policy_rules_fk_1"
    FOREIGN KEY("deviceId")
    REFERENCES "door_devices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR local
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('local', '20261018101335640', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261018101335640', "timestamp" = now();

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
