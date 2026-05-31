import { SupabaseClient } from '@supabase/supabase-js';
export declare function createAnonClient(accessToken?: string): SupabaseClient;
export declare function createServiceClient(): SupabaseClient;
export declare function getSupabaseUrl(): string;
