class Tweet {
  final String? id;
  final String title;
  final String text;
  final String username;
  final String timestamp;

  Tweet({
    this.id,
    required this.title,
    required this.text,
    required this.username,
  }) : this.timestamp = DateTime.now().toIso8601String();
}
