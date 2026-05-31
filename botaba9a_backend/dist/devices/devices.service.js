"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var DevicesService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.DevicesService = void 0;
const common_1 = require("@nestjs/common");
const supabase_config_1 = require("../common/config/supabase.config");
let DevicesService = DevicesService_1 = class DevicesService {
    constructor() {
        this.logger = new common_1.Logger(DevicesService_1.name);
    }
    async listDevices(userId, accessToken) {
        const supabase = (0, supabase_config_1.createAnonClient)(accessToken);
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
            throw new common_1.NotFoundException({
                code: 'DEVICES_FETCH_FAILED',
                message: 'Failed to fetch devices',
            });
        }
        return data || [];
    }
    async getDevice(deviceId, userId, accessToken) {
        const supabase = (0, supabase_config_1.createAnonClient)(accessToken);
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
            throw new common_1.NotFoundException({
                code: 'DEVICE_NOT_FOUND',
                message: 'Device not found or access denied',
            });
        }
        return data;
    }
    async createDevice(dto, userId, accessToken) {
        const supabase = (0, supabase_config_1.createAnonClient)(accessToken);
        const { data: existing } = await supabase
            .from('devices')
            .select('id')
            .eq('esp32_id', dto.esp32_id)
            .maybeSingle();
        if (existing) {
            throw new common_1.ConflictException({
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
            throw new common_1.ConflictException({
                code: 'DEVICE_CREATE_FAILED',
                message: error.message,
            });
        }
        return data;
    }
    async submitReading(deviceId, dto, userId, accessToken) {
        const supabase = (0, supabase_config_1.createAnonClient)(accessToken);
        const { data: device, error: deviceError } = await supabase
            .from('devices')
            .select('id, owner_id')
            .eq('id', deviceId)
            .single();
        if (deviceError || !device) {
            throw new common_1.NotFoundException({
                code: 'DEVICE_NOT_FOUND',
                message: 'Device not found or access denied',
            });
        }
        if (device.owner_id !== userId) {
            throw new common_1.ForbiddenException({
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
            throw new common_1.ConflictException({
                code: 'READING_SUBMIT_FAILED',
                message: error.message,
            });
        }
        await supabase
            .from('devices')
            .update({ last_seen_at: now })
            .eq('id', deviceId);
        return data;
    }
    async getReadings(deviceId, userId, accessToken, limit = 50) {
        await this.getDevice(deviceId, userId, accessToken);
        const supabase = (0, supabase_config_1.createAnonClient)(accessToken);
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
};
exports.DevicesService = DevicesService;
exports.DevicesService = DevicesService = DevicesService_1 = __decorate([
    (0, common_1.Injectable)()
], DevicesService);
//# sourceMappingURL=devices.service.js.map