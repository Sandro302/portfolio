-- DDL Script for Engineering Pipeline Calculation System
-- Target DB: PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================
-- Schema
-- =========================
CREATE SCHEMA IF NOT EXISTS engineering;
SET search_path TO engineering, public;

-- =========================
-- Table: PROJECTS
-- =========================
CREATE TABLE IF NOT EXISTS projects (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name            varchar(255)        NOT NULL,
    description     text,
    status          varchar(32)         NOT NULL DEFAULT 'draft',
    created_at      timestamptz         NOT NULL DEFAULT now(),
    updated_at      timestamptz         NOT NULL DEFAULT now()
);

COMMENT ON TABLE projects IS 'Проекты трубопроводной системы (импортированные или созданные вручную).';
COMMENT ON COLUMN projects.status IS 'draft | ready | archived.';

CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);
CREATE INDEX IF NOT EXISTS idx_projects_created_at ON projects(created_at);

-- =========================
-- Table: NODES
-- =========================
CREATE TABLE IF NOT EXISTS nodes (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      uuid            NOT NULL,
    code            varchar(64)     NOT NULL,
    name            varchar(255),
    node_type       varchar(32)     NOT NULL,
    elevation_m     numeric(10,3),
    created_at      timestamptz     NOT NULL DEFAULT now(),
    updated_at      timestamptz     NOT NULL DEFAULT now(),
    CONSTRAINT fk_nodes_project FOREIGN KEY (project_id)
        REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT uq_nodes_project_code UNIQUE (project_id, code)
);

COMMENT ON TABLE nodes IS 'Узлы трубопроводной системы (inlet, outlet, junction и пр.).';
COMMENT ON COLUMN nodes.node_type IS 'Тип узла: inlet, outlet, junction, well, facility и т.п.';

CREATE INDEX IF NOT EXISTS idx_nodes_project ON nodes(project_id);

-- =========================
-- Table: PIPES
-- =========================
CREATE TABLE IF NOT EXISTS pipes (
    id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id          uuid            NOT NULL,
    from_node_id        uuid            NOT NULL,
    to_node_id          uuid            NOT NULL,
    code                varchar(64)     NOT NULL,
    name                varchar(255),
    length_m            numeric(12,3)   NOT NULL,
    internal_diameter_m numeric(10,4)   NOT NULL,
    roughness_m         numeric(10,6),
    created_at          timestamptz     NOT NULL DEFAULT now(),
    updated_at          timestamptz     NOT NULL DEFAULT now(),
    CONSTRAINT fk_pipes_project FOREIGN KEY (project_id)
        REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_pipes_from_node FOREIGN KEY (from_node_id)
        REFERENCES nodes(id) ON DELETE RESTRICT,
    CONSTRAINT fk_pipes_to_node FOREIGN KEY (to_node_id)
        REFERENCES nodes(id) ON DELETE RESTRICT,
    CONSTRAINT uq_pipes_project_code UNIQUE (project_id, code),
    CONSTRAINT chk_pipes_length_positive CHECK (length_m > 0),
    CONSTRAINT chk_pipes_diameter_positive CHECK (internal_diameter_m > 0)
);

COMMENT ON TABLE pipes IS 'Трубопроводные сегменты между узлами.';

CREATE INDEX IF NOT EXISTS idx_pipes_project ON pipes(project_id);
CREATE INDEX IF NOT EXISTS idx_pipes_from_node ON pipes(from_node_id);
CREATE INDEX IF NOT EXISTS idx_pipes_to_node ON pipes(to_node_id);

-- =========================
-- Table: TEMPLATES
-- =========================
CREATE TABLE IF NOT EXISTS templates (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      uuid            NOT NULL,
    name            varchar(255)    NOT NULL,
    description     text,
    parameters_json jsonb           NOT NULL,
    is_default      boolean         NOT NULL DEFAULT false,
    created_at      timestamptz     NOT NULL DEFAULT now(),
    updated_at      timestamptz     NOT NULL DEFAULT now(),
    CONSTRAINT fk_templates_project FOREIGN KEY (project_id)
        REFERENCES projects(id) ON DELETE CASCADE
);

COMMENT ON TABLE templates IS 'Шаблоны параметров для расчётов.';
COMMENT ON COLUMN templates.parameters_json IS 'JSONB с параметрами расчёта (давление, дебит, температурные режимы и т.п.).';

CREATE INDEX IF NOT EXISTS idx_templates_project ON templates(project_id);
CREATE INDEX IF NOT EXISTS idx_templates_default ON templates(project_id, is_default);

-- =========================
-- Table: CALCULATIONS
-- =========================
CREATE TABLE IF NOT EXISTS calculations (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      uuid            NOT NULL,
    status          varchar(32)     NOT NULL DEFAULT 'queued',
    started_at      timestamptz,
    finished_at     timestamptz,
    template_id     uuid,
    parameters_json jsonb,
    error_message   text,
    created_at      timestamptz     NOT NULL DEFAULT now(),
    updated_at      timestamptz     NOT NULL DEFAULT now(),
    CONSTRAINT fk_calculations_project FOREIGN KEY (project_id)
        REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_calculations_template FOREIGN KEY (template_id)
        REFERENCES templates(id) ON DELETE SET NULL,
    CONSTRAINT chk_calculations_status CHECK (status IN ('queued','running','completed','failed'))
);

