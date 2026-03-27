const functions = require('firebase-functions');
const { admin, db } = require('../config');

exports.registerDeviceToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Authentication required');
  }

  const { deviceId, token, platform } = data || {};
  if (!deviceId || !token) {
    throw new functions.https.HttpsError('invalid-argument', 'deviceId and token are required');
  }

  const uid = context.auth.uid;
  const now = admin.firestore.FieldValue.serverTimestamp();

  await db.collection('fcm_tokens').doc(uid).set(
    {
      tokens: {
        [deviceId]: token,
      },
      platform: {
        [deviceId]: platform || 'unknown',
      },
      updatedAt: now,
    },
    { merge: true }
  );

  await db.collection('users').doc(uid).set(
    {
      fcmTokens: admin.firestore.FieldValue.arrayUnion(token),
      lastSeen: now,
    },
    { merge: true }
  );

  return { ok: true };
});
