
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tweeter/models/tweet.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  CollectionReference get tweetsCollection =>
      _firestore.collection('tweets');

  // Get stream of tweets
  Stream<List<Tweet>> getTweets() {
    try {
      return tweetsCollection
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            // Debug print
            print('Processing document: ${doc.id}');
            print('Document data: $data');


            String timestampStr;
            var timestamp = data['timestamp'];

            if (timestamp == null) {
              timestampStr = DateTime.now().toIso8601String();
              print('Timestamp is null, using current time');
            } else if (timestamp is Timestamp) {
              timestampStr = timestamp.toDate().toIso8601String();
              print('Converted Timestamp to: $timestampStr');
            } else if (timestamp is String) {
              timestampStr = timestamp;
              print('Using timestamp string: $timestampStr');
            } else {
              timestampStr = DateTime.now().toIso8601String();
              print('Unknown timestamp type: ${timestamp.runtimeType}, using current time');
            }

            return Tweet(
              id: doc.id,
              title: data['title'] ?? '',
              text: data['text'] ?? '',
              username: data['username'] ?? '',
              timestamp: timestampStr,
            );
          } catch (e) {
            print('Error converting document ${doc.id}: $e');
            // Return a placeholder tweet on error
            return Tweet(
              id: doc.id,
              title: 'Error loading tweet',
              text: 'Could not load tweet data',
              username: 'unknown',
            );
          }
        }).toList();
      });
    } catch (e) {
      print('Error in getTweets(): $e');
      return Stream.value([]);
    }
  }


  Future<void> addTweet(Tweet tweet) async {
    try {
      print('Adding tweet: ${tweet.title}');

      await tweetsCollection.add({
        'title': tweet.title,
        'text': tweet.text,
        'username': tweet.username,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Tweet added successfully');
    } catch (e) {
      print('Error adding tweet: $e');
      rethrow;
    }
  }
}