class GratitudeEntry {
  final String id;
  final String content;
  final DateTime date;
  final String category;
  
  GratitudeEntry({
    required this.id,
    required this.content,
    required this.date,
    this.category = '一般',
  });
  
  // 从JSON创建实例
  factory GratitudeEntry.fromJson(Map<String, dynamic> json) {
    return GratitudeEntry(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      category: json['category'] ?? '一般',
    );
  }
  
  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
  
  // 创建带有新属性的副本
  GratitudeEntry copyWith({
    String? id,
    String? content,
    DateTime? date,
    String? category,
  }) {
    return GratitudeEntry(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
} 