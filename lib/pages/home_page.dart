import 'package:flutter/material.dart';
import 'package:tweeter/widgets/tweet_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tweeter/models/tweet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Convert Firestore documents to Tweet objects
  List<Tweet> _convertFirestoreToTweets(QuerySnapshot snapshot) {
    final tweets = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final tweet = Tweet.fromFirestore(data, doc.id);
      // Debug tweet conversion
      print('Converting tweet: ${tweet.title}');
      return tweet;
    }).toList();

    // Get raw document data for debugging
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      String? title = data['title']?.toString();
      if (title == 'test107' || (title != null && title.contains('test'))) {
        print('RAW DATA for test tweet: $data');
      }
    }

    // Manual sorting method for tweets - directly compare timestamp fields from Firestore
    tweets.sort((a, b) {
      try {
        // Attempt to convert timestamps to DateTime objects for comparison
        DateTime dateA;
        DateTime dateB;

        try {
          dateA = DateTime.parse(a.timestamp);
        } catch (e) {
          // Fallback for non-standard formats
          dateA = DateTime.now().subtract(const Duration(days: 1));
          print('Failed to parse timestamp for ${a.title}: ${a.timestamp}');
        }

        try {
          dateB = DateTime.parse(b.timestamp);
        } catch (e) {
          // Fallback for non-standard formats
          dateB = DateTime.now().subtract(const Duration(days: 1));
          print('Failed to parse timestamp for ${b.title}: ${b.timestamp}');
        }

        // Compare the DateTime objects
        return dateB.compareTo(dateA);
      } catch (e) {
        print('Error during tweet sorting: $e');
        return 0;
      }
    });

    // Print the top 5 tweets after sorting to verify order
    print('Top 5 tweets after sorting:');
    for (var i = 0; i < (tweets.length > 5 ? 5 : tweets.length); i++) {
      print('${i+1}. Title: ${tweets[i].title}, Timestamp: ${tweets[i].timestamp}');
    }

    print('Total tweets after conversion and sorting: ${tweets.length}');
    return tweets;
  }

  void _showAddTweetDialog(BuildContext context) {
    final titleController = TextEditingController();
    final textController = TextEditingController();
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Tweet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter tweet title',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Tweet',
                hintText: 'What\'s happening?',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: '@username',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  textController.text.isNotEmpty &&
                  usernameController.text.isNotEmpty) {
                try {
                  // Create new tweet
                  final tweet = Tweet(
                    title: titleController.text.trim(),
                    text: textController.text.trim(),
                    username: usernameController.text.trim(),
                  );

                  // Add to Firestore
                  print('Adding tweet with title: ${tweet.title}');
                  await FirebaseFirestore.instance.collection('tweets').add(tweet.toMap());
                  print('Tweet successfully added to Firebase!');

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tweet posted successfully!')),
                    );
                  }
                } catch (e) {
                  print('Error posting tweet: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweeter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTweetDialog(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tweets')
        // Don't use orderBy here - we'll sort manually after retrieving
            .snapshots(),
        builder: (context, snapshot) {
          // Show connection status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading tweets...'),
                ],
              ),
            );
          }

          // Show any errors
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Try to reconnect to Firebase
                      Firebase.initializeApp();
                    },
                    child: const Text('Retry Connection'),
                  ),
                ],
              ),
            );
          }

          // Show data if connected
          if (snapshot.hasData) {
            final tweets = _convertFirestoreToTweets(snapshot.data!);

            // Debug individual tweets - helpful for finding your test107 tweet
            for (var tweet in tweets) {
              if (tweet.title == 'test107') {
                print('Found test107 in final list! Timestamp: ${tweet.timestamp}');
              }
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green.shade100,
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Connected to Firebase (${tweets.length} tweets)',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: tweets.isEmpty
                      ? const Center(child: Text('No tweets yet. Be the first to tweet!'))
                      : TweetList(tweets: tweets),
                ),
              ],
            );
          }

          // Fallback
          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }
}