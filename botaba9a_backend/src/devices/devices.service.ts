import {
  Injectable,
  NotFoundException,
  ConflictException,
  Logger,
  ForbiddenException,
} from '@nestjs/common';
import { createAnonClient } from '../common/config/supabase.config';
import { CreateDeviceDto } from './dto/create-device.dto';
import { CreateReadingDto } from './dto/create-reading.dto';

@Injectable()
export class DevicesService {
  private readonly logger = new Logger(DevicesService.name);

  /**
   * List all devices owned by the authenticated user.
   */
  async listDevices(userId: string, accessToken: string) {
    const supabase = createAnonClient(accessToken);

    const { data, error } = await supabase
      .from('devices')
      .select(`
        *,
        bottle_profile:bottle_profiles(*)
      `)
      .eq('owner_id', userId)
      .order('created_at', { ascending: false });

    if (error) {
      this.logger.error(`List devices failed: ${error.message}`);
      throw new NotFoundException({
        code: 'DEVICES_FETCH_FAILED',
        message: 'Failed to fetch devices',
      });
    }

    return data || [];
  }

  /**
   * Get a single device by ID, verifying ownership.
   */
  async getDevice(deviceId: string, userId: string, accessToken: string) {
    const supabase = createAnonClient(accessToken);

    const { data, error } = await supabase
      .from('devices')
      .select(`
        *,
        bottle_profile:bottle_profiles(*)
      `)
      .eq('id', deviceId)
      .eq('owner_id', userId)
      .single();

    if (error || !data) {
      throw new NotFoundException({
        code: 'DEVICE_NOT_FOUND',
        message: 'Device not found or access denied',
      });
    }

    return data;
  }

  /**
   * Register a new device for the authenticated user.
   */
  async createDevice(dto: CreateDeviceDto, userId: string, accessToken: string) {
    const supabase = createAnonClient(accessToken);

    // Check for duplicate ESP32 ID
    const { data: existing } = await supabase
      .from('devices')
      .select('id')
      .eq('esp32_id', dto.esp32_id)
      .maybeSingle();

    if (existing) {
      throw new ConflictException({
        code: 'DUPLICATE_DEVICE',
        message: 'A device with this ESP32 ID is already registered',
      });
    }

    const { data, error } = await supabase
      .from('devices')
      .insert({
        owner_id: userId,
        esp32_id: dto.esp32_id,
        name: dto.name || `Device ${dto.esp32_id.slice(-6)}`,
        location: dto.location || null,
        bottle_profile_id: dto.bottle_profile_id || null,
        is_active: true,
      })
      .select(`
        *,
        bottle_profile:bottle_profiles(*)
      `)
      .single();

    if (error) {
      this.logger.error(`Create device failed: ${error.message}`);
      throw new ConflictException({
        code: 'DEVICE_CREATE_FAILED',
        message: error.message,
      });
    }

    return data;
  }

  /**
   * Submit a weight reading for a device.
   */
  async submitReading(
    deviceId: string,
    dto: CreateReadingDto,
    userId: string,
    accessToken: string,
  ) {
    const supabase = createAnonClient(accessToken);

    // Verify device ownership
    const { data: device, error: deviceError } = await supabase
      .from('devices')
      .select('id, owner_id')
      .eq('id', deviceId)
      .single();

    if (deviceError || !device) {
      throw new NotFoundException({
        code: 'DEVICE_NOT_FOUND',
        message: 'Device not found or access denied',
      });
    }

    if (device.owner_id !== userId) {
      throw new ForbiddenException({
        code: 'FORBIDDEN',
        message: 'You do not own this device',
      });
    }

    const now = new Date().toISOString();

    const { data, error } = await supabase
      .from('weight_readings')
      .insert({
        device_id: deviceId,
        weight_grams: dto.weight_grams,
        source: dto.source || 'manual',
        recorded_at: dto.recorded_at || now,
        received_at: now,
        uploaded_to_cloud: true,
      })
      .select()
      .single();

    if (error) {
      this.logger.error(`Submit reading failed: ${error.message}`);
      throw new ConflictException({
        code: 'READING_SUBMIT_FAILED',
        message: error.message,
      });
    }

    // Update device last_seen_at
    await supabase
      .from('devices')
      .update({ last_seen_at: now })
      .eq('id', deviceId);

    return data;
  }

  /**
   * Get recent readings for a device.
   */
  async getReadings(
    deviceId: string,
    userId: string,
    accessToken: string,
    limit = 50,
  ) {
    // Verify ownership first
    await this.getDevice(deviceId, userId, accessToken);

    const supabase = createAnonClient(accessToken);

    const { data, error } = await supabase
      .from('weight_readings')
      .select('*')
      .eq('device_id', deviceId)
      .order('recorded_at', { ascending: false })
      .limit(limit);

    if (error) {
      this.logger.error(`Get readings failed: ${error.message}`);
      return [];
    }

    return data || [];
  }
}
