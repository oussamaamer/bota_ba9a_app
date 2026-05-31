import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { AuthenticatedUser } from '../dto/api-response.dto';

/**
 * Custom parameter decorator to extract the authenticated user
 * from the request object. Must be used with AuthGuard.
 *
 * Usage: @CurrentUser() user: AuthenticatedUser
 */
export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): AuthenticatedUser => {
    const request = ctx.switchToHttp().getRequest<Record<string, unknown>>();
    return request['user'] as AuthenticatedUser;
  },
);
