"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StatsController = void 0;
const common_1 = require("@nestjs/common");
const stats_service_1 = require("./stats.service");
const devices_service_1 = require("../devices/devices.service");
const auth_guard_1 = require("../common/guards/auth.guard");
const current_user_decorator_1 = require("../common/decorators/current-user.decorator");
let StatsController = class StatsController {
    constructor(statsService, devicesService) {
        this.statsService = statsService;
        this.devicesService = devicesService;
    }
    async getDeviceStats(deviceId, user, req) {
        const token = req.headers.authorization?.split(' ')[1] || '';
        const device = await this.devicesService.getDevice(deviceId, user.id, token);
        if (!device.bottle_profile) {
            throw new common_1.NotFoundException({
                code: 'PROFILE_NOT_CONFIGURED',
                message: 'This device does not have a bottle profile configured. Please calibrate the device first.',
            });
        }
        const readings = await this.devicesService.getReadings(deviceId, user.id, token, 100);
        const bottleProfile = device.bottle_profile;
        const latestReading = readings.length > 0 ? readings[0] : null;
        const gasLevel = latestReading
            ? this.statsService.calculateGasLevel(latestReading.weight_grams, bottleProfile.empty_weight_grams, bottleProfile.full_weight_grams)
            : { gas_weight_grams: 0, gas_level_pct: 0, status: 'empty' };
        const consumption = this.statsService.calculateConsumptionRate(readings.map((r) => ({
            weight_grams: r.weight_grams,
            recorded_at: r.recorded_at,
        })));
        const duration = this.statsService.estimateRemainingDuration(gasLevel.gas_weight_grams, consumption.rate_g_per_hour);
        return {
            device_id: device.id,
            device_name: device.name,
            bottle_profile: {
                name: bottleProfile.name,
                empty_weight_grams: bottleProfile.empty_weight_grams,
                full_weight_grams: bottleProfile.full_weight_grams,
                capacity_grams: bottleProfile.full_weight_grams - bottleProfile.empty_weight_grams,
            },
            current: {
                weight_grams: latestReading?.weight_grams ?? null,
                gas_weight_grams: gasLevel.gas_weight_grams,
                gas_level_pct: gasLevel.gas_level_pct,
                status: gasLevel.status,
                last_reading_at: latestReading?.recorded_at ?? null,
            },
            consumption: {
                rate_g_per_hour: consumption.rate_g_per_hour,
                rate_g_per_day: consumption.rate_g_per_day,
                avg_daily_consumption: consumption.avg_daily_consumption,
                estimated_hours_left: duration.estimated_hours_left,
                estimated_days_left: duration.estimated_days_left,
            },
        };
    }
};
exports.StatsController = StatsController;
__decorate([
    (0, common_1.Get)('devices/:id/stats'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, current_user_decorator_1.CurrentUser)()),
    __param(2, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object, Object]),
    __metadata("design:returntype", Promise)
], StatsController.prototype, "getDeviceStats", null);
exports.StatsController = StatsController = __decorate([
    (0, common_1.Controller)(),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    __metadata("design:paramtypes", [stats_service_1.StatsService,
        devices_service_1.DevicesService])
], StatsController);
//# sourceMappingURL=stats.controller.js.map