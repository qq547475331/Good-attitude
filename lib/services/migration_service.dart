import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/growth_goal.dart';
import 'database_service.dart';

/// 负责数据迁移的服务
class MigrationService {
  static final MigrationService _instance = MigrationService._internal();
  static MigrationService get instance => _instance;
  
  final DatabaseService _db = DatabaseService.instance;
  final Uuid _uuid = const Uuid();
  
  MigrationService._internal();
  
  /// 执行数据迁移操作
  Future<void> migrateData() async {
    // 获取SharedPreferences实例
    final prefs = await SharedPreferences.getInstance();
    
    // 检查是否已经迁移
    final bool hasMigrated = prefs.getBool('data_migrated_to_sqlite') ?? false;
    if (hasMigrated) {
      print('数据已经迁移到SQLite，跳过迁移过程');
      return;
    }
    
    print('开始数据迁移: SharedPreferences -> SQLite');
    
    // 迁移成长目标
    await _migrateGrowthGoals(prefs);
    
    // 迁移感恩记录
    await _migrateGratitudeEntries(prefs);
    
    // 迁移情绪记录
    await _migrateMoodRecords(prefs);
    
    // 迁移思想记录
    await _migrateThoughtRecords(prefs);
    
    // 标记迁移完成
    await prefs.setBool('data_migrated_to_sqlite', true);
    
    print('数据迁移完成！');
  }
  
  /// 迁移成长目标数据
  Future<void> _migrateGrowthGoals(SharedPreferences prefs) async {
    try {
      final String? goalsJson = prefs.getString('growth_goals');
      if (goalsJson == null || goalsJson.isEmpty) {
        print('没有找到成长目标数据');
        return;
      }
      
      final List<dynamic> goalsData = jsonDecode(goalsJson);
      
      for (var goalData in goalsData) {
        try {
          // 处理旧数据可能缺少ID的情况
          final String goalId = goalData['id'] ?? _uuid.v4();
          final List<dynamic> milestonesData = goalData['milestones'] ?? [];
          
          final List<GrowthMilestone> milestones = milestonesData.map((m) {
            return GrowthMilestone(
              id: m['id'] ?? _uuid.v4(),
              title: m['title'],
              isCompleted: m['isCompleted'] ?? false,
              completedDate: m['completedDate'] != null ? 
                  DateTime.parse(m['completedDate']) : null,
            );
          }).toList();
          
          final GrowthGoal goal = GrowthGoal(
            id: goalId,
            title: goalData['title'],
            description: goalData['description'] ?? '',
            createdDate: goalData['createdDate'] != null ? 
                DateTime.parse(goalData['createdDate']) : DateTime.now(),
            targetDate: goalData['targetDate'] != null ? 
                DateTime.parse(goalData['targetDate']) : null,
            milestones: milestones,
            isCompleted: goalData['isCompleted'] ?? false,
          );
          
          await _db.saveGrowthGoal(goal);
        } catch (e) {
          print('迁移单个成长目标时出错: $e');
        }
      }
      
      print('成功迁移${goalsData.length}个成长目标');
    } catch (e) {
      print('迁移成长目标数据时出错: $e');
    }
  }
  
  /// 迁移感恩记录数据
  Future<void> _migrateGratitudeEntries(SharedPreferences prefs) async {
    try {
      final String? entriesJson = prefs.getString('gratitude_entries');
      if (entriesJson == null || entriesJson.isEmpty) {
        print('没有找到感恩记录数据');
        return;
      }
      
      final List<dynamic> entriesData = jsonDecode(entriesJson);
      final List<Map<String, dynamic>> entries = [];
      
      for (var entryData in entriesData) {
        try {
          entries.add({
            'id': entryData['id'] ?? _uuid.v4(),
            'content': entryData['content'] ?? '',
            'date': entryData['date'] ?? DateTime.now().toIso8601String(),
            'category': entryData['category'] ?? '',
          });
        } catch (e) {
          print('处理单个感恩记录时出错: $e');
        }
      }
      
      if (entries.isNotEmpty) {
        await _db.saveGratitudeEntries(entries);
        print('成功迁移${entries.length}条感恩记录');
      }
    } catch (e) {
      print('迁移感恩记录数据时出错: $e');
    }
  }
  
  /// 迁移情绪记录数据
  Future<void> _migrateMoodRecords(SharedPreferences prefs) async {
    try {
      final String? recordsJson = prefs.getString('mood_records');
      if (recordsJson == null || recordsJson.isEmpty) {
        print('没有找到情绪记录数据');
        return;
      }
      
      final List<dynamic> recordsData = jsonDecode(recordsJson);
      final List<Map<String, dynamic>> records = [];
      
      for (var recordData in recordsData) {
        try {
          records.add({
            'id': recordData['id'] ?? _uuid.v4(),
            'moodType': recordData['moodType'] ?? 'neutral',
            'intensity': recordData['intensity'] ?? 3,
            'note': recordData['note'] ?? '',
            'date': recordData['date'] ?? DateTime.now().toIso8601String(),
          });
        } catch (e) {
          print('处理单个情绪记录时出错: $e');
        }
      }
      
      if (records.isNotEmpty) {
        await _db.saveMoodRecords(records);
        print('成功迁移${records.length}条情绪记录');
      }
    } catch (e) {
      print('迁移情绪记录数据时出错: $e');
    }
  }
  
  /// 迁移思想记录数据
  Future<void> _migrateThoughtRecords(SharedPreferences prefs) async {
    try {
      final String? recordsJson = prefs.getString('thought_records');
      if (recordsJson == null || recordsJson.isEmpty) {
        print('没有找到思想记录数据');
        return;
      }
      
      final List<dynamic> recordsData = jsonDecode(recordsJson);
      final List<Map<String, dynamic>> records = [];
      
      for (var recordData in recordsData) {
        try {
          records.add({
            'id': recordData['id'] ?? _uuid.v4(),
            'situation': recordData['situation'] ?? '',
            'thought': recordData['thought'] ?? '',
            'emotion': recordData['emotion'] ?? '',
            'alternativeThought': recordData['alternativeThought'] ?? '',
            'date': recordData['date'] ?? DateTime.now().toIso8601String(),
          });
        } catch (e) {
          print('处理单个思想记录时出错: $e');
        }
      }
      
      if (records.isNotEmpty) {
        await _db.saveThoughtRecords(records);
        print('成功迁移${records.length}条思想记录');
      }
    } catch (e) {
      print('迁移思想记录数据时出错: $e');
    }
  }
} 