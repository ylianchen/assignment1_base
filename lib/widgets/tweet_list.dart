import 'package:flutter/material.dart';
import 'package:tweeter/models/tweet.dart';
import 'package:tweeter/widgets/tweet_card.dart';

class TweetList extends StatelessWidget {
  final List<Tweet> tweets;

  const TweetList({super.key, required this.tweets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tweets.length,
      itemBuilder: (_, index) {
        return TweetCard(tweet: tweets[index]);
      },
    );
  }
}
