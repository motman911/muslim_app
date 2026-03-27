const functions = require('firebase-functions');
const { admin, db } = require('../config');
const { sendNotification } = require('../utils/sendFCM');

exports.sendInactivityReminder = functions.pubsub
  .schedule('every 24 hours')
  .timeZone('Etc/UTC')
  .onRun(async () => {
    const threeDaysAgo = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 3 * 24 * 60 * 60 * 1000)
    );

    const usersSnapshot = await db
      .collection('users')
      .where('lastSeen', '<=', threeDaysAgo)
      .where('settings.notificationsEnabled', '==', true)
      .limit(500)
      .get();

    if (usersSnapshot.empty) {
      return null;
    }

    for (const userDoc of usersSnapshot.docs) {
      const tokenDoc = await db.collection('fcm_tokens').doc(userDoc.id).get();
      const tokens = Object.values(tokenDoc.data()?.tokens || {});

      await sendNotification(tokens, {
        notification: {
          title: 'We miss you in Noor',
          body: 'Come back and continue your journey.',
        },
        data: {
          type: 'inactivity_reminder',
        },
      });
    }

    return null;
  });
