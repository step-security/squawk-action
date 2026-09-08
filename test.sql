BEGIN;

CREATE TABLE "pipeline_jobs" (
    "id"   serial       NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL
);

CREATE INDEX "pipeline_jobs_name_idx" ON "pipeline_jobs" ("name");

ALTER TABLE "pipeline_jobs"
    ADD CONSTRAINT "pipeline_jobs_name_key" UNIQUE ("name");

COMMIT;
