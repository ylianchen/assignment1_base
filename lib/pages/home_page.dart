import 'package:flutter/material.dart';
import 'package:tweeter/sample_data.dart';
import 'package:tweeter/widgets/tweet_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweeter'),
      ),
      body: TweetList(tweets: sampleEntries),
    );
  }
}
