CREATE TABLE context_snapshots (
  id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL REFERENCES tasks(id),
  schema_version INTEGER NOT NULL CHECK (schema_version = 1),
  queries_json TEXT NOT NULL,
  trail_json TEXT NOT NULL,
  memory_ids_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX context_snapshots_task_idx ON context_snapshots(task_id, created_at DESC);

CREATE TABLE context_sources (
  snapshot_id TEXT NOT NULL REFERENCES context_snapshots(id),
  ordinal INTEGER NOT NULL CHECK (ordinal >= 0),
  path TEXT NOT NULL,
  line_start INTEGER NOT NULL CHECK (line_start > 0),
  line_end INTEGER NOT NULL CHECK (line_end >= line_start),
  hash TEXT NOT NULL,
  retrieved_at TEXT NOT NULL,
  revision TEXT,
  PRIMARY KEY (snapshot_id, ordinal)
);

CREATE TABLE memory_entries (
  id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL REFERENCES tasks(id),
  kind TEXT NOT NULL CHECK (kind IN ('working', 'episodic', 'semantic')),
  statement TEXT NOT NULL,
  scope_json TEXT NOT NULL,
  sources_json TEXT NOT NULL,
  confidence REAL NOT NULL CHECK (confidence >= 0 AND confidence <= 1),
  status TEXT NOT NULL CHECK (status IN ('candidate', 'verified', 'pending_review', 'promoted', 'rejected', 'invalidated', 'stale')),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  valid_until TEXT,
  invalidated_by_json TEXT NOT NULL,
  proposed_by TEXT NOT NULL,
  reviewed_by TEXT
);
CREATE INDEX memory_entries_task_idx ON memory_entries(task_id);
CREATE INDEX memory_entries_status_idx ON memory_entries(status);
CREATE INDEX memory_entries_valid_until_idx ON memory_entries(valid_until);

CREATE TABLE memory_reviews (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  memory_id TEXT NOT NULL REFERENCES memory_entries(id),
  action TEXT NOT NULL CHECK (action IN ('verify', 'request_review', 'promote', 'reject', 'invalidate', 'revalidate')),
  actor TEXT NOT NULL,
  occurred_at TEXT NOT NULL
);
CREATE INDEX memory_reviews_memory_idx ON memory_reviews(memory_id);

CREATE TABLE working_entries (
  id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL REFERENCES tasks(id),
  kind TEXT NOT NULL CHECK (kind IN ('decision', 'tool_result', 'blocker', 'approval')),
  text TEXT NOT NULL,
  created_at TEXT NOT NULL,
  expires_at TEXT NOT NULL
);
CREATE INDEX working_entries_task_expiry_idx ON working_entries(task_id, expires_at);
CREATE INDEX working_entries_expiry_idx ON working_entries(expires_at);
