import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingProgressSyncService {
  Future<void> syncLastRead({
    required int surahNumber,
    required int ayahNumber,
    required int pageNumber,
    required int juzNumber,
    required String deviceId,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('reading_progress')
        .doc('latest');

    await doc.set({
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'pageNumber': pageNumber,
      'juzNumber': juzNumber,
      'lastReadAt': FieldValue.serverTimestamp(),
      'deviceId': deviceId,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> fetchLastRead() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reading_progress')
        .doc('latest')
        .get();

    return snapshot.data();
  }
}
