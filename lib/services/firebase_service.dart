import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tweeter/models/tweet.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 获取tweets的流，以便实时更新
  Stream<List<Tweet>> getTweetsStream() {
    return _firestore
        .collection('tweets')
        .orderBy('timestamp', descending: true) // 按时间降序排列
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Tweet.fromMap(doc.id, data);
      }).toList();
    });
  }

  // 添加新tweet到Firebase
  Future<void> addTweet(Tweet tweet) async {
    await _firestore.collection('tweets').add({
      'title': tweet.title,
      'text': tweet.text,
      'username': tweet.username,
      'timestamp': tweet.timestamp,
    });
  }
}