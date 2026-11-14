CREATE TABLE task_role_compositions (
  task_id TEXT PRIMARY KEY REFERENCES tasks(id),
  primary_role TEXT NOT NULL,
  supporting_roles_json TEXT NOT NULL,
  effective_instructions TEXT NOT NULL,
  allowed_tools_json TEXT NOT NULL,
  denied_tools_json TEXT NOT NULL,
  merged_checklist_json TEXT NOT NULL,
  required_evidence_json TEXT NOT NULL,
  conflict_log_json TEXT NOT NULL,
  composition_hash TEXT NOT NULL,
  composed_at TEXT NOT NULL
);
CREATE INDEX task_role_compositions_composed_at_idx ON task_role_compositions(composed_at);
