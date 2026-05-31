"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var BottleProfilesService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.BottleProfilesService = void 0;
const common_1 = require("@nestjs/common");
const supabase_config_1 = require("../common/config/supabase.config");
let BottleProfilesService = BottleProfilesService_1 = class BottleProfilesService {
    constructor() {
        this.logger = new common_1.Logger(BottleProfilesService_1.name);
    }
    async listProfiles(userId, accessToken) {
        const supabase = (0, supabase_config_1.createAnonClient)(accessToken);
        const { data, error } = await supabase
            .from('bottle_profiles')
            .select('*')
            .or(`is_public.eq.true,created_by.eq.${userId}`)
            .order('name', { ascending: true });
        if (error) {
            this.logger.error(`List bottle profiles failed: ${error.message}`);
            return [];
        }
        return data || [];
    }
};
exports.BottleProfilesService = BottleProfilesService;
exports.BottleProfilesService = BottleProfilesService = BottleProfilesService_1 = __decorate([
    (0, common_1.Injectable)()
], BottleProfilesService);
//# sourceMappingURL=bottle-profiles.service.js.map