# Authentication Flow — Voyanta AI

This document establishes the user authentication flows, session token persistence, JWT refresh cycles, and secure storage rules for Voyanta AI.

---

## 1. Authentication Topology

Voyanta AI utilizes **Supabase Auth** as the backend credentials manager. The client supports:
- **Email & Password Sign In / Sign Up**
- **OAuth Providers (Google, Apple)**
- **Biometric Quick Unlock (FaceID / Fingerprint)** for local session resume.

```
       +------------------+
       |   Client App     |
       +------------------+
         /              \
        / (Auth Credentials)
       v                  v
+--------------+    +----------------------------+
|  Biometrics  |    |     Supabase Auth API      |
|  (Local Auth)|    +----------------------------+
+--------------+        |                     |
   (Decrypts)           v (JWT Access Token)  v (Refresh Token)
        \         +------------------+   +-------------------+
         -------->| Secure storage   |   | Token Refresh Loop|
                  | (Keychain/Keystore)| +-------------------+
                  +------------------+
```

---

## 2. JWT Lifecycles & Token Refresh

Supabase JWT access tokens expire after **1 hour** (3600 seconds). The client handles refresh operations implicitly in the background:

1. **Storage**: Upon successful login, the client writes the `access_token` and `refresh_token` to the system **Secure Storage** (Keychain on iOS, EncryptedSharedPrefs on Android).
2. **Refresh Event**: The application initiates a background listener that intercepts token expiration. If an API request returns an access token warning or if the remaining lifetime of the current JWT is under **5 minutes**, the SDK triggers a refresh call:
   ```dart
   // Implicit token validation check before network request
   if (session.expiresAt.difference(DateTime.now()).inMinutes < 5) {
     final response = await supabase.auth.refreshSession();
     saveNewSessionToSecureStorage(response.session);
   }
   ```

---

## 3. Local Secure Vault & Biometrics

To optimize the user experience, users do not need to log in via email on every app launch.

- **Session Resume**: When the app boots, it attempts to load the token from secure storage.
- **Biometric Unlock**: If biometric lock is enabled in user settings, the app prompts for fingerprint/face scanning. On success, the local cryptographic keys decrypt the stored Supabase session tokens, enabling immediate offline/online access to trip data.
- **Security Rule**: Tokens must never be stored in plain text files (e.g., standard Shared Preferences or plist data). They must always reside in hardware-encrypted secure storage vaults.
