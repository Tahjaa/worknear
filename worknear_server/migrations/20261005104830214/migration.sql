BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "application" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "application" (
    "id" bigserial PRIMARY KEY,
    "jobId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "status" text NOT NULL,
    "appliedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "application_auth_user_idx" ON "application" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "application"
    ADD CONSTRAINT "application_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR worknear
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('worknear', '20261005104830214', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261005104830214', "timestamp" = now();

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
