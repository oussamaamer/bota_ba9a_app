import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  Logger,
  InternalServerErrorException,
} from '@nestjs/common';
import { createServiceClient, createAnonClient } from '../common/config/supabase.config';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  /**
   * Register a new user via Supabase Auth.
   * User metadata (full_name, phone, role) is passed so the
   * database trigger can auto-create the profile row.
   */
  async register(dto: RegisterDto) {
    const supabase = createServiceClient();

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
        throw new ConflictException({
          code: 'USER_ALREADY_EXISTS',
          message: 'An account with this email already exists',
        });
      }
      throw new InternalServerErrorException({
        code: 'REGISTRATION_FAILED',
        message: error.message,
      });
    }

    // If the profile wasn't created by the trigger (e.g., trigger not set up yet),
    // create it manually via service role
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

  /**
   * Login with email and password.
   */
  async login(dto: LoginDto) {
    const supabase = createAnonClient();

    const { data, error } = await supabase.auth.signInWithPassword({
      email: dto.email,
      password: dto.password,
    });

    if (error) {
      this.logger.warn(`Login failed for ${dto.email}: ${error.message}`);
      throw new UnauthorizedException({
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

  /**
   * Logout — invalidate the current session.
   */
  async logout(accessToken: string) {
    const supabase = createAnonClient(accessToken);
    const { error } = await supabase.auth.signOut();

    if (error) {
      this.logger.warn(`Logout warning: ${error.message}`);
    }

    return { message: 'Logged out successfully' };
  }

  /**
   * Get the current user's profile from the profiles table.
   */
  async getProfile(userId: string, accessToken: string) {
    const supabase = createAnonClient(accessToken);

    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single();

    if (error || !data) {
      this.logger.error(`Profile fetch failed: ${error?.message}`);
      throw new UnauthorizedException({
        code: 'PROFILE_NOT_FOUND',
        message: 'User profile not found',
      });
    }

    return {
      id: data.id,
      email: '', // Will be filled from auth user
      full_name: data.full_name,
      phone: data.phone,
      role: data.role,
      business_name: data.business_name,
      created_at: data.created_at,
    };
  }
}
