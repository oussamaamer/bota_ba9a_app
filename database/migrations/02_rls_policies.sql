-- ============================================================
-- BOTABA9A Row Level Security Policies
-- Migration 02: RLS Policies
-- ============================================================

-- ============================================================
-- Enable RLS on all tables
-- ============================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bottle_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weight_readings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- PROFILES POLICIES
-- ============================================================

-- Users can read their own profile
CREATE POLICY profiles_select_own ON public.profiles
    FOR SELECT
    USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY profiles_update_own ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Profile insert is handled by the trigger (SECURITY DEFINER)
-- Allow insert for the trigger function
CREATE POLICY profiles_insert ON public.profiles
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- ============================================================
-- BOTTLE PROFILES POLICIES
-- ============================================================

-- Users can read public profiles and their own
CREATE POLICY bottle_profiles_select ON public.bottle_profiles
    FOR SELECT
    USING (
        is_public = TRUE
        OR created_by = auth.uid()
    );

-- Users can create their own bottle profiles
CREATE POLICY bottle_profiles_insert ON public.bottle_profiles
    FOR INSERT
    WITH CHECK (created_by = auth.uid());

-- Users can update their own bottle profiles
CREATE POLICY bottle_profiles_update ON public.bottle_profiles
    FOR UPDATE
    USING (created_by = auth.uid())
    WITH CHECK (created_by = auth.uid());

-- Users can delete their own bottle profiles
CREATE POLICY bottle_profiles_delete ON public.bottle_profiles
    FOR DELETE
    USING (created_by = auth.uid());

-- ============================================================
-- DEVICES POLICIES
-- ============================================================

-- Users can read their own devices
CREATE POLICY devices_select_own ON public.devices
    FOR SELECT
    USING (owner_id = auth.uid());

-- Users can create devices they own
CREATE POLICY devices_insert_own ON public.devices
    FOR INSERT
    WITH CHECK (owner_id = auth.uid());

-- Users can update their own devices
CREATE POLICY devices_update_own ON public.devices
    FOR UPDATE
    USING (owner_id = auth.uid())
    WITH CHECK (owner_id = auth.uid());

-- Users can delete their own devices
CREATE POLICY devices_delete_own ON public.devices
    FOR DELETE
    USING (owner_id = auth.uid());

-- ============================================================
-- WEIGHT READINGS POLICIES
-- ============================================================

-- Users can read readings for their own devices
CREATE POLICY readings_select_own ON public.weight_readings
    FOR SELECT
    USING (
        device_id IN (
            SELECT id FROM public.devices WHERE owner_id = auth.uid()
        )
    );

-- Users can insert readings for their own devices
CREATE POLICY readings_insert_own ON public.weight_readings
    FOR INSERT
    WITH CHECK (
        device_id IN (
            SELECT id FROM public.devices WHERE owner_id = auth.uid()
        )
    );

-- ============================================================
-- ALERTS POLICIES
-- ============================================================

-- Users can read alerts for their own devices
CREATE POLICY alerts_select_own ON public.alerts
    FOR SELECT
    USING (
        device_id IN (
            SELECT id FROM public.devices WHERE owner_id = auth.uid()
        )
    );

-- Users can update (acknowledge/resolve) alerts for their own devices
CREATE POLICY alerts_update_own ON public.alerts
    FOR UPDATE
    USING (
        device_id IN (
            SELECT id FROM public.devices WHERE owner_id = auth.uid()
        )
    );

-- System inserts alerts (via service role), but allow user insert too
CREATE POLICY alerts_insert_own ON public.alerts
    FOR INSERT
    WITH CHECK (
        device_id IN (
            SELECT id FROM public.devices WHERE owner_id = auth.uid()
        )
    );
