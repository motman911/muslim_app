# Noor Firebase Backend

This repository now includes a Firebase backend scaffold for Noor Islamic app.

## Implemented Components

- Firebase project configuration (`.firebaserc`, `firebase.json`)
- Firestore security rules (`firestore.rules`)
- Firestore indexes (`firestore.indexes.json`)
- Storage security rules (`storage.rules`)
- Cloud Functions modules in `functions/src`
  - Auth triggers
  - Social triggers and callable invite code
  - Notification jobs and token callables
  - Stats jobs
- Jest baseline test in `functions/test`

## Firestore Top-Level Collections

- `users`
- `fcm_tokens`
- `groups`
- `challenges`

## Run Locally (Emulator)

1. Install Firebase CLI:
   - `npm i -g firebase-tools`
2. Install function dependencies:
   - `cd functions`
   - `npm install`
3. Start emulators from project root:
   - `firebase emulators:start`

## Deploy

- `firebase deploy --only firestore:rules,firestore:indexes,storage`
- `firebase deploy --only functions`

## Notes

- Push notification batching is implemented with a max 500 tokens batch.
- Social notifications are sent to member/admin tokens stored in `fcm_tokens`.
- User data deletion trigger removes profile + supported subcollections.
