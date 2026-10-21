-- Bootstraps the FIRST global admin (no admin can grant the scope to
-- themselves through the API, which is itself scoped to `global-admin`).
--
-- Run ONCE against the production database of the GLOBAL instance:
--   docker compose -f docker-compose.production.yaml exec postgres \
--     psql -U postgres -d global -f -   < tool/bootstrap_first_admin.sql
--
-- or from the host:
--   psql --host <host> --port 8090 -U postgres -d global \
--     -f tool/bootstrap_first_admin.sql
--
-- STEP-BY-STEP:
--  1. Replace <admin@example.com> below with the email you registered
--     BEFOREHAND through the normal registration flow (end-user app or
--     emailIdp.enroll...) — the account must already exist.
--  2. Run this file once (idempotent: the UPDATE only matches once).
--     If the account already carries other scopes they are PRESERVED:
--     this appends 'global-admin' to the scope list.
--  3. Sign IN AGAIN (scopes are baked into access tokens; the old
--     token stays scopeless until re-login).

UPDATE serverpod_auth_core_user
SET "scopeNames" =
    CASE
      WHEN "scopeNames" = '[]'::json
        THEN '["global-admin"]'::json
      ELSE jsonb_set(
             "scopeNames"::jsonb,
             ARRAY[(jsonb_array_length("scopeNames"::jsonb))::text],
             '"global-admin"'::jsonb
           )::json
    END
WHERE id = (
  SELECT "authUserId"
  FROM serverpod_auth_idp_email_account
  WHERE lower("email") = lower('<admin@example.com>')
);

-- Verify:
SELECT u."id", "email", u."scopeNames"
FROM serverpod_auth_core_user u
JOIN serverpod_auth_idp_email_account ea ON ea."authUserId" = u."id"
WHERE lower("email") = lower('<admin@example.com>');