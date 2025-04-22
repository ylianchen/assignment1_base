// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:tweeter/models/tweet.dart';
import 'package:tweeter/services/firebase_service.dart';
import 'package:tweeter/widgets/tweet_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("HomePage initialized");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Show the tweet creation dialog
  void _showTweetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create a Tweet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Text',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTweet();
              Navigator.pop(context);
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  // Add a new tweet to Firebase
  void _addTweet() async {
    if (_titleController.text.isNotEmpty &&
        _textController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {

      final tweet = Tweet(
        title: _titleController.text,
        text: _textController.text,
        username: _usernameController.text,
      );

      print('Adding tweet with title: ${tweet.title}');

      try {
        await _firebaseService.addTweet(tweet);
        // Clear input fields
        _titleController.clear();
        _textController.clear();
        // Leave username as is for convenience
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting tweet: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweeter'),
      ),
      body: StreamBuilder<List<Tweet>>(
        stream: _firebaseService.getTweets(),
        builder: (context, snapshot) {
          print("StreamBuilder state: ${snapshot.connectionState}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("StreamBuilder error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("StreamBuilder: No data");
            return Center(child: Text('No tweets yet!'));
          }

          // Success! We have tweets, so display them
          final tweets = snapshot.data!;
          print("StreamBuilder: Received ${tweets.length} tweets");
          return TweetList(tweets: tweets);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTweetDialog,
        child: Icon(Icons.add),
        tooltip: 'Create Tweet',
      ),
    );
  }
}