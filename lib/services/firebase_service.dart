// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tweeter/models/tweet.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'tweets';

  // Get a stream of tweets that updates in real-time
  Stream<List<Tweet>> getTweets() {
    print("Setting up tweets stream...");
    return _firestore
        .collection(_collectionName)
        .orderBy('timestamp', descending: true) // Sort by newest first
        .snapshots()
        .map((snapshot) {
      print("Got snapshot with ${snapshot.docs.length} documents");
      final tweets = snapshot.docs.map((doc) {
        print("Converting doc ${doc.id}");
        return Tweet.fromFirestore(doc);
      }).toList();

      print("Top 5 tweets after sorting:");
      for (var i = 0; i < (tweets.length > 5 ? 5 : tweets.length); i++) {
        print("${i + 1}. Title: ${tweets[i].title}, Timestamp: ${tweets[i].timestamp}");
      }
      print("Total tweets after conversion and sorting: ${tweets.length}");

      // Just for debugging
      final test = tweets.where((t) => t.title == 'test117').toList();
      if (test.isNotEmpty) {
        print("Found test117 in final list! Timestamp: ${test.first.timestamp}");
      }

      return tweets;
    });
  }

  // Add a new tweet to the database
  Future<void> addTweet(Tweet tweet) async {
    try {
      print("Adding tweet: $tweet");

      // Use server timestamp to ensure consistent sorting
      await _firestore.collection(_collectionName).add({
        'title': tweet.title,
        'text': tweet.text,
        'username': tweet.username,
        'timestamp': FieldValue.serverTimestamp(), // Important for sorting!
      });

      print('Tweet successfully added to Firebase!');
    } catch (e) {
      print('Error adding tweet: $e');
      throw e;
    }
  }
}