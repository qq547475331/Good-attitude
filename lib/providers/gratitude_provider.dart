import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/gratitude_entry.dart';
import '../services/database_service.dart';

class GratitudeProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;
  final Uuid _uuid = const Uuid();
  
  List<GratitudeEntry> _entries = [];
  bool _isLoading = true;
  
  GratitudeProvider() {
    _loadEntries();
  }
  
  // 获取所有感恩记录
  List<GratitudeEntry> get entries => _entries;
  
  // 获取加载状态
  bool get isLoading => _isLoading;
  
  // 获取今天的感恩记录
  List<GratitudeEntry> get todayEntries {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _entries.where((entry) {
      final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
      return entryDate.isAtSameMomentAs(today);
    }).toList();
  }
  
  // 按日期获取感恩记录
  List<GratitudeEntry> getEntriesByDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    
    return _entries.where((entry) {
      final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
      return entryDate.isAtSameMomentAs(targetDate);
    }).toList();
  }
  
  // 添加感恩记录
  Future<void> addEntry(String content, {String category = '一般'}) async {
    final newEntry = GratitudeEntry(
      id: _uuid.v4(),
      content: content,
      date: DateTime.now(),
      category: category,
    );
    
    _entries.add(newEntry);
    await _saveEntries();
    notifyListeners();
  }
  
  // 更新感恩记录
  Future<void> updateEntry(String id, String content, {String? category}) async {
    final index = _entries.indexWhere((entry) => entry.id == id);
    
    if (index != -1) {
      _entries[index] = _entries[index].copyWith(
        content: content,
        category: category,
      );
      
      await _saveEntries();
      notifyListeners();
    }
  }
  
  // 删除感恩记录
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    await _saveEntries();
    notifyListeners();
  }
  
  // 加载感恩记录
  Future<void> _loadEntries() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final entriesData = await _dbService.getGratitudeEntries();
      _entries = entriesData.map((data) => GratitudeEntry.fromJson(data)).toList();
      _entries.sort((a, b) => b.date.compareTo(a.date)); // 按日期降序排序
    } catch (e) {
      print('加载感恩记录时出错: $e');
      _entries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // 保存感恩记录
  Future<void> _saveEntries() async {
    final entriesData = _entries.map((entry) => entry.toJson()).toList();
    await _dbService.saveGratitudeEntries(entriesData);
  }
} 