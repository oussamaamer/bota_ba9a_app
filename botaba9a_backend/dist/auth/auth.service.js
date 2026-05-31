"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var AuthService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const supabase_config_1 = require("../common/config/supabase.config");
let AuthService = AuthService_1 = class AuthService {
    constructor() {
        this.logger = new common_1.Logger(AuthService_1.name);
    }
    async register(dto) {
        const supabase = (0, supabase_config_1.createServiceClient)();
        const { data, error } = await supabase.auth.signUp({
            email: dto.email,
            password: dto.password,
            options: {
                data: {
                    full_name: dto.full_name,
                    phone: dto.phone || '',
                    role: dto.role || 'client',
                    business_name: dto.business_name || '',
                },
            },
        });
        if (error) {
            this.logger.error(`Registration failed: ${error.message}`);
            if (error.message.includes('already registered')) {
                throw new common_1.ConflictException({
                    code: 'USER_ALREADY_EXISTS',
                    message: 'An account with this email already exists',
                });
            }
            throw new common_1.InternalServerErrorException({
                code: 'REGISTRATION_FAILED',
                message: error.message,
            });
        }
        if (data.user) {
            const { error: profileError } = await supabase
                .from('profiles')
                .upsert({
                id: data.user.id,
                full_name: dto.full_name,
                phone: dto.phone || null,
                role: dto.role || 'client',
                business_name: dto.business_name || null,
            }, { onConflict: 'id' });
            if (profileError) {
                this.logger.warn(`Profile upsert warning: ${profileError.message}`);
            }
        }
        return {
            user: {
                id: data.user?.id,
                email: data.user?.email,
            },
            session: data.session
                ? {
                    access_token: data.session.access_token,
                    refresh_token: data.session.refresh_token,
                    expires_in: data.session.expires_in,
                }
                : null,
        };
    }
    async login(dto) {
        const supabase = (0, supabase_config_1.createAnonClient)();
        const { data, error } = await supabase.auth.signInWithPassword({
            email: dto.email,
            password: dto.password,
        });
        if (error) {
            this.logger.warn(`Login failed for ${dto.email}: ${error.message}`);
            throw new common_1.UnauthorizedException({
                code: 'INVALID_CREDENTIALS',
                message: 'Invalid email or password',
            });
        }
        return {
            user: {
                id: data.user.id,
                email: data.user.email,
            },
            session: {
                access_token: data.session.access_token,
                refresh_token: data.session.refresh_token,
                expires_in: data.session.expires_in,
            },
        };
    }
    async logout(accessToken) {
        const supabase = (0, supabase_config_1.createAnonClient)(accessToken);
        const { error } = await supabase.auth.signOut();
        if (error) {
            this.logger.warn(`Logout warning: ${error.message}`);
        }
        return { message: 'Logged out successfully' };
    }
    async getProfile(userId, accessToken) {
        const supabase = (0, supabase_config_1.createAnonClient)(accessToken);
        const { data, error } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', userId)
            .single();
        if (error || !data) {
            this.logger.error(`Profile fetch failed: ${error?.message}`);
            throw new common_1.UnauthorizedException({
                code: 'PROFILE_NOT_FOUND',
                message: 'User profile not found',
            });
        }
        return {
            id: data.id,
            email: '',
            full_name: data.full_name,
            phone: data.phone,
            role: data.role,
            business_name: data.business_name,
            created_at: data.created_at,
        };
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = AuthService_1 = __decorate([
    (0, common_1.Injectable)()
], AuthService);
//# sourceMappingURL=auth.service.js.map