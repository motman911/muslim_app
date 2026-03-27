const functions = require('firebase-functions');
const { db } = require('../config');
const { sendNotification } = require('../utils/sendFCM');

exports.onAchievementEarned = functions.firestore
  .document('users/{userId}/achievements/{achievementId}')
  .onCreate(async (snap, context) => {
    const { userId } = context.params;
    const achievement = snap.data();

    const friendsSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('friends')
      .limit(200)
      .get();

    if (friendsSnapshot.empty) {
      return null;
    }

    const friendIds = friendsSnapshot.docs.map((doc) => doc.id);
    const tokenDocs = await Promise.all(
      friendIds.map((friendId) => db.collection('fcm_tokens').doc(friendId).get())
    );

    const tokens = tokenDocs.flatMap((doc) => Object.values(doc.data()?.tokens || {}));

    if (tokens.length === 0) {
      return null;
    }

    await sendNotification(tokens, {
      notification: {
        title: 'New achievement',
        body: `A friend earned ${achievement.badge || 'a badge'}`,
      },
      data: {
        type: 'achievement',
        userId,
        challengeId: achievement.challengeId || '',
      },
    });

    return null;
  });
