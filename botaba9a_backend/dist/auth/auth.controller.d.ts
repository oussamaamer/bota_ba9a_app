import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { AuthenticatedUser } from '../common/dto/api-response.dto';
import { Request } from 'express';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    register(dto: RegisterDto): Promise<{
        user: {
            id: string | undefined;
            email: string | undefined;
        };
        session: {
            access_token: string;
            refresh_token: string;
            expires_in: number;
        } | null;
    }>;
    login(dto: LoginDto): Promise<{
        user: {
            id: string;
            email: string | undefined;
        };
        session: {
            access_token: string;
            refresh_token: string;
            expires_in: number;
        };
    }>;
    logout(req: Request): Promise<{
        message: string;
    }>;
    getMe(user: AuthenticatedUser, req: Request): Promise<{
        email: string;
        id: any;
        full_name: any;
        phone: any;
        role: any;
        business_name: any;
        created_at: any;
    }>;
}
