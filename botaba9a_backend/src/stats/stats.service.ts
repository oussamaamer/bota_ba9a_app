import { Injectable, Logger } from '@nestjs/common';

/**
 * Gas status classification
 */
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

@Injectable()
export class StatsService {
  private readonly logger = new Logger(StatsService.name);

  /**
   * Calculate gas level from raw weight and bottle profile.
   *
   * tare = empty bottle weight (no gas)
   * capacity = full_weight - empty_weight (max gas weight)
   * gas_weight = weight_grams - tare (current gas)
   * gas_level_pct = gas_weight / capacity * 100
   */
  calculateGasLevel(
    weightGrams: number,
    emptyWeightGrams: number,
    fullWeightGrams: number,
  ): GasLevelResult {
    const tare = emptyWeightGrams;
    const capacity = fullWeightGrams - emptyWeightGrams;

    if (capacity <= 0) {
      return { gas_weight_grams: 0, gas_level_pct: 0, status: 'empty' };
    }

    const gasWeight = Math.max(0, weightGrams - tare);
    const gasLevelPct = Math.min(100, Math.max(0, (gasWeight / capacity) * 100));

    return {
      gas_weight_grams: gasWeight,
      gas_level_pct: Math.round(gasLevelPct * 10) / 10,
      status: this.classifyStatus(gasLevelPct),
    };
  }

  /**
   * Calculate consumption rate from a series of readings.
   * Readings must be sorted by recorded_at descending (newest first).
   */
  calculateConsumptionRate(readings: Reading[]): ConsumptionResult {
    if (readings.length < 2) {
      return {
        rate_g_per_hour: 0,
        rate_g_per_day: 0,
        avg_daily_consumption: 0,
      };
    }

    // Use the most recent readings for current rate
    const newest = readings[0];
    const oldest = readings[readings.length - 1];

    const timeDiffMs =
      new Date(newest.recorded_at).getTime() -
      new Date(oldest.recorded_at).getTime();
    const timeDiffHours = timeDiffMs / (1000 * 60 * 60);

    if (timeDiffHours <= 0) {
      return {
        rate_g_per_hour: 0,
        rate_g_per_day: 0,
        avg_daily_consumption: 0,
      };
    }

    // Weight should decrease over time (gas consumed)
    const weightDelta = oldest.weight_grams - newest.weight_grams;
    const rateGPerHour = Math.max(0, weightDelta / timeDiffHours);
    const rateGPerDay = rateGPerHour * 24;

    // Calculate average daily consumption
    const timeDiffDays = timeDiffHours / 24;
    const avgDaily = timeDiffDays > 0 ? Math.max(0, weightDelta / timeDiffDays) : 0;

    return {
      rate_g_per_hour: Math.round(rateGPerHour * 10) / 10,
      rate_g_per_day: Math.round(rateGPerDay * 10) / 10,
      avg_daily_consumption: Math.round(avgDaily * 10) / 10,
    };
  }

  /**
   * Estimate remaining duration based on current gas weight and consumption rate.
   */
  estimateRemainingDuration(
    gasWeightGrams: number,
    rateGPerHour: number,
  ): DurationEstimate {
    if (rateGPerHour <= 0 || gasWeightGrams <= 0) {
      return {
        estimated_hours_left: -1, // -1 indicates "cannot estimate"
        estimated_days_left: -1,
      };
    }

    const hoursLeft = gasWeightGrams / rateGPerHour;
    const daysLeft = hoursLeft / 24;

    return {
      estimated_hours_left: Math.round(hoursLeft * 10) / 10,
      estimated_days_left: Math.round(daysLeft * 10) / 10,
    };
  }

  /**
   * Classify gas level into a status category.
   */
  private classifyStatus(pct: number): GasStatus {
    if (pct >= 90) return 'full';
    if (pct >= 50) return 'good';
    if (pct >= 20) return 'attention';
    if (pct >= 10) return 'low';
    if (pct > 0) return 'critical';
    return 'empty';
  }
}
