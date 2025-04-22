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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _showAddTweetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Tweet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter tweet title',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'Text',
                    hintText: 'Enter tweet text',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _submitTweet,
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitTweet() async {
    if (_titleController.text.isEmpty ||
        _textController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final tweet = Tweet(
      title: _titleController.text,
      text: _textController.text,
      username: _usernameController.text,
    );

    try {
      await _firebaseService.addTweet(tweet);
      _titleController.clear();
      _textController.clear();
      _usernameController.clear();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tweet posted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting tweet: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweeter'),
      ),
      body: StreamBuilder<List<Tweet>>(
        stream: _firebaseService.getTweetsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tweets = snapshot.data ?? [];

          if (tweets.isEmpty) {
            return const Center(child: Text('No tweets yet. Be the first to post!'));
          }

          return TweetList(tweets: tweets);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTweetDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}