COMMENT ON TABLE calculations IS 'Задания на расчёт для проекта.';
COMMENT ON COLUMN calculations.parameters_json IS 'JSONB с параметрами запуска (оверрайды шаблона).';

CREATE INDEX IF NOT EXISTS idx_calculations_project ON calculations(project_id);
CREATE INDEX IF NOT EXISTS idx_calculations_status ON calculations(status);
CREATE INDEX IF NOT EXISTS idx_calculations_started_at ON calculations(started_at);

-- =========================
-- Table: CALCULATION_RESULTS
-- =========================
CREATE TABLE IF NOT EXISTS calculation_results (
    id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    calculation_id    uuid            NOT NULL,
    node_id           uuid            NOT NULL,
    segment_id        uuid,
    pressure_pa       numeric(18,4)   NOT NULL,
    temperature_k     numeric(18,4)   NOT NULL,
    flow_rate_kg_s    numeric(18,6),
    additional_json   jsonb,
    created_at        timestamptz     NOT NULL DEFAULT now(),
    CONSTRAINT fk_results_calculation FOREIGN KEY (calculation_id)
        REFERENCES calculations(id) ON DELETE CASCADE,
    CONSTRAINT fk_results_node FOREIGN KEY (node_id)
        REFERENCES nodes(id) ON DELETE CASCADE,
    CONSTRAINT fk_results_segment FOREIGN KEY (segment_id)
        REFERENCES pipes(id) ON DELETE SET NULL
);

COMMENT ON TABLE calculation_results IS 'Результаты расчётов по узлам/сегментам. Дополнительные параметры в JSONB.';

CREATE INDEX IF NOT EXISTS idx_results_calculation ON calculation_results(calculation_id);
CREATE INDEX IF NOT EXISTS idx_results_node ON calculation_results(node_id);
CREATE INDEX IF NOT EXISTS idx_results_segment ON calculation_results(segment_id);

-- =========================
-- Table: IMPORT_LOGS
-- =========================
CREATE TABLE IF NOT EXISTS import_logs (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      uuid            NOT NULL,
    source_system   varchar(64)     NOT NULL DEFAULT 'OLGA',
    status          varchar(32)     NOT NULL,
    message         text,
    started_at      timestamptz     NOT NULL DEFAULT now(),
    finished_at     timestamptz,
    created_at      timestamptz     NOT NULL DEFAULT now(),
    CONSTRAINT fk_import_logs_project FOREIGN KEY (project_id)
        REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT chk_import_logs_status CHECK (status IN ('started','completed','failed'))
);

COMMENT ON TABLE import_logs IS 'История импортов проектов из внешних систем (например, OLGA).';

CREATE INDEX IF NOT EXISTS idx_import_logs_project ON import_logs(project_id);
CREATE INDEX IF NOT EXISTS idx_import_logs_status ON import_logs(status);
CREATE INDEX IF NOT EXISTS idx_import_logs_started_at ON import_logs(started_at);

-- =========================
-- Table: ERROR_LOGS
-- =========================
CREATE TABLE IF NOT EXISTS error_logs (
    id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id      uuid,
    calculation_id  uuid,
    severity        varchar(16)     NOT NULL,
    code            varchar(64),
    message         text            NOT NULL,
    context_json    jsonb,
    created_at      timestamptz     NOT NULL DEFAULT now(),
    CONSTRAINT fk_error_logs_project FOREIGN KEY (project_id)
        REFERENCES projects(id) ON DELETE SET NULL,
    CONSTRAINT fk_error_logs_calculation FOREIGN KEY (calculation_id)
        REFERENCES calculations(id) ON DELETE SET NULL,
    CONSTRAINT chk_error_logs_severity CHECK (severity IN ('info','warning','error','critical'))
);

COMMENT ON TABLE error_logs IS 'Журнал ошибок и важных событий в системе.';
COMMENT ON COLUMN error_logs.context_json IS 'Дополнительный контекст (payload, stack, идентификаторы).';

CREATE INDEX IF NOT EXISTS idx_error_logs_project ON error_logs(project_id);
CREATE INDEX IF NOT EXISTS idx_error_logs_calc ON error_logs(calculation_id);
CREATE INDEX IF NOT EXISTS idx_error_logs_severity ON error_logs(severity);
CREATE INDEX IF NOT EXISTS idx_error_logs_created_at ON error_logs(created_at);

-- =========================
-- Triggers: auto-update updated_at
-- =========================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_projects_set_updated_at
    BEFORE UPDATE ON projects
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_nodes_set_updated_at
    BEFORE UPDATE ON nodes
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_pipes_set_updated_at
    BEFORE UPDATE ON pipes
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_templates_set_updated_at
    BEFORE UPDATE ON templates
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_calculations_set_updated_at
    BEFORE UPDATE ON calculations
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

-- =========================
-- Optional: initial status check
-- =========================
ALTER TABLE projects
    ADD CONSTRAINT chk_projects_status_valid
    CHECK (status IN ('draft','ready','archived'))
    NOT VALID;

-- можно позже VALIDATE CONSTRAINT chk_projects_status_valid;
