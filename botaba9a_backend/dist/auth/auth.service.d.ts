import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
export declare class AuthService {
    private readonly logger;
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
    logout(accessToken: string): Promise<{
        message: string;
    }>;
    getProfile(userId: string, accessToken: string): Promise<{
        id: any;
        email: string;
        full_name: any;
        phone: any;
        role: any;
        business_name: any;
        created_at: any;
    }>;
}
