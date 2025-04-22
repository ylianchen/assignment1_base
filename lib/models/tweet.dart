

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
    String? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now().toIso8601String();

  factory Tweet.fromMap(String id, Map<String, dynamic> map) {
    // 处理timestamp字段，它可能是Timestamp类型
    String timestamp;
    final timestampData = map['timestamp'];

    if (timestampData is String) {
      timestamp = timestampData;
    } else if (timestampData != null) {
      // Firebase返回的Timestamp类型转换为DateTime再转为字符串
      try {
        final dateTime = (timestampData as dynamic).toDate();
        timestamp = dateTime.toIso8601String();
      } catch (e) {
        // 转换失败则使用当前时间
        timestamp = DateTime.now().toIso8601String();
      }
    } else {
      // 如果没有时间戳数据，使用当前时间
      timestamp = DateTime.now().toIso8601String();
    }

    return Tweet(
      id: id,
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      username: map['username'] ?? '',
      timestamp: timestamp,
    );
  }
}

