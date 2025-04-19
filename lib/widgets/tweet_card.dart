import 'package:flutter/material.dart';
import 'package:tweeter/models/tweet.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;

  const TweetCard({super.key, required this.tweet});

  // Format timestamp to a readable string
  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      elevation: 1, // Erhöhter Schatteneffekt
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Stärker abgerundete Ecken
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.white54], // Farbverlauf
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
                      //color: Colors.blueGrey.shade800,
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
