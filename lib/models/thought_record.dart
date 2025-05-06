class ThoughtRecord {
  final String id;
  final String situation;
  final String automaticThought;
  final List<String> thinkingTraps;
  final String evidence;
  final String alternativeThought;
  final DateTime date;
  
  ThoughtRecord({
    required this.id,
    required this.situation,
    required this.automaticThought,
    required this.thinkingTraps,
    required this.evidence,
    required this.alternativeThought,
    required this.date,
  });
  
  // 从JSON创建实例
  factory ThoughtRecord.fromJson(Map<String, dynamic> json) {
    return ThoughtRecord(
      id: json['id'],
      situation: json['situation'],
      automaticThought: json['automaticThought'],
      thinkingTraps: List<String>.from(json['thinkingTraps']),
      evidence: json['evidence'],
      alternativeThought: json['alternativeThought'],
      date: DateTime.parse(json['date']),
    );
  }
  
  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'situation': situation,
      'automaticThought': automaticThought,
      'thinkingTraps': thinkingTraps,
      'evidence': evidence,
      'alternativeThought': alternativeThought,
      'date': date.toIso8601String(),
    };
  }
  
  // 创建带有新属性的副本
  ThoughtRecord copyWith({
    String? id,
    String? situation,
    String? automaticThought,
    List<String>? thinkingTraps,
    String? evidence,
    String? alternativeThought,
    DateTime? date,
  }) {
    return ThoughtRecord(
      id: id ?? this.id,
      situation: situation ?? this.situation,
      automaticThought: automaticThought ?? this.automaticThought,
      thinkingTraps: thinkingTraps ?? this.thinkingTraps,
      evidence: evidence ?? this.evidence,
      alternativeThought: alternativeThought ?? this.alternativeThought,
      date: date ?? this.date,
    );
  }
} 