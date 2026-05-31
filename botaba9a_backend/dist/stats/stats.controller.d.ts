import { StatsService } from './stats.service';
import { DevicesService } from '../devices/devices.service';
import { AuthenticatedUser } from '../common/dto/api-response.dto';
import { Request } from 'express';
export declare class StatsController {
    private readonly statsService;
    private readonly devicesService;
    constructor(statsService: StatsService, devicesService: DevicesService);
    getDeviceStats(deviceId: string, user: AuthenticatedUser, req: Request): Promise<{
        device_id: any;
        device_name: any;
        bottle_profile: {
            name: any;
            empty_weight_grams: any;
            full_weight_grams: any;
            capacity_grams: number;
        };
        current: {
            weight_grams: any;
            gas_weight_grams: number;
            gas_level_pct: number;
            status: import("./stats.service").GasStatus;
            last_reading_at: any;
        };
        consumption: {
            rate_g_per_hour: number;
            rate_g_per_day: number;
            avg_daily_consumption: number;
            estimated_hours_left: number;
            estimated_days_left: number;
        };
    }>;
}
