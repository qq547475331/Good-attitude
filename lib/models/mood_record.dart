class MoodRecord {
  final String id;
  final String mood;
  final int intensity; // 1-5的强度
  final DateTime date;
  final String? note;
  
  MoodRecord({
    required this.id,
    required this.mood,
    required this.intensity,
    required this.date,
    this.note,
  });
  
  // 从JSON创建实例
  factory MoodRecord.fromJson(Map<String, dynamic> json) {
    return MoodRecord(
      id: json['id'],
      mood: json['mood'],
      intensity: json['intensity'],
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }
  
  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood': mood,
      'intensity': intensity,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
  
  // 创建带有新属性的副本
  MoodRecord copyWith({
    String? id,
    String? mood,
    int? intensity,
    DateTime? date,
    String? note,
  }) {
    return MoodRecord(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      intensity: intensity ?? this.intensity,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
} 