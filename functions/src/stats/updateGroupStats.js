const functions = require('firebase-functions');
const { db } = require('../config');

async function refreshMemberCount(groupId) {
  const membersSnapshot = await db.collection('groups').doc(groupId).collection('members').get();
  await db.collection('groups').doc(groupId).set(
    {
      membersCount: membersSnapshot.size,
      updatedAt: new Date(),
    },
    { merge: true }
  );
}

exports.onGroupMemberWrite = functions.firestore
  .document('groups/{groupId}/members/{userId}')
  .onWrite(async (_, context) => {
    await refreshMemberCount(context.params.groupId);
    return null;
  });
