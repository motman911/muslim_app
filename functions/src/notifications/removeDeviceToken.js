const functions = require('firebase-functions');
const { admin, db } = require('../config');

exports.removeDeviceToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Authentication required');
  }

  const { deviceId, token } = data || {};
  if (!deviceId || !token) {
    throw new functions.https.HttpsError('invalid-argument', 'deviceId and token are required');
  }

  const uid = context.auth.uid;

  await db.collection('fcm_tokens').doc(uid).set(
    {
      tokens: {
        [deviceId]: admin.firestore.FieldValue.delete(),
      },
      platform: {
        [deviceId]: admin.firestore.FieldValue.delete(),
      },
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true }
  );

  await db.collection('users').doc(uid).set(
    {
      fcmTokens: admin.firestore.FieldValue.arrayRemove(token),
    },
    { merge: true }
  );

  return { ok: true };
});
