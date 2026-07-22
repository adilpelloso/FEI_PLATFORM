-- ============================================================
-- FEI PLATFORM
-- Migration : 202607220008_create_profiles.sql
-- Domain    : CORE
-- Version   : 1.0.0
-- Description:
--   Cadastro central de perfis de pessoas.
-- ============================================================

BEGIN;

CREATE TABLE IF NOT EXISTS core.profiles (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    auth_user_id UUID
        REFERENCES auth.users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    first_name VARCHAR(100) NOT NULL,

    last_name VARCHAR(150) NOT NULL,

    full_name VARCHAR(250) GENERATED ALWAYS AS
        (trim(first_name || ' ' || last_name)) STORED,

    cpf VARCHAR(14),

    rg VARCHAR(30),

    birth_date DATE,

    gender CHAR(1),

    email CITEXT,

    mobile_phone VARCHAR(20),

    home_phone VARCHAR(20),

    photo_url TEXT,

    notes TEXT,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by UUID
        REFERENCES auth.users(id),

    updated_by UUID
        REFERENCES auth.users(id),

    deleted_at TIMESTAMPTZ,

    deleted_by UUID
        REFERENCES auth.users(id),

    CONSTRAINT uq_profile_cpf
        UNIQUE (cpf),

    CONSTRAINT uq_profile_email
        UNIQUE (email),

    CONSTRAINT ck_profile_gender
        CHECK (gender IN ('M','F') OR gender IS NULL),

    CONSTRAINT ck_profile_cpf
        CHECK (
            cpf IS NULL
            OR length(regexp_replace(cpf,'[^0-9]','','g')) = 11
        )

);

---------------------------------------------------------
-- ÍNDICES
---------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_profiles_name
ON core.profiles(full_name);

CREATE INDEX IF NOT EXISTS idx_profiles_cpf
ON core.profiles(cpf);

CREATE INDEX IF NOT EXISTS idx_profiles_email
ON core.profiles(email);

CREATE INDEX IF NOT EXISTS idx_profiles_active
ON core.profiles(is_active);

---------------------------------------------------------
-- COMMENTS
---------------------------------------------------------

COMMENT ON TABLE core.profiles IS
'Cadastro central de pessoas da plataforma.';

COMMENT ON COLUMN core.profiles.auth_user_id IS
'Usuário do Supabase Auth, quando existir.';

COMMENT ON COLUMN core.profiles.full_name IS
'Nome completo gerado automaticamente.';

COMMENT ON COLUMN core.profiles.photo_url IS
'URL da foto do perfil.';

COMMENT ON COLUMN core.profiles.notes IS
'Observações gerais.';

COMMIT;
