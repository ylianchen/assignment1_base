import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tweeter/models/tweet.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'tweets';

  // Get tweets as a stream
  Stream<List<Tweet>> getTweetsStream() {
    return _firestore
        .collection(collectionName)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Convert Firestore Timestamp to String
        String timestamp;
        if (data['timestamp'] != null) {
          if (data['timestamp'] is Timestamp) {
            timestamp = (data['timestamp'] as Timestamp).toDate().toIso8601String();
          } else if (data['timestamp'] is String) {
            timestamp = data['timestamp'];
          } else {
            timestamp = DateTime.now().toIso8601String();
          }
        } else {
          timestamp = DateTime.now().toIso8601String();
        }

        return Tweet(
          id: doc.id,
          title: data['title'] ?? '',
          text: data['text'] ?? '',
          username: data['username'] ?? '',
          timestamp: timestamp,
        );
      }).toList();
    });
  }

  // Add a new tweet to Firebase
  Future<void> addTweet(Tweet tweet) async {
    try {
      await _firestore.collection(collectionName).add({
        'title': tweet.title,
        'text': tweet.text,
        'username': tweet.username,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding tweet: $e');
      rethrow;
    }
  }
}