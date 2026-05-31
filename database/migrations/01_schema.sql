-- ============================================================
-- BOTABA9A Database Schema
-- Smart Gas Bottle Monitoring System
-- Migration 01: Core Tables
-- ============================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- 1. PROFILES
-- Extends Supabase auth.users with application-specific data
-- ============================================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name   TEXT NOT NULL,
    phone       TEXT,
    role        TEXT NOT NULL DEFAULT 'client'
                CHECK (role IN ('admin', 'client', 'technician', 'vendor')),
    business_name TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.profiles IS 'User profiles extending Supabase auth';
COMMENT ON COLUMN public.profiles.role IS 'User role: admin, client, technician, or vendor';

-- ============================================================
-- 2. BOTTLE PROFILES
-- Standard and custom gas bottle specifications
-- ============================================================
CREATE TABLE IF NOT EXISTS public.bottle_profiles (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                TEXT NOT NULL,
    empty_weight_grams  INTEGER NOT NULL CHECK (empty_weight_grams > 0),
    full_weight_grams   INTEGER NOT NULL CHECK (full_weight_grams > 0),
    alert_threshold_pct INTEGER NOT NULL DEFAULT 15 CHECK (alert_threshold_pct BETWEEN 1 AND 50),
    is_public           BOOLEAN NOT NULL DEFAULT FALSE,
    created_by          UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_weight_order CHECK (full_weight_grams > empty_weight_grams)
);

COMMENT ON TABLE public.bottle_profiles IS 'Gas bottle specifications (standard Moroccan + custom)';
COMMENT ON COLUMN public.bottle_profiles.empty_weight_grams IS 'Tare weight of empty bottle in grams';
COMMENT ON COLUMN public.bottle_profiles.full_weight_grams IS 'Total weight of full bottle (bottle + gas) in grams';
COMMENT ON COLUMN public.bottle_profiles.alert_threshold_pct IS 'Low gas alert threshold percentage (1-50)';

-- ============================================================
-- 3. DEVICES
-- ESP32 IoT devices linked to users and bottle profiles
-- ============================================================
CREATE TABLE IF NOT EXISTS public.devices (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id            UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    esp32_id            TEXT UNIQUE NOT NULL,
    name                TEXT,
    location            TEXT,
    bottle_profile_id   UUID REFERENCES public.bottle_profiles(id) ON DELETE SET NULL,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    last_seen_at        TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.devices IS 'ESP32 IoT devices for gas bottle monitoring';
COMMENT ON COLUMN public.devices.esp32_id IS 'Unique hardware identifier of the ESP32 device';

CREATE INDEX idx_devices_owner_id ON public.devices(owner_id);
CREATE INDEX idx_devices_esp32_id ON public.devices(esp32_id);
CREATE INDEX idx_devices_bottle_profile_id ON public.devices(bottle_profile_id);

-- ============================================================
-- 4. WEIGHT READINGS
-- Raw weight data from IoT devices
-- ============================================================
CREATE TABLE IF NOT EXISTS public.weight_readings (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id           UUID NOT NULL REFERENCES public.devices(id) ON DELETE CASCADE,
    weight_grams        INTEGER NOT NULL CHECK (weight_grams >= 0),
    recorded_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    received_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    source              TEXT NOT NULL DEFAULT 'manual'
                        CHECK (source IN ('ble', 'wifi', 'sync', 'manual')),
    uploaded_to_cloud   BOOLEAN NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE public.weight_readings IS 'Weight readings from IoT devices';
COMMENT ON COLUMN public.weight_readings.source IS 'Data source: ble, wifi, sync, or manual';

CREATE INDEX idx_readings_device_id ON public.weight_readings(device_id);
CREATE INDEX idx_readings_recorded_at ON public.weight_readings(recorded_at DESC);
CREATE INDEX idx_readings_device_recorded ON public.weight_readings(device_id, recorded_at DESC);

-- ============================================================
-- 5. ALERTS
-- System-generated alerts for abnormal conditions
-- ============================================================
CREATE TABLE IF NOT EXISTS public.alerts (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id           UUID NOT NULL REFERENCES public.devices(id) ON DELETE CASCADE,
    alert_type          TEXT NOT NULL
                        CHECK (alert_type IN ('leak', 'lowGas', 'signalLost', 'refillDetected', 'unusualConsumption')),
    severity            TEXT NOT NULL DEFAULT 'info'
                        CHECK (severity IN ('info', 'warning', 'critical')),
    weight_at_trigger   INTEGER,
    anomaly_score       DOUBLE PRECISION,
    triggered_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at         TIMESTAMPTZ,
    acknowledged_at     TIMESTAMPTZ,
    user_note           TEXT
);

COMMENT ON TABLE public.alerts IS 'Alerts generated by anomaly detection and monitoring rules';

CREATE INDEX idx_alerts_device_id ON public.alerts(device_id);
CREATE INDEX idx_alerts_triggered_at ON public.alerts(triggered_at DESC);
CREATE INDEX idx_alerts_unresolved ON public.alerts(device_id) WHERE resolved_at IS NULL;

-- ============================================================
-- 6. AUTO-CREATE PROFILE ON SIGNUP
-- Trigger to create a profile when a new user signs up
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, phone, role)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
        COALESCE(NEW.raw_user_meta_data->>'phone', ''),
        COALESCE(NEW.raw_user_meta_data->>'role', 'client')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if it exists, then create
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();
