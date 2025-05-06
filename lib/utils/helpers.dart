import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 格式化时间
String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
  return DateFormat(format).format(date);
}

// 格式化日期和时间
String formatDateTime(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

// 获取今天的日期字符串
String getTodayDateString() {
  return formatDate(DateTime.now());
}

// 获取星期几
String getWeekday(DateTime date) {
  List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  return weekdays[date.weekday - 1];
}

// 生成随机颜色
Color getRandomColor(int seed) {
  List<Color> colors = [
    Colors.blue[300]!,
    Colors.green[300]!,
    Colors.purple[300]!,
    Colors.orange[300]!,
    Colors.pink[300]!,
    Colors.teal[300]!,
    Colors.indigo[300]!,
  ];
  return colors[seed % colors.length];
}

// 显示成功提示
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// 显示错误提示
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// 格式化时间（分钟:秒）
String formatDuration(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}

// 获取心情图标
IconData getMoodIcon(String mood) {
  Map<String, IconData> moodIcons = {
    '平静': Icons.spa,
    '快乐': Icons.sentiment_very_satisfied,
    '焦虑': Icons.sentiment_very_dissatisfied,
    '悲伤': Icons.sentiment_dissatisfied,
    '愤怒': Icons.mood_bad,
    '疲惫': Icons.bedtime,
    '充满希望': Icons.wb_sunny,
    '满足': Icons.favorite,
    '沮丧': Icons.sentiment_neutral,
    '压力大': Icons.psychology,
  };
  
  return moodIcons[mood] ?? Icons.mood;
}

// 获取心情颜色
Color getMoodColor(String mood) {
  Map<String, Color> moodColors = {
    '平静': Colors.blue[300]!,
    '快乐': Colors.yellow[600]!,
    '焦虑': Colors.orange[400]!,
    '悲伤': Colors.indigo[300]!,
    '愤怒': Colors.red[400]!,
    '疲惫': Colors.grey[500]!,
    '充满希望': Colors.amber[400]!,
    '满足': Colors.pink[300]!,
    '沮丧': Colors.purple[300]!,
    '压力大': Colors.teal[400]!,
  };
  
  return moodColors[mood] ?? Colors.grey;
} 