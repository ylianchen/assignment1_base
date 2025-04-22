import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tweeter/models/tweet.dart';

class DatabaseService {
  // Singleton pattern for database service
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Reference to the tweets collection
  final CollectionReference tweetsCollection =
  FirebaseFirestore.instance.collection('tweets');

  // Get all tweets as a stream
  Stream<QuerySnapshot> get tweets {
    return tweetsCollection.orderBy('timestamp', descending: true).snapshots();
  }

  // Add a new tweet to the database
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