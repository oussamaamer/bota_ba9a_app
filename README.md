# BOTABA9A 🔥

**Smart Gas Bottle Monitoring System for Morocco**

BOTABA9A is a mobile-first IoT application that replaces manual gas bottle control with a secure digital monitoring system. Designed for restaurants, cafés, bakeries, gas vendors, and households across Morocco.

## 🏗 Architecture

```
App/
├── botaba9a_app/           # Flutter mobile application
├── botaba9a_backend/       # NestJS REST API backend
├── database/               # SQL migrations & RLS policies
│   └── migrations/
│       ├── 01_schema.sql
│       ├── 02_rls_policies.sql
│       └── 03_seed_bottle_profiles.sql
├── docs/                   # API documentation
├── .env.example
└── README.md
```

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ and npm
- **Flutter** 3.22+
- **Supabase** account (free tier works)

### 1. Database Setup

1. Create a new project on [supabase.com](https://supabase.com)
2. Go to **SQL Editor** and run the migration files in order:
   - `database/migrations/01_schema.sql` — Creates all tables
   - `database/migrations/02_rls_policies.sql` — Enables Row Level Security
   - `database/migrations/03_seed_bottle_profiles.sql` — Seeds standard Moroccan bottle profiles

### 2. Backend Setup

```bash
cd botaba9a_backend

# Copy environment file and fill in your Supabase credentials
cp .env.example .env

# Install dependencies
npm install

# Start development server
npm run start:dev
```

The backend will start on `http://localhost:3001`.

### 3. Flutter App Setup

```bash
cd botaba9a_app

# Copy environment file
cp .env.example .env

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` in both `botaba9a_backend/` and `botaba9a_app/` and fill in:

| Variable | Description |
|----------|-------------|
| `SUPABASE_URL` | Your Supabase project URL |
| `SUPABASE_ANON_KEY` | Supabase anonymous/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service role key (backend only) |
| `JWT_SECRET` | JWT secret for token verification |
| `PORT` | Backend server port (default: 3000) |

## 📡 IoT Payload Format

The ESP32 device sends this JSON payload:

```json
{
  "device_id": "esp32_abc123",
  "weight_grams": 8450,
  "timestamp": 1716825600,
  "battery_mv": 3720,
  "rssi": -67
}
```

The system calculates everything else from the `weight_grams` value:
- Gas remaining weight & percentage
- Consumption rate
- Estimated remaining duration
- Alerts (leak, low gas, signal lost, etc.)

## 📊 Database Schema

| Table | Description |
|-------|-------------|
| `profiles` | User profiles linked to Supabase Auth |
| `devices` | ESP32 IoT devices |
| `bottle_profiles` | Gas bottle specifications (Butagaz, Afriquia, custom) |
| `weight_readings` | Raw weight readings from devices |
| `alerts` | System-generated alerts |

All tables have Row Level Security enabled — users can only access their own data.

## 🎨 Design System

| Element | Value |
|---------|-------|
| Primary | `#1A3C5E` (Navy) |
| Accent | `#E8761A` (Orange) |
| Danger | `#B32626` (Red) |
| Success | `#1E7D4F` (Green) |
| Warning | `#B07D00` (Amber) |
| Surface | `#F5F7FA` (Light) |

Typography: **Poppins** (titles), **Inter** (body), **JetBrains Mono** (technical values)

## 🗺 Development Phases

| Phase | Scope | Status |
|-------|-------|--------|
| 1 | Schema, Auth, Flutter Structure, Dashboard | ✅ Complete |
| 2 | Devices CRUD, Bottle Profiles, Readings, Basic Alerts | 🔜 Next |
| 3 | BLE Service, Calibration, Offline Cache, Sync | ⬜ Planned |
| 4 | Anomaly Detection, Charts, Notifications, Device Detail | ⬜ Planned |
| 5 | Tests, Polish, Dark Mode, Localization, Deployment | ⬜ Planned |

## 📄 License

Proprietary — All rights reserved.
