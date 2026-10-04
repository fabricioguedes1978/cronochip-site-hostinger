SET NAMES utf8mb4;
CREATE TABLE IF NOT EXISTS events (
 id CHAR(36) PRIMARY KEY, code VARCHAR(80) NOT NULL UNIQUE, name VARCHAR(120) NOT NULL,
 slug VARCHAR(90) NOT NULL UNIQUE, event_date DATE NULL, city VARCHAR(80) NULL, distance VARCHAR(80) NULL,
 category VARCHAR(100) NULL, status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE', age_groups JSON NULL,
 appeal_minutes INT NOT NULL DEFAULT 15, appeal_ends_at DATETIME(3) NULL,
 event_type ENUM('CORRIDA','CORRIDA_COM_VOLTAS','MTB','MTB_COM_VOLTAS') NOT NULL DEFAULT 'CORRIDA',
 show_general TINYINT(1) NOT NULL DEFAULT 1, is_published TINYINT(1) NOT NULL DEFAULT 1,
 created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
 updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS sync_configs (
 event_id CHAR(36) PRIMARY KEY, source_type VARCHAR(20) NOT NULL DEFAULT 'agent', delimiter VARCHAR(8) NOT NULL DEFAULT ';',
 has_header TINYINT(1) NOT NULL DEFAULT 1, paused TINYINT(1) NOT NULL DEFAULT 0,
 interval_seconds INT NOT NULL DEFAULT 60, connection_status VARCHAR(20) NOT NULL DEFAULT 'OFFLINE',
 last_sync_at DATETIME(3) NULL, last_error TEXT NULL, last_file_hash VARCHAR(100) NULL,
 ingest_token CHAR(32) NOT NULL UNIQUE, created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
 updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
 CONSTRAINT fk_sync_event FOREIGN KEY(event_id) REFERENCES events(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS results (
 id CHAR(36) PRIMARY KEY, event_id CHAR(36) NOT NULL, bib_number VARCHAR(80) NOT NULL,
 athlete_name VARCHAR(180) NOT NULL, name_search VARCHAR(180) NULL, gender CHAR(1) NULL,
 birth_date DATE NULL, category VARCHAR(120) NULL, age_group VARCHAR(60) NULL,
 finish_time VARCHAR(40) NULL, finish_ms BIGINT NULL, finish_clock VARCHAR(40) NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'FINISHED', distance VARCHAR(100) NULL, team VARCHAR(180) NULL,
 lap INT NULL, overall_rank INT NULL, gender_rank INT NULL, age_group_rank INT NULL,
 source VARCHAR(20) NOT NULL DEFAULT 'TXT', created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
 updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
 UNIQUE KEY uq_event_bib(event_id,bib_number), KEY idx_event_rank(event_id,overall_rank),
 KEY idx_event_status(event_id,status), KEY idx_event_name(event_id,name_search),
 CONSTRAINT fk_result_event FOREIGN KEY(event_id) REFERENCES events(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS sync_logs (
 id CHAR(36) PRIMARY KEY, event_id CHAR(36) NOT NULL, started_at DATETIME(3) NOT NULL,
 finished_at DATETIME(3) NULL, source VARCHAR(20) NOT NULL, status VARCHAR(20) NOT NULL,
 records_processed INT NOT NULL DEFAULT 0, records_new INT NOT NULL DEFAULT 0,
 records_updated INT NOT NULL DEFAULT 0, records_disqualified INT NOT NULL DEFAULT 0,
 errors INT NOT NULL DEFAULT 0, message TEXT NULL, details JSON NULL,
 KEY idx_sync_event(event_id,started_at), CONSTRAINT fk_log_event FOREIGN KEY(event_id) REFERENCES events(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS result_change_logs (
 id CHAR(36) PRIMARY KEY, event_id CHAR(36) NOT NULL, bib_number VARCHAR(80) NOT NULL,
 athlete_name VARCHAR(180) NULL, field VARCHAR(100) NOT NULL, old_value TEXT NULL, new_value TEXT NULL,
 source VARCHAR(50) NOT NULL DEFAULT 'TXT', changed_by VARCHAR(100) NULL,
 created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3), KEY idx_change_event(event_id,created_at),
 CONSTRAINT fk_change_event FOREIGN KEY(event_id) REFERENCES events(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
