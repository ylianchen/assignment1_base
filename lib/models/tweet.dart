// lib/models/tweet.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String? id;
  final String title;
  final String text;
  final String username;
  final String timestamp;

  Tweet({
    this.id,
    required this.title,
    required this.text,
    required this.username,
    String? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now().toIso8601String();

  // Factory method to create a Tweet from a Firestore document
  factory Tweet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final dynamic timestampData = data['timestamp'];
    String formattedTimestamp;

    // Handle different timestamp formats from Firestore
    if (timestampData is Timestamp) {
      // Convert Firestore Timestamp to DateTime and then to string
      formattedTimestamp = timestampData.toDate().toIso8601String();
      print('Converted Timestamp for tweet: ${data['title']}');
    } else if (timestampData is String) {
      // If it's already a string, use it directly
      formattedTimestamp = timestampData;
      print('Used String timestamp for tweet: ${data['title']}');
    } else {
      // Fallback for null or other unexpected formats
      formattedTimestamp = DateTime.now().toIso8601String();
      print('Used fallback timestamp for tweet: ${data['title']}');
    }

    print('Timestamp after conversion: $formattedTimestamp for ${data['title']}');

    return Tweet(
      id: doc.id,
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      username: data['username'] ?? '',
      timestamp: formattedTimestamp,
    );
  }
}