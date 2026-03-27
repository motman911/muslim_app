import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkSyncService {
  Future<void> addBookmark({
    required String type,
    required int surahNumber,
    required int ayahNumber,
    String? note,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final docId = '${type}_${surahNumber}_$ayahNumber';
    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(docId);

    await doc.set({
      'type': type,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> fetchBookmarks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
