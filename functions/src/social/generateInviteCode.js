const functions = require('firebase-functions');
const { db } = require('../config');
const { generateInviteCode } = require('../utils/inviteCode');

exports.generateInviteCode = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Authentication required');
  }

  const groupId = data?.groupId;
  if (!groupId || typeof groupId !== 'string') {
    throw new functions.https.HttpsError('invalid-argument', 'groupId is required');
  }

  const groupRef = db.collection('groups').doc(groupId);
  const groupSnap = await groupRef.get();

  if (!groupSnap.exists) {
    throw new functions.https.HttpsError('not-found', 'Group not found');
  }

  const group = groupSnap.data();
  if (group.adminId !== context.auth.uid) {
    throw new functions.https.HttpsError('permission-denied', 'Only admin can rotate invite code');
  }

  let inviteCode = generateInviteCode();
  let attempts = 0;

  while (attempts < 5) {
    const existing = await db
      .collection('groups')
      .where('inviteCode', '==', inviteCode)
      .limit(1)
      .get();

    if (existing.empty) {
      break;
    }

    inviteCode = generateInviteCode();
    attempts += 1;
  }

  await groupRef.update({ inviteCode });

  return { inviteCode };
});
