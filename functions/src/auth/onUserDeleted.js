const functions = require('firebase-functions');
const { db } = require('../config');

async function deleteSubcollection(parentRef, subcollection) {
  const snapshot = await parentRef.collection(subcollection).get();
  if (snapshot.empty) {
    return;
  }

  const batch = db.batch();
  snapshot.docs.forEach((doc) => batch.delete(doc.ref));
  await batch.commit();
}

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  const userRef = db.collection('users').doc(user.uid);

  const subcollections = [
    'reading_progress',
    'bookmarks',
    'favorites',
    'listening_history',
    'memorization',
    'achievements',
  ];

  for (const name of subcollections) {
    await deleteSubcollection(userRef, name);
  }

  await Promise.all([
    userRef.delete().catch(() => null),
    db.collection('fcm_tokens').doc(user.uid).delete().catch(() => null),
  ]);
});
