/**
 * Standard API response interfaces for BOTABA9A
 */

export interface ApiMeta {
  requestId: string;
  timestamp: number;
  version: string;
}

export interface ApiSuccessResponse<T = unknown> {
  data: T;
  meta: ApiMeta;
}

export interface ApiErrorDetail {
  code: string;
  message: string;
  statusCode: number;
}

export interface ApiErrorResponse {
  error: ApiErrorDetail;
}

/**
 * Authenticated user attached to request by AuthGuard
 */
export interface AuthenticatedUser {
  id: string;
  email: string;
  role?: string;
}
