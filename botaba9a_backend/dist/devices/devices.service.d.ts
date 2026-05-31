import { CreateDeviceDto } from './dto/create-device.dto';
import { CreateReadingDto } from './dto/create-reading.dto';
export declare class DevicesService {
    private readonly logger;
    listDevices(userId: string, accessToken: string): Promise<any[]>;
    getDevice(deviceId: string, userId: string, accessToken: string): Promise<any>;
    createDevice(dto: CreateDeviceDto, userId: string, accessToken: string): Promise<any>;
    submitReading(deviceId: string, dto: CreateReadingDto, userId: string, accessToken: string): Promise<any>;
    getReadings(deviceId: string, userId: string, accessToken: string, limit?: number): Promise<any[]>;
}
