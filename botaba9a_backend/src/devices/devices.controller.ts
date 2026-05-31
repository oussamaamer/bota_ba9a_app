import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  UseGuards,
  Req,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { DevicesService } from './devices.service';
import { CreateDeviceDto } from './dto/create-device.dto';
import { CreateReadingDto } from './dto/create-reading.dto';
import { AuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { AuthenticatedUser } from '../common/dto/api-response.dto';
import { Request } from 'express';

@Controller('devices')
@UseGuards(AuthGuard)
export class DevicesController {
  constructor(private readonly devicesService: DevicesService) {}

  @Get()
  async listDevices(@CurrentUser() user: AuthenticatedUser, @Req() req: Request) {
    const token = req.headers.authorization?.split(' ')[1] || '';
    return this.devicesService.listDevices(user.id, token);
  }

  @Get(':id')
  async getDevice(
    @Param('id') id: string,
    @CurrentUser() user: AuthenticatedUser,
    @Req() req: Request,
  ) {
    const token = req.headers.authorization?.split(' ')[1] || '';
    return this.devicesService.getDevice(id, user.id, token);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createDevice(
    @Body() dto: CreateDeviceDto,
    @CurrentUser() user: AuthenticatedUser,
    @Req() req: Request,
  ) {
    const token = req.headers.authorization?.split(' ')[1] || '';
    return this.devicesService.createDevice(dto, user.id, token);
  }

  @Post(':id/readings')
  @HttpCode(HttpStatus.CREATED)
  async submitReading(
    @Param('id') id: string,
    @Body() dto: CreateReadingDto,
    @CurrentUser() user: AuthenticatedUser,
    @Req() req: Request,
  ) {
    const token = req.headers.authorization?.split(' ')[1] || '';
    return this.devicesService.submitReading(id, dto, user.id, token);
  }

  @Get(':id/readings')
  async getReadings(
    @Param('id') id: string,
    @CurrentUser() user: AuthenticatedUser,
    @Req() req: Request,
  ) {
    const token = req.headers.authorization?.split(' ')[1] || '';
    return this.devicesService.getReadings(id, user.id, token);
  }
}
