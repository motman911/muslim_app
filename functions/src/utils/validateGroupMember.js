const { db } = require('../config');

async function validateGroupMember({ groupId, userId }) {
  const memberDoc = await db
    .collection('groups')
    .doc(groupId)
    .collection('members')
    .doc(userId)
    .get();

  return memberDoc.exists;
}

module.exports = {
  validateGroupMember,
};
