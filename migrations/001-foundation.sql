CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  intent TEXT NOT NULL,
  risk TEXT NOT NULL,
  scope TEXT NOT NULL,
  policy_id TEXT NOT NULL,
  policy_version INTEGER NOT NULL,
  state TEXT NOT NULL,
  required_gates TEXT NOT NULL,
  satisfied_gates TEXT NOT NULL,
  workflow_compliance TEXT NOT NULL CHECK (workflow_compliance IN ('full', 'partial', 'unverified')),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE task_transitions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id TEXT NOT NULL REFERENCES tasks(id),
  from_state TEXT NOT NULL,
  to_state TEXT NOT NULL,
  occurred_at TEXT NOT NULL
);

CREATE TABLE operations (
  operation_id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL REFERENCES tasks(id),
  result TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX operations_created_at_idx ON operations(created_at);

CREATE TABLE audit_log (
  id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL REFERENCES tasks(id),
  operation_id TEXT NOT NULL,
  correlation_id TEXT NOT NULL,
  actor TEXT,
  client TEXT,
  action TEXT NOT NULL,
  outcome TEXT NOT NULL,
  error_code TEXT,
  occurred_at TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX audit_log_created_at_idx ON audit_log(created_at);
CREATE INDEX audit_log_task_id_idx ON audit_log(task_id);
