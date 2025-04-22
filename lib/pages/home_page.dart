
import 'package:flutter/material.dart';
import 'package:tweeter/models/tweet.dart';
import 'package:tweeter/services/firebase_service.dart';
import 'package:tweeter/widgets/tweet_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweeter'),
      ),
      body: StreamBuilder<List<Tweet>>(
        stream: _firebaseService.getTweets(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }


          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading tweets: ${snapshot.error}'),
            );
          }

          // Handle empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tweets found'));
          }

          // Display tweets
          return TweetList(tweets: snapshot.data!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTweetDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTweetDialog(BuildContext context) {
    final titleController = TextEditingController();
    final textController = TextEditingController();
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Tweet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Text',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    textController.text.isNotEmpty &&
                    usernameController.text.isNotEmpty) {
                  try {
                    final tweet = Tweet(
                      title: titleController.text,
                      text: textController.text,
                      username: usernameController.text,
                    );

                    await _firebaseService.addTweet(tweet);

                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tweet posted successfully!')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error posting tweet: $e')),
                    );
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
        );
      },
    );
  }
}