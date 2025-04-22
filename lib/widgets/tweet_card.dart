
import 'package:flutter/material.dart';
import 'package:tweeter/models/tweet.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;

  const TweetCard({super.key, required this.tweet});


  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error formatting timestamp: $e');
      return 'Unknown date';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building tweet card for: ${tweet.title}');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.white54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tweet.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                tweet.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4.0),
                  Text(
                    tweet.username,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '• ${_formatTimestamp(tweet.timestamp)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}