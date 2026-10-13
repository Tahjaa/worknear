BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "application" (
    "id" bigserial PRIMARY KEY,
    "jobId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "status" text NOT NULL,
    "appliedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "company" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "category" text,
    "address" text,
    "latitude" double precision,
    "longitude" double precision
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "job" (
    "id" bigserial PRIMARY KEY,
    "companyId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "jobType" text NOT NULL,
    "salary" text,
    "experienceRequired" text,
    "studentsAllowed" boolean NOT NULL,
    "latitude" double precision,
    "longitude" double precision,
    "createdAt" timestamp without time zone NOT NULL,
    "isActive" boolean NOT NULL
);


--
-- MIGRATION VERSION FOR worknear
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('worknear', '20261002135445424', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261002135445424', "timestamp" = now();

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
