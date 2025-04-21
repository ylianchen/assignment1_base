// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:tweeter/models/tweet.dart';
import 'package:tweeter/services/firebase_service.dart';
import 'package:tweeter/widgets/tweet_list.dart';
import 'package:tweeter/pages/create_tweet_page.dart';

// 将HomePage改为StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// 创建HomePage的State类
class _HomePageState extends State<HomePage> {
  final FirebaseService firebaseService = FirebaseService();

  // 添加刷新方法
  void _refreshTweets() {
    setState(() {
      // 仅调用setState来刷新UI
      // StreamBuilder会自动重新获取数据
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweeter'),
        // 在AppBar中添加刷新按钮
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTweets,
            tooltip: 'Refresh tweets',
          ),
        ],
      ),
      body: StreamBuilder<List<Tweet>>(
        stream: firebaseService.getTweetsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tweets found'));
          }

          return TweetList(tweets: snapshot.data!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateTweetPage())
          ).then((_) {
            // 当从CreateTweetPage返回时刷新列表
            _refreshTweets();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}