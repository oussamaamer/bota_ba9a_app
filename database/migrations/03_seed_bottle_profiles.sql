-- ============================================================
-- BOTABA9A Seed Data
-- Migration 03: Standard Moroccan Bottle Profiles
-- ============================================================

-- These are public system-defined profiles (created_by is NULL)
-- Users will see these as standard options during calibration

INSERT INTO public.bottle_profiles (id, name, empty_weight_grams, full_weight_grams, alert_threshold_pct, is_public, created_by)
VALUES
    -- Butagaz bottles
    (
        gen_random_uuid(),
        'Butagaz 3kg',
        4200,
        7200,
        15,
        TRUE,
        NULL
    ),
    (
        gen_random_uuid(),
        'Butagaz 6kg',
        7200,
        13200,
        15,
        TRUE,
        NULL
    ),
    (
        gen_random_uuid(),
        'Butagaz 12kg',
        14500,
        26500,
        15,
        TRUE,
        NULL
    ),
    -- Afriquia Gas bottles
    (
        gen_random_uuid(),
        'Afriquia 3kg',
        4100,
        7100,
        15,
        TRUE,
        NULL
    ),
    (
        gen_random_uuid(),
        'Afriquia 6kg',
        7100,
        13100,
        15,
        TRUE,
        NULL
    ),
    (
        gen_random_uuid(),
        'Afriquia 12kg',
        14400,
        26400,
        15,
        TRUE,
        NULL
    )
ON CONFLICT DO NOTHING;
