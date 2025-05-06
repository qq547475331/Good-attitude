class GrowthGoal {
  final String id;
  final String title;
  final String description;
  final DateTime createdDate;
  final DateTime? targetDate;
  final List<GrowthMilestone> milestones;
  final bool isCompleted;
  
  GrowthGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    this.targetDate,
    required this.milestones,
    this.isCompleted = false,
  });
  
  // 从JSON创建实例
  factory GrowthGoal.fromJson(Map<String, dynamic> json) {
    var milestonesList = (json['milestones'] as List)
        .map((milestone) => GrowthMilestone.fromJson(milestone))
        .toList();
    
    return GrowthGoal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdDate: DateTime.parse(json['createdDate']),
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
      milestones: milestonesList,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
  
  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'milestones': milestones.map((milestone) => milestone.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }
  
  // 创建带有新属性的副本
  GrowthGoal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdDate,
    DateTime? targetDate,
    List<GrowthMilestone>? milestones,
    bool? isCompleted,
  }) {
    return GrowthGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      targetDate: targetDate ?? this.targetDate,
      milestones: milestones ?? this.milestones,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  
  // 计算完成的里程碑百分比
  double get progressPercentage {
    if (milestones.isEmpty) return 0.0;
    int completedCount = milestones.where((m) => m.isCompleted).length;
    return completedCount / milestones.length;
  }
}

class GrowthMilestone {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? completedDate;
  
  GrowthMilestone({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.completedDate,
  });
  
  // 从JSON创建实例
  factory GrowthMilestone.fromJson(Map<String, dynamic> json) {
    return GrowthMilestone(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate']) 
          : null,
    );
  }
  
  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
    };
  }
  
  // 创建带有新属性的副本
  GrowthMilestone copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return GrowthMilestone(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
} 