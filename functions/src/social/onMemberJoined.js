const functions = require('firebase-functions');
const { admin, db } = require('../config');
const { sendNotification } = require('../utils/sendFCM');

exports.onMemberJoined = functions.firestore
  .document('groups/{groupId}/members/{userId}')
  .onCreate(async (snap, context) => {
    const { groupId, userId } = context.params;

    const [groupSnap, userSnap] = await Promise.all([
      db.collection('groups').doc(groupId).get(),
      db.collection('users').doc(userId).get(),
    ]);

    if (!groupSnap.exists) {
      return null;
    }

    const group = groupSnap.data();
    const user = userSnap.exists ? userSnap.data() : {};
    const displayName = user.displayName || 'A new member';

    const adminTokenDoc = await db.collection('fcm_tokens').doc(group.adminId).get();
    const tokens = Object.values(adminTokenDoc.data()?.tokens || {});

    if (tokens.length === 0) {
      return null;
    }

    await sendNotification(tokens, {
      notification: {
        title: 'New group member',
        body: `${displayName} joined ${group.name}`,
      },
      data: {
        type: 'group_join',
        groupId,
      },
    });

    await db.collection('groups').doc(groupId).update({
      members: admin.firestore.FieldValue.arrayUnion(userId),
    });

    return null;
  });
