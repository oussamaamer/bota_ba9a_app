import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { DevicesModule } from './devices/devices.module';
import { StatsModule } from './stats/stats.module';
import { BottleProfilesModule } from './bottle-profiles/bottle-profiles.module';

@Module({
  imports: [
    AuthModule,
    DevicesModule,
    StatsModule,
    BottleProfilesModule,
  ],
})
export class AppModule {}
