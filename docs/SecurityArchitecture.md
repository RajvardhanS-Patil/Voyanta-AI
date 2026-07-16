# Security Architecture — Voyanta AI

This document establishes the security guidelines, access policies, cryptography standards, and API protection rules for Voyanta AI.

---

## 1. Supabase Row Level Security (RLS)

All database tables in Supabase require **RLS enabled**. Direct table access is blocked. Access is granted exclusively to authenticated users matching specific tenant guidelines.

### Policy: `trips`
Authenticated users can only read, write, or delete rows where the `user_id` matches their own Supabase authentication UUID:
```sql
-- Enable RLS
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;

-- Select Policy
CREATE POLICY "Users can view their own trips" ON trips
  FOR SELECT USING (auth.uid() = user_id);

-- Insert Policy
CREATE POLICY "Users can create their own trips" ON trips
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Update Policy
CREATE POLICY "Users can update their own trips" ON trips
  FOR UPDATE USING (auth.uid() = user_id);

-- Delete Policy
CREATE POLICY "Users can delete their own trips" ON trips
  FOR DELETE USING (auth.uid() = user_id);
```

---

## 2. API Key Protection & Network Security

- **Secrets Storage**: API Keys (like Mapbox access tokens and Supabase client keys) must never be hardcoded into configuration files or checked into git control repositories. They are injected as environment variables during build time:
  - Flutter: Injected via `--dart-define` or `--dart-define-from-file`.
  - Android/iOS: Loaded from Gradle properties or Xcode scheme variables.
- **SSL Pinning**: For production release builds, configure SSL certificate pinning inside the HTTP network wrapper layer to prevent Man-in-the-Middle (MITM) snooping attacks on public transit network connections.

---

## 3. Local Encryption (Secure Vaults)

- **Sensitive Data Caching**: Raw session logs and token variables must reside in hardware-encrypted secure storage vaults (Keychain on iOS, Keystore on Android).
- **Database Encryption**: In high-security environments, the local Isar database cache file is encrypted using a unique symmetric key generated locally and stored securely in the system Keychain/Keystore.
