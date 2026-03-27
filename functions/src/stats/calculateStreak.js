const functions = require('firebase-functions');
const { admin, db } = require('../config');

exports.calculateStreak = functions.pubsub
  .schedule('0 1 * * *')
  .timeZone('Etc/UTC')
  .onRun(async () => {
    const yesterday = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 24 * 60 * 60 * 1000)
    );

    const usersSnapshot = await db.collection('users').limit(1000).get();

    const updates = usersSnapshot.docs.map(async (doc) => {
      const data = doc.data();
      const isActive = data.lastSeen && data.lastSeen.toMillis() >= yesterday.toMillis();

      const currentStreak = isActive ? (data.stats?.currentStreak || 0) + 1 : 0;
      const longestStreak = Math.max(currentStreak, data.stats?.longestStreak || 0);

      await doc.ref.set(
        {
          stats: {
            ...(data.stats || {}),
            currentStreak,
            longestStreak,
          },
        },
        { merge: true }
      );
    });

    await Promise.all(updates);
    return null;
  });
