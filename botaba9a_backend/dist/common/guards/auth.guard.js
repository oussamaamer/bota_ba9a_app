"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var AuthGuard_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthGuard = void 0;
const common_1 = require("@nestjs/common");
const supabase_config_1 = require("../config/supabase.config");
let AuthGuard = AuthGuard_1 = class AuthGuard {
    constructor() {
        this.logger = new common_1.Logger(AuthGuard_1.name);
    }
    async canActivate(context) {
        const request = context.switchToHttp().getRequest();
        const token = this.extractTokenFromHeader(request);
        if (!token) {
            throw new common_1.UnauthorizedException({
                code: 'UNAUTHORIZED',
                message: 'Missing authentication token',
            });
        }
        try {
            const supabase = (0, supabase_config_1.createAnonClient)(token);
            const { data, error } = await supabase.auth.getUser(token);
            if (error || !data.user) {
                throw new common_1.UnauthorizedException({
                    code: 'UNAUTHORIZED',
                    message: 'Invalid or expired authentication token',
                });
            }
            request['user'] = {
                id: data.user.id,
                email: data.user.email,
                role: data.user.user_metadata?.['role'] || 'client',
            };
            return true;
        }
        catch (err) {
            if (err instanceof common_1.UnauthorizedException) {
                throw err;
            }
            this.logger.error('Auth guard error:', err);
            throw new common_1.UnauthorizedException({
                code: 'UNAUTHORIZED',
                message: 'Authentication failed',
            });
        }
    }
    extractTokenFromHeader(request) {
        const authHeader = request.headers.authorization;
        if (!authHeader)
            return undefined;
        const [type, token] = authHeader.split(' ');
        return type === 'Bearer' ? token : undefined;
    }
};
exports.AuthGuard = AuthGuard;
exports.AuthGuard = AuthGuard = AuthGuard_1 = __decorate([
    (0, common_1.Injectable)()
], AuthGuard);
//# sourceMappingURL=auth.guard.js.map