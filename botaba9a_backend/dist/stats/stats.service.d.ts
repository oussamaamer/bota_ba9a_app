export type GasStatus = 'full' | 'good' | 'attention' | 'low' | 'critical' | 'empty';
export interface GasLevelResult {
    gas_weight_grams: number;
    gas_level_pct: number;
    status: GasStatus;
}
export interface ConsumptionResult {
    rate_g_per_hour: number;
    rate_g_per_day: number;
    avg_daily_consumption: number;
}
export interface DurationEstimate {
    estimated_hours_left: number;
    estimated_days_left: number;
}
interface Reading {
    weight_grams: number;
    recorded_at: string;
}
export declare class StatsService {
    private readonly logger;
    calculateGasLevel(weightGrams: number, emptyWeightGrams: number, fullWeightGrams: number): GasLevelResult;
    calculateConsumptionRate(readings: Reading[]): ConsumptionResult;
    estimateRemainingDuration(gasWeightGrams: number, rateGPerHour: number): DurationEstimate;
    private classifyStatus;
}
export {};
