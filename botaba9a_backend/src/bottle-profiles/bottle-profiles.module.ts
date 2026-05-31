import { Module } from '@nestjs/common';
import { BottleProfilesController } from './bottle-profiles.controller';
import { BottleProfilesService } from './bottle-profiles.service';

@Module({
  controllers: [BottleProfilesController],
  providers: [BottleProfilesService],
  exports: [BottleProfilesService],
})
export class BottleProfilesModule {}
