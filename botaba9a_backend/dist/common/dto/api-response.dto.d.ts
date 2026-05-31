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
export interface AuthenticatedUser {
    id: string;
    email: string;
    role?: string;
}
