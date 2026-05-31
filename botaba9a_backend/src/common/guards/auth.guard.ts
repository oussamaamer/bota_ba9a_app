import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
  Logger,
} from '@nestjs/common';
import { Request } from 'express';
import { createAnonClient } from '../config/supabase.config';

/**
 * Authentication guard that validates the JWT token from the
 * Authorization header using Supabase auth.getUser().
 *
 * On success, attaches the user object to request.user.
 */
@Injectable()
export class AuthGuard implements CanActivate {
  private readonly logger = new Logger(AuthGuard.name);

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<Request>();
    const token = this.extractTokenFromHeader(request);

    if (!token) {
      throw new UnauthorizedException({
        code: 'UNAUTHORIZED',
        message: 'Missing authentication token',
      });
    }

    try {
      const supabase = createAnonClient(token);
      const { data, error } = await supabase.auth.getUser(token);

      if (error || !data.user) {
        throw new UnauthorizedException({
          code: 'UNAUTHORIZED',
          message: 'Invalid or expired authentication token',
        });
      }

      // Attach user to request for downstream use
      (request as unknown as Record<string, unknown>)['user'] = {
        id: data.user.id,
        email: data.user.email,
        role: data.user.user_metadata?.['role'] || 'client',
      };

      return true;
    } catch (err) {
      if (err instanceof UnauthorizedException) {
        throw err;
      }
      this.logger.error('Auth guard error:', err);
      throw new UnauthorizedException({
        code: 'UNAUTHORIZED',
        message: 'Authentication failed',
      });
    }
  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const authHeader = request.headers.authorization;
    if (!authHeader) return undefined;

    const [type, token] = authHeader.split(' ');
    return type === 'Bearer' ? token : undefined;
  }
}
