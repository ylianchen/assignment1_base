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

  // Create a Tweet from Firestore data
  factory Tweet.fromFirestore(Map<String, dynamic> data, String docId) {
    // Handle both String and Timestamp types for timestamp
    String timestampStr;

    if (data['timestamp'] is Timestamp) {
      // Convert Firestore Timestamp to ISO string
      timestampStr = (data['timestamp'] as Timestamp).toDate().toIso8601String();
      print('Converted Timestamp for tweet: ${data['title']}');
    } else if (data['timestamp'] is String) {
      // Use the string directly
      timestampStr = data['timestamp'];
      print('Used String timestamp for tweet: ${data['title']}');
    } else {
      // Fallback to current time
      timestampStr = DateTime.now().toIso8601String();
      print('Used fallback timestamp for tweet: ${data['title']}');
    }

    print('Timestamp after conversion: $timestampStr for ${data['title']}');

    return Tweet(
      id: docId,
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      username: data['username'] ?? '',
      timestamp: timestampStr,
    );
  }

  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'text': text,
      'username': username,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}