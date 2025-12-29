# ?? Troubleshooting Report � Mobile SecOps Challenge

## Overview
- Application: RentVerse Mobile (Android, Flutter)
- Backend API: https://rvapi.ilhamdean.cloud
- Scope: Client-side fixes only (backend unchanged)
- Objective: Diagnose and resolve client-side security misconfigurations causing authentication and OTP verification failures.

## Observed Symptoms
During runtime testing, the application exhibited the following issues:
- Login API (`/auth/login`) returned HTTP 200 with valid access and refresh tokens.
- Immediately after login, protected actions failed.
- The following log repeatedly appeared: `Access token missing, skip register device`
- Authenticated requests returned HTTP 401 / 403.
- OTP send and verification failed on the mobile client.

### Logcat Excerpt (Redacted)
```text
<-- 200 https://rvapi.ilhamdean.cloud/api/v1/auth/login
Data: {status: success, message: Login successful, data: {user: {...}, accessToken: <redacted>, refreshToken: <redacted>}}
Access token missing, skip register device
```

## Root Cause Analysis
### 1) Token Persistence Misconfiguration
- Access tokens were saved using the literal key "TOKEN_KEY" instead of the configured constant.
- Tokens were also stored with a leading whitespace character.
- When retrieved, the token appeared null or malformed.

Impact:
The app behaved as if no access token existed, even after a successful login.

### 2) Authorization Header Misconfiguration
- The HTTP interceptor used an incorrect header name and malformed Bearer format.
- Authenticated requests were sent without a valid `Authorization` header.

Impact:
Backend rejected requests with 401 / 403, causing immediate session invalidation.

### 3) OTP Client Misconfiguration
- The mobile client called an incorrect OTP endpoint:
  -  `/auth/otp/sent`
  -  `/auth/otp/send`
- OTP responses were parsed using an incompatible JSON type, causing a runtime exception.
- OTP emails were sent to Mailpit (test SMTP server), not directly to Gmail.

Impact:
OTP delivery and verification failed on the mobile client despite a healthy backend.

## Applied Fixes
### Token Storage Fix
- Store access and refresh tokens using the correct SharedPreferences keys.
- Trim token values to prevent malformed Bearer tokens.

File:
- `lib/features/auth/data/source/auth_local_service.dart`

### Authorization Header Fix
- Attach a properly formatted `Authorization: Bearer <token>` header to all protected requests.

File:
- `lib/core/network/interceptors.dart`

### OTP Flow Fix
- Correct OTP send and verify endpoint paths.
- Update response parsing to handle dynamic JSON structures safely.

File:
- `lib/features/auth/data/source/auth_api_service.dart`

## Verification & Results
After applying the fixes:
- Login succeeds and session persists.
- Authenticated endpoint `/auth/me` returns HTTP 200.
- Access token is correctly retrieved and attached to requests.
- OTP send and verify requests reach valid backend endpoints.
- User remains logged in without session invalidation.

Evidence:
- Logcat confirms successful authenticated requests.
- Screenshot of logged-in state and accessible profile screen (attached).

## Security Notes
- No backend API changes were made.
- No TLS/SSL validation was bypassed.
- No TrustAllCerts or insecure network configurations were introduced.
- All fixes comply with secure mobile application development practices.

