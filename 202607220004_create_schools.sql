-- ============================================================
-- FEI PLATFORM
-- Migration : 202607220004_create_schools.sql
-- Version   : 1.0.0
-- ============================================================

BEGIN;

CREATE TABLE IF NOT EXISTS core.schools (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    trade_name CITEXT NOT NULL,
    legal_name CITEXT,

    cnpj VARCHAR(18),

    email CITEXT,
    phone VARCHAR(20),

    timezone VARCHAR(60)
        NOT NULL DEFAULT 'America/Sao_Paulo',

    logo_url TEXT,

    is_active BOOLEAN
        NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ
        NOT NULL DEFAULT now(),

    updated_at TIMESTAMPTZ
        NOT NULL DEFAULT now(),

    created_by UUID
        REFERENCES auth.users(id),

    updated_by UUID
        REFERENCES auth.users(id),

    deleted_at TIMESTAMPTZ,

    deleted_by UUID
        REFERENCES auth.users(id),

    CONSTRAINT uq_school_cnpj
        UNIQUE(cnpj),

    CONSTRAINT uq_school_email
        UNIQUE(email),

    CONSTRAINT ck_school_cnpj
        CHECK (
            cnpj IS NULL
            OR length(regexp_replace(cnpj,'[^0-9]','','g')) = 14
        )

);

---------------------------------------------------------
-- ÍNDICES
---------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_school_name
ON core.schools(trade_name);

CREATE INDEX IF NOT EXISTS idx_school_active
ON core.schools(is_active);

CREATE INDEX IF NOT EXISTS idx_school_created
ON core.schools(created_at);

---------------------------------------------------------
-- COMMENTS
---------------------------------------------------------

COMMENT ON TABLE core.schools IS
'Cadastro das escolas da plataforma FEI.';

COMMENT ON COLUMN core.schools.trade_name IS
'Nome fantasia.';

COMMENT ON COLUMN core.schools.legal_name IS
'Razão social.';

COMMENT ON COLUMN core.schools.cnpj IS
'CNPJ da instituição.';

COMMENT ON COLUMN core.schools.email IS
'E-mail institucional.';

COMMENT ON COLUMN core.schools.phone IS
'Telefone principal.';

COMMENT ON COLUMN core.schools.logo_url IS
'URL da logomarca.';

COMMENT ON COLUMN core.schools.timezone IS
'Timezone utilizado pela escola.';

COMMENT ON COLUMN core.schools.is_active IS
'Indica se a escola está ativa.';

COMMIT;
