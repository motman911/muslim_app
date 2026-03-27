const functions = require('firebase-functions');
const { db } = require('../config');
const { sendNotification } = require('../utils/sendFCM');

exports.onNewMessage = functions.firestore
  .document('groups/{groupId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const { groupId } = context.params;
    const message = snap.data();

    const groupSnap = await db.collection('groups').doc(groupId).get();
    if (!groupSnap.exists) {
      return null;
    }

    const group = groupSnap.data();
    const memberIds = (group.members || []).filter((uid) => uid !== message.senderId);

    if (memberIds.length === 0) {
      return null;
    }

    const tokenDocs = await Promise.all(
      memberIds.map((uid) => db.collection('fcm_tokens').doc(uid).get())
    );

    const tokens = tokenDocs.flatMap((doc) => Object.values(doc.data()?.tokens || {}));

    await sendNotification(tokens, {
      notification: {
        title: group.name,
        body: message.text || 'New message',
      },
      data: {
        type: 'group_message',
        groupId,
      },
    });

    return null;
  });
