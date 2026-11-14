CREATE TABLE task_evidence_records (
  id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL REFERENCES tasks(id),
  case_id TEXT NOT NULL,
  requirement_id TEXT NOT NULL,
  title TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('PASS', 'FAIL', 'BLOCKED', 'SKIPPED', 'NOT_RUN')),
  severity TEXT NOT NULL CHECK (severity IN ('critical', 'high', 'medium', 'low')),
  steps_json TEXT NOT NULL,
  expected TEXT NOT NULL,
  actual TEXT NOT NULL,
  evidence_items_json TEXT NOT NULL,
  environment_json TEXT NOT NULL,
  recorded_at TEXT NOT NULL,
  status_reason TEXT
);
CREATE INDEX task_evidence_records_task_idx ON task_evidence_records(task_id);
CREATE INDEX task_evidence_records_case_idx ON task_evidence_records(task_id, case_id);
CREATE INDEX task_evidence_records_status_idx ON task_evidence_records(task_id, status);
