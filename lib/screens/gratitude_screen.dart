import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../widgets/common/app_bar.dart';
import '../providers/gratitude_provider.dart';
import '../models/gratitude_entry.dart';
import '../utils/helpers.dart';

class GratitudeScreen extends StatelessWidget {
  final bool showBackButton;
  
  const GratitudeScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GratitudeProvider(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              title: '感恩日记',
              showBackButton: showBackButton,
            ),
            body: const GratitudeContent(),
          );
        }
      ),
    );
  }
}

class GratitudeContent extends StatefulWidget {
  const GratitudeContent({super.key});

  @override
  State<GratitudeContent> createState() => _GratitudeContentState();
}

class _GratitudeContentState extends State<GratitudeContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GratitudeProvider>(context);
    
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '今日感恩'),
              Tab(text: '历史记录'),
            ],
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodayGratitude(provider),
                _buildHistoryGratitude(provider),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEntryDialog(context, provider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildTodayGratitude(GratitudeProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final todayEntries = provider.todayEntries;
    
    if (todayEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '今天还没有记录感恩事项',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('添加感恩事项'),
              onPressed: () {
                _showAddEntryDialog(context, provider);
              },
            ),
          ],
        ),
      );
    }
    
    return _buildGratitudeList(todayEntries, provider);
  }
  
  Widget _buildHistoryGratitude(GratitudeProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildDatePicker(),
        ),
        Expanded(
          child: _buildGratitudeList(
            provider.getEntriesByDate(_selectedDate),
            provider
          ),
        ),
      ],
    );
  }
  
  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatDate(_selectedDate, format: 'yyyy年MM月dd日'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getWeekday(_selectedDate),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final selectedDay = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
              );
              
              if (!selectedDay.isAfter(today)) {
                setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 1));
                });
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildGratitudeList(List<GratitudeEntry> entries, GratitudeProvider provider) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '这一天没有记录感恩事项',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        entry.category,
                        style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatDateTime(entry.date),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  entry.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        _showEditEntryDialog(context, entry, provider);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        _showDeleteConfirmDialog(context, entry, provider);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddEntryDialog(BuildContext context, GratitudeProvider provider) {
    final TextEditingController contentController = TextEditingController();
    String selectedCategory = '一般';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加感恩事项'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: '我感恩的是...',
                  hintText: '记录一件今天令你感恩的事',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: '类别',
                ),
                items: const [
                  DropdownMenuItem(value: '一般', child: Text('一般')),
                  DropdownMenuItem(value: '家庭', child: Text('家庭')),
                  DropdownMenuItem(value: '工作', child: Text('工作')),
                  DropdownMenuItem(value: '健康', child: Text('健康')),
                  DropdownMenuItem(value: '友情', child: Text('友情')),
                  DropdownMenuItem(value: '自然', child: Text('自然')),
                ],
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                if (contentController.text.isNotEmpty) {
                  provider.addEntry(
                    contentController.text,
                    category: selectedCategory,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
  
  void _showEditEntryDialog(BuildContext context, GratitudeEntry entry, GratitudeProvider provider) {
    final TextEditingController contentController = TextEditingController(text: entry.content);
    String selectedCategory = entry.category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('编辑感恩事项'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: '我感恩的是...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: '类别',
                ),
                items: const [
                  DropdownMenuItem(value: '一般', child: Text('一般')),
                  DropdownMenuItem(value: '家庭', child: Text('家庭')),
                  DropdownMenuItem(value: '工作', child: Text('工作')),
                  DropdownMenuItem(value: '健康', child: Text('健康')),
                  DropdownMenuItem(value: '友情', child: Text('友情')),
                  DropdownMenuItem(value: '自然', child: Text('自然')),
                ],
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                if (contentController.text.isNotEmpty) {
                  provider.updateEntry(
                    entry.id,
                    contentController.text,
                    category: selectedCategory,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
  
  void _showDeleteConfirmDialog(BuildContext context, GratitudeEntry entry, GratitudeProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除感恩事项'),
          content: const Text('确定要删除这条感恩记录吗？此操作不可撤销。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.deleteEntry(entry.id);
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已删除感恩记录'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }
} 