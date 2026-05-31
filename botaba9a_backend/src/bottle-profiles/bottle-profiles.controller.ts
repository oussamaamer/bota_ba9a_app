import { Controller, Get, UseGuards, Req } from '@nestjs/common';
import { BottleProfilesService } from './bottle-profiles.service';
import { AuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { AuthenticatedUser } from '../common/dto/api-response.dto';
import { Request } from 'express';

@Controller('bottle-profiles')
@UseGuards(AuthGuard)
export class BottleProfilesController {
  constructor(private readonly bottleProfilesService: BottleProfilesService) {}

  @Get()
  async listProfiles(
    @CurrentUser() user: AuthenticatedUser,
    @Req() req: Request,
  ) {
    const token = req.headers.authorization?.split(' ')[1] || '';
    return this.bottleProfilesService.listProfiles(user.id, token);
  }
}
