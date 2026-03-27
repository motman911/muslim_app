const functions = require('firebase-functions');
const { admin, db } = require('../config');

exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  const now = admin.firestore.FieldValue.serverTimestamp();

  await db.collection('users').doc(user.uid).set(
    {
      uid: user.uid,
      displayName: user.displayName || '',
      language: 'ar',
      createdAt: now,
      lastSeen: now,
      fcmTokens: [],
      settings: {
        theme: 'auto',
        fontSize: 18,
        quranFont: 'uthmani',
        reciterId: 'ar.alafasy',
        notificationsEnabled: true,
        prayerCalculationMethod: 'MWL',
      },
      stats: {
        totalPagesRead: 0,
        totalListeningMinutes: 0,
        currentStreak: 0,
        longestStreak: 0,
      },
    },
    { merge: true }
  );

  await db.collection('fcm_tokens').doc(user.uid).set(
    {
      tokens: {},
      platform: {},
      updatedAt: now,
    },
    { merge: true }
  );
});
