"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var StatsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.StatsService = void 0;
const common_1 = require("@nestjs/common");
let StatsService = StatsService_1 = class StatsService {
    constructor() {
        this.logger = new common_1.Logger(StatsService_1.name);
    }
    calculateGasLevel(weightGrams, emptyWeightGrams, fullWeightGrams) {
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
    calculateConsumptionRate(readings) {
        if (readings.length < 2) {
            return {
                rate_g_per_hour: 0,
                rate_g_per_day: 0,
                avg_daily_consumption: 0,
            };
        }
        const newest = readings[0];
        const oldest = readings[readings.length - 1];
        const timeDiffMs = new Date(newest.recorded_at).getTime() -
            new Date(oldest.recorded_at).getTime();
        const timeDiffHours = timeDiffMs / (1000 * 60 * 60);
        if (timeDiffHours <= 0) {
            return {
                rate_g_per_hour: 0,
                rate_g_per_day: 0,
                avg_daily_consumption: 0,
            };
        }
        const weightDelta = oldest.weight_grams - newest.weight_grams;
        const rateGPerHour = Math.max(0, weightDelta / timeDiffHours);
        const rateGPerDay = rateGPerHour * 24;
        const timeDiffDays = timeDiffHours / 24;
        const avgDaily = timeDiffDays > 0 ? Math.max(0, weightDelta / timeDiffDays) : 0;
        return {
            rate_g_per_hour: Math.round(rateGPerHour * 10) / 10,
            rate_g_per_day: Math.round(rateGPerDay * 10) / 10,
            avg_daily_consumption: Math.round(avgDaily * 10) / 10,
        };
    }
    estimateRemainingDuration(gasWeightGrams, rateGPerHour) {
        if (rateGPerHour <= 0 || gasWeightGrams <= 0) {
            return {
                estimated_hours_left: -1,
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
    classifyStatus(pct) {
        if (pct >= 90)
            return 'full';
        if (pct >= 50)
            return 'good';
        if (pct >= 20)
            return 'attention';
        if (pct >= 10)
            return 'low';
        if (pct > 0)
            return 'critical';
        return 'empty';
    }
};
exports.StatsService = StatsService;
exports.StatsService = StatsService = StatsService_1 = __decorate([
    (0, common_1.Injectable)()
], StatsService);
//# sourceMappingURL=stats.service.js.map