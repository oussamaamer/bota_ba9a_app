import { DevicesService } from './devices.service';
import { CreateDeviceDto } from './dto/create-device.dto';
import { CreateReadingDto } from './dto/create-reading.dto';
import { AuthenticatedUser } from '../common/dto/api-response.dto';
import { Request } from 'express';
export declare class DevicesController {
    private readonly devicesService;
    constructor(devicesService: DevicesService);
    listDevices(user: AuthenticatedUser, req: Request): Promise<any[]>;
    getDevice(id: string, user: AuthenticatedUser, req: Request): Promise<any>;
    createDevice(dto: CreateDeviceDto, user: AuthenticatedUser, req: Request): Promise<any>;
    submitReading(id: string, dto: CreateReadingDto, user: AuthenticatedUser, req: Request): Promise<any>;
    getReadings(id: string, user: AuthenticatedUser, req: Request): Promise<any[]>;
}
