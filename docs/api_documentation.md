# BOTABA9A API Documentation — Phase 1

## Base URL

```
http://localhost:3001
```

## Response Format

### Success Response
```json
{
  "data": { ... },
  "meta": {
    "requestId": "550e8400-e29b-41d4-a716-446655440000",
    "timestamp": 1716825600,
    "version": "v1"
  }
}
```

### Error Response
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "statusCode": 400
  }
}
```

---

## Authentication

All endpoints except `/auth/register` and `/auth/login` require authentication.

Include the JWT token in the `Authorization` header:
```
Authorization: Bearer <token>
```

---

## Endpoints

### Auth

#### POST /auth/register

Create a new user account.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "full_name": "Mohammed Alami",
  "phone": "+212612345678",
  "role": "client",
  "business_name": "Café Central"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | ✅ | Valid email address |
| password | string | ✅ | Minimum 8 characters |
| full_name | string | ✅ | User's full name |
| phone | string | ❌ | Phone number |
| role | string | ❌ | `client` (default), `admin`, `technician`, `vendor` |
| business_name | string | ❌ | Business name (for vendors/restaurants) |

**Response (201):**
```json
{
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com"
    },
    "session": {
      "access_token": "jwt-token",
      "refresh_token": "refresh-token",
      "expires_in": 3600
    }
  }
}
```

---

#### POST /auth/login

Authenticate and receive a JWT token.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response (200):**
```json
{
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com"
    },
    "session": {
      "access_token": "jwt-token",
      "refresh_token": "refresh-token",
      "expires_in": 3600
    }
  }
}
```

---

#### POST /auth/logout

🔒 **Requires Authentication**

Log out and invalidate the current session.

**Response (200):**
```json
{
  "data": {
    "message": "Logged out successfully"
  }
}
```

---

#### GET /auth/me

🔒 **Requires Authentication**

Get the current user's profile.

**Response (200):**
```json
{
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "full_name": "Mohammed Alami",
    "phone": "+212612345678",
    "role": "client",
    "business_name": "Café Central",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### Devices

#### GET /devices

🔒 **Requires Authentication**

List all devices owned by the authenticated user.

**Response (200):**
```json
{
  "data": [
    {
      "id": "uuid",
      "esp32_id": "esp32_abc123",
      "name": "Cuisine Principale",
      "location": "Restaurant - Casablanca",
      "is_active": true,
      "last_seen_at": "2024-01-15T10:30:00Z",
      "bottle_profile": {
        "id": "uuid",
        "name": "Butagaz 12kg",
        "empty_weight_grams": 14500,
        "full_weight_grams": 26500
      }
    }
  ]
}
```

---

#### GET /devices/:id

🔒 **Requires Authentication**

Get a single device by ID.

---

#### POST /devices

🔒 **Requires Authentication**

Register a new device.

**Request Body:**
```json
{
  "esp32_id": "esp32_abc123",
  "name": "Cuisine Principale",
  "location": "Restaurant - Casablanca",
  "bottle_profile_id": "uuid"
}
```

---

#### POST /devices/:id/readings

🔒 **Requires Authentication**

Submit a weight reading (manual input in Phase 1).

**Request Body:**
```json
{
  "weight_grams": 8450,
  "source": "manual",
  "recorded_at": "2024-01-15T10:30:00Z"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| weight_grams | integer | ✅ | Weight in grams (≥ 0) |
| source | string | ❌ | `manual` (default), `ble`, `wifi`, `sync` |
| recorded_at | string | ❌ | ISO timestamp (defaults to now) |

**Response (201):**
```json
{
  "data": {
    "id": "uuid",
    "device_id": "uuid",
    "weight_grams": 8450,
    "source": "manual",
    "recorded_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### Stats

#### GET /devices/:id/stats

🔒 **Requires Authentication**

Get calculated statistics for a device.

**Response (200):**
```json
{
  "data": {
    "device_id": "uuid",
    "device_name": "Cuisine Principale",
    "bottle_profile": {
      "name": "Butagaz 12kg",
      "empty_weight_grams": 14500,
      "full_weight_grams": 26500,
      "capacity_grams": 12000
    },
    "current": {
      "weight_grams": 8450,
      "gas_weight_grams": -6050,
      "gas_level_pct": 0,
      "status": "critical",
      "last_reading_at": "2024-01-15T10:30:00Z"
    },
    "consumption": {
      "rate_g_per_hour": 125.5,
      "rate_g_per_day": 3012.0,
      "estimated_hours_left": 48.2,
      "estimated_days_left": 2.0
    }
  }
}
```

---

### Bottle Profiles

#### GET /bottle-profiles

🔒 **Requires Authentication**

List available bottle profiles (public + user's custom).

**Response (200):**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Butagaz 6kg",
      "empty_weight_grams": 7200,
      "full_weight_grams": 13200,
      "alert_threshold_pct": 15,
      "is_public": true
    },
    {
      "id": "uuid",
      "name": "Butagaz 12kg",
      "empty_weight_grams": 14500,
      "full_weight_grams": 26500,
      "alert_threshold_pct": 15,
      "is_public": true
    }
  ]
}
```

---

## Error Codes

| Code | Status | Description |
|------|--------|-------------|
| `VALIDATION_ERROR` | 400 | Invalid request body |
| `UNAUTHORIZED` | 401 | Missing or invalid token |
| `FORBIDDEN` | 403 | Access denied |
| `DEVICE_NOT_FOUND` | 404 | Device not found or access denied |
| `PROFILE_NOT_FOUND` | 404 | Bottle profile not found |
| `DUPLICATE_DEVICE` | 409 | ESP32 ID already registered |
| `INTERNAL_ERROR` | 500 | Internal server error |
