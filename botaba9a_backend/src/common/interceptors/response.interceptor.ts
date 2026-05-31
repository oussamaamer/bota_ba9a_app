import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { v4 as uuidv4 } from 'uuid';
import { ApiSuccessResponse } from '../dto/api-response.dto';

/**
 * Global response interceptor that wraps all successful responses
 * in the standard BOTABA9A format: { data, meta }.
 */
@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, ApiSuccessResponse<T>> {
  intercept(
    _context: ExecutionContext,
    next: CallHandler,
  ): Observable<ApiSuccessResponse<T>> {
    return next.handle().pipe(
      map((data: T) => ({
        data,
        meta: {
          requestId: uuidv4(),
          timestamp: Math.floor(Date.now() / 1000),
          version: 'v1',
        },
      })),
    );
  }
}
