import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/growth_goal.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;
  
  DatabaseService._internal();
  
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  // 数据库初始化
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'good_mindset.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }
  
  // 创建数据库表
  Future<void> _createDatabase(Database db, int version) async {
    // 成长目标表
    await db.execute('''
      CREATE TABLE growth_goals(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        created_date TEXT NOT NULL,
        target_date TEXT,
        is_completed INTEGER NOT NULL
      )
    ''');
    
    // 里程碑表
    await db.execute('''
      CREATE TABLE growth_milestones(
        id TEXT PRIMARY KEY,
        goal_id TEXT NOT NULL,
        title TEXT NOT NULL,
        is_completed INTEGER NOT NULL,
        completed_date TEXT,
        FOREIGN KEY (goal_id) REFERENCES growth_goals (id) ON DELETE CASCADE
      )
    ''');
    
    // 情绪记录表
    await db.execute('''
      CREATE TABLE mood_records(
        id TEXT PRIMARY KEY,
        mood_type TEXT NOT NULL,
        intensity INTEGER NOT NULL,
        note TEXT,
        date TEXT NOT NULL
      )
    ''');
    
    // 感恩记录表
    await db.execute('''
      CREATE TABLE gratitude_entries(
        id TEXT PRIMARY KEY,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        category TEXT
      )
    ''');
    
    // 思想记录表
    await db.execute('''
      CREATE TABLE thought_records(
        id TEXT PRIMARY KEY,
        situation TEXT NOT NULL,
        thought TEXT NOT NULL,
        emotion TEXT NOT NULL,
        alternative_thought TEXT,
        date TEXT NOT NULL
      )
    ''');
  }
  
  // =========== 成长目标相关方法 ===========
  
  // 保存成长目标
  Future<void> saveGrowthGoal(GrowthGoal goal) async {
    final db = await database;
    await db.transaction((txn) async {
      // 保存目标
      await txn.insert(
        'growth_goals',
        {
          'id': goal.id,
          'title': goal.title,
          'description': goal.description,
          'created_date': goal.createdDate.toIso8601String(),
          'target_date': goal.targetDate?.toIso8601String(),
          'is_completed': goal.isCompleted ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      // 保存里程碑
      for (var milestone in goal.milestones) {
        await txn.insert(
          'growth_milestones',
          {
            'id': milestone.id,
            'goal_id': goal.id,
            'title': milestone.title,
            'is_completed': milestone.isCompleted ? 1 : 0,
            'completed_date': milestone.completedDate?.toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
  
  // 获取所有成长目标
  Future<List<GrowthGoal>> getGrowthGoals() async {
    final db = await database;
    
    // 获取所有目标
    final goalMaps = await db.query('growth_goals');
    
    // 映射为GrowthGoal对象
    return Future.wait(goalMaps.map((goalMap) async {
      final goalId = goalMap['id'] as String;
      
      // 获取该目标的所有里程碑
      final milestoneMaps = await db.query(
        'growth_milestones',
        where: 'goal_id = ?',
        whereArgs: [goalId],
      );
      
      final milestones = milestoneMaps.map((m) => GrowthMilestone(
        id: m['id'] as String,
        title: m['title'] as String,
        isCompleted: (m['is_completed'] as int) == 1,
        completedDate: m['completed_date'] != null 
            ? DateTime.parse(m['completed_date'] as String)
            : null,
      )).toList();
      
      return GrowthGoal(
        id: goalId,
        title: goalMap['title'] as String,
        description: goalMap['description'] as String? ?? '',
        createdDate: DateTime.parse(goalMap['created_date'] as String),
        targetDate: goalMap['target_date'] != null 
            ? DateTime.parse(goalMap['target_date'] as String)
            : null,
        milestones: milestones,
        isCompleted: (goalMap['is_completed'] as int) == 1,
      );
    }).toList());
  }
  
  // 删除成长目标
  Future<void> deleteGrowthGoal(String goalId) async {
    final db = await database;
    await db.transaction((txn) async {
      // 删除目标同时会级联删除里程碑
      await txn.delete(
        'growth_goals',
        where: 'id = ?',
        whereArgs: [goalId],
      );
    });
  }
  
  // 更新成长目标
  Future<void> updateGrowthGoal(GrowthGoal goal) async {
    await saveGrowthGoal(goal);
  }
  
  // =========== 感恩记录相关方法 ===========
  
  // 保存感恩记录
  Future<void> saveGratitudeEntries(List<Map<String, dynamic>> entries) async {
    final db = await database;
    await db.transaction((txn) async {
      // 清空旧记录（简化实现，实际可以考虑增量更新）
      await txn.delete('gratitude_entries');
      
      // 批量插入新记录
      for (var entry in entries) {
        await txn.insert(
          'gratitude_entries',
          {
            'id': entry['id'],
            'content': entry['content'],
            'date': entry['date'],
            'category': entry['category'],
          },
        );
      }
    });
  }
  
  // 获取所有感恩记录
  Future<List<Map<String, dynamic>>> getGratitudeEntries() async {
    final db = await database;
    final entries = await db.query('gratitude_entries');
    return entries;
  }
  
  // =========== 情绪记录相关方法 ===========
  
  // 保存情绪记录
  Future<void> saveMoodRecords(List<Map<String, dynamic>> records) async {
    final db = await database;
    await db.transaction((txn) async {
      // 清空旧记录
      await txn.delete('mood_records');
      
      // 批量插入新记录
      for (var record in records) {
        await txn.insert(
          'mood_records',
          {
            'id': record['id'],
            'mood_type': record['moodType'],
            'intensity': record['intensity'],
            'note': record['note'],
            'date': record['date'],
          },
        );
      }
    });
  }
  
  // 获取所有情绪记录
  Future<List<Map<String, dynamic>>> getMoodRecords() async {
    final db = await database;
    final records = await db.query('mood_records');
    return records.map((record) => {
      'id': record['id'],
      'moodType': record['mood_type'],
      'intensity': record['intensity'],
      'note': record['note'],
      'date': record['date'],
    }).toList();
  }
  
  // =========== 思想记录相关方法 ===========
  
  // 保存思想记录
  Future<void> saveThoughtRecords(List<Map<String, dynamic>> records) async {
    final db = await database;
    await db.transaction((txn) async {
      // 清空旧记录
      await txn.delete('thought_records');
      
      // 批量插入新记录
      for (var record in records) {
        await txn.insert(
          'thought_records',
          {
            'id': record['id'],
            'situation': record['situation'],
            'thought': record['thought'],
            'emotion': record['emotion'],
            'alternative_thought': record['alternativeThought'],
            'date': record['date'],
          },
        );
      }
    });
  }
  
  // 获取所有思想记录
  Future<List<Map<String, dynamic>>> getThoughtRecords() async {
    final db = await database;
    final records = await db.query('thought_records');
    return records.map((record) => {
      'id': record['id'],
      'situation': record['situation'],
      'thought': record['thought'],
      'emotion': record['emotion'],
      'alternativeThought': record['alternative_thought'],
      'date': record['date'],
    }).toList();
  }
} 