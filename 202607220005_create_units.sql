-- ============================================================
-- FEI PLATFORM
-- Migration : 202607220005_create_units.sql
-- Domain    : CORE
-- Version   : 1.0.0
-- Description:
--   Criação das unidades das escolas.
-- ============================================================

BEGIN;

CREATE TABLE IF NOT EXISTS core.units (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    school_id UUID NOT NULL,

    code VARCHAR(20) NOT NULL,
    name VARCHAR(150) NOT NULL,

    phone VARCHAR(20),
    email CITEXT,

    address VARCHAR(200),
    number VARCHAR(20),
    complement VARCHAR(100),
    district VARCHAR(100),
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    zip_code VARCHAR(10),

    latitude NUMERIC(10,7),
    longitude NUMERIC(10,7),

    timezone VARCHAR(60) DEFAULT 'America/Sao_Paulo',

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id),

    deleted_at TIMESTAMPTZ,
    deleted_by UUID REFERENCES auth.users(id),

    CONSTRAINT fk_units_school
        FOREIGN KEY (school_id)
        REFERENCES core.schools(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT uq_unit_code
        UNIQUE (school_id, code),

    CONSTRAINT uq_unit_name
        UNIQUE (school_id, name)

);

----------------------------------------------------------
-- ÍNDICES
----------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_units_school
ON core.units(school_id);

CREATE INDEX IF NOT EXISTS idx_units_name
ON core.units(name);

CREATE INDEX IF NOT EXISTS idx_units_city
ON core.units(city);

CREATE INDEX IF NOT EXISTS idx_units_active
ON core.units(is_active);

----------------------------------------------------------
-- COMENTÁRIOS
----------------------------------------------------------

COMMENT ON TABLE core.units IS
'Unidades pertencentes a uma escola.';

COMMENT ON COLUMN core.units.school_id IS
'Escola proprietária da unidade.';

COMMENT ON COLUMN core.units.code IS
'Código interno da unidade.';

COMMENT ON COLUMN core.units.name IS
'Nome da unidade.';

COMMENT ON COLUMN core.units.latitude IS
'Latitude da unidade.';

COMMENT ON COLUMN core.units.longitude IS
'Longitude da unidade.';

COMMENT ON COLUMN core.units.timezone IS
'Fuso horário da unidade.';

COMMENT ON COLUMN core.units.is_active IS
'Indica se a unidade está ativa.';

COMMIT;
