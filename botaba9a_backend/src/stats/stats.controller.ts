import {
  Controller,
  Get,
  Param,
  UseGuards,
  Req,
  NotFoundException,
} from '@nestjs/common';
import { StatsService } from './stats.service';
import { DevicesService } from '../devices/devices.service';
import { AuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { AuthenticatedUser } from '../common/dto/api-response.dto';
import { Request } from 'express';

@Controller()
@UseGuards(AuthGuard)
export class StatsController {
  constructor(
    private readonly statsService: StatsService,
    private readonly devicesService: DevicesService,
  ) {}

  @Get('devices/:id/stats')
  async getDeviceStats(
    @Param('id') deviceId: string,
    @CurrentUser() user: AuthenticatedUser,
    @Req() req: Request,
  ) {
    const token = req.headers.authorization?.split(' ')[1] || '';

    // Get device with bottle profile
    const device = await this.devicesService.getDevice(deviceId, user.id, token);

    if (!device.bottle_profile) {
      throw new NotFoundException({
        code: 'PROFILE_NOT_CONFIGURED',
        message: 'This device does not have a bottle profile configured. Please calibrate the device first.',
      });
    }

    // Get recent readings
    const readings = await this.devicesService.getReadings(deviceId, user.id, token, 100);

    const bottleProfile = device.bottle_profile;
    const latestReading = readings.length > 0 ? readings[0] : null;

    // Calculate gas level
    const gasLevel = latestReading
      ? this.statsService.calculateGasLevel(
          latestReading.weight_grams,
          bottleProfile.empty_weight_grams,
          bottleProfile.full_weight_grams,
        )
      : { gas_weight_grams: 0, gas_level_pct: 0, status: 'empty' as const };

    // Calculate consumption rate
    const consumption = this.statsService.calculateConsumptionRate(
      readings.map((r: { weight_grams: number; recorded_at: string }) => ({
        weight_grams: r.weight_grams,
        recorded_at: r.recorded_at,
      })),
    );

    // Estimate remaining duration
    const duration = this.statsService.estimateRemainingDuration(
      gasLevel.gas_weight_grams,
      consumption.rate_g_per_hour,
    );

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
}
