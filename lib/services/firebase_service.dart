// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tweeter/models/tweet.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'tweets';

  // Get a stream of tweets that updates in real-time
  Stream<List<Tweet>> getTweets() {
    return _firestore
        .collection(_collectionName)
        .orderBy('timestamp', descending: true) // Sort by newest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Tweet.fromFirestore(doc);
      }).toList();
    });
  }

  // Add a new tweet to the database
  Future<void> addTweet(Tweet tweet) async {
    try {
      await _firestore.collection(_collectionName).add({
        'title': tweet.title,
        'text': tweet.text,
        'username': tweet.username,
        'timestamp': FieldValue.serverTimestamp(), // Use server timestamp
      });
      print('Tweet successfully added to Firebase!');
    } catch (e) {
      print('Error adding tweet: $e');
      throw e;
    }
  }
}