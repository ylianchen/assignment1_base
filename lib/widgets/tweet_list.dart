// lib/widgets/tweet_list.dart
import 'package:flutter/material.dart';
import 'package:tweeter/models/tweet.dart';
import 'package:tweeter/widgets/tweet_card.dart';

class TweetList extends StatelessWidget {
  final List<Tweet> tweets;

  const TweetList({Key? key, required this.tweets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tweets.length,
      itemBuilder: (context, index) {
        final tweet = tweets[index];
        print("Building tweet card for: ${tweet.title}");
        return TweetCard(tweet: tweet);
      },
    );
  }
}