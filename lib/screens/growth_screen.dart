import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';
import '../widgets/common/app_bar.dart';
import '../models/growth_goal.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

class GrowthProvider extends ChangeNotifier {
  final List<GrowthGoal> _goals = [];
  final Uuid _uuid = const Uuid();
  final DatabaseService _db = DatabaseService.instance;
  bool _isLoading = true;
  
  List<GrowthGoal> get goals => _goals;
  bool get isLoading => _isLoading;
  
  GrowthProvider() {
    _loadGoals();
  }
  
  Future<void> _loadGoals() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final goals = await _db.getGrowthGoals();
      _goals.clear();
      _goals.addAll(goals);
    } catch (e) {
      print('加载成长目标错误: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> addGoal(String title, String description, DateTime? targetDate, List<String> milestones) async {
    final newGoal = GrowthGoal(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdDate: DateTime.now(),
      targetDate: targetDate,
      milestones: milestones.map((title) => GrowthMilestone(
        id: _uuid.v4(),
        title: title,
      )).toList(),
    );
    
    _goals.add(newGoal);
    notifyListeners();
    
    // 保存到数据库
    try {
      await _db.saveGrowthGoal(newGoal);
    } catch (e) {
      print('保存成长目标错误: $e');
    }
  }
  
  Future<void> toggleMilestone(String goalId, String milestoneId) async {
    final goalIndex = _goals.indexWhere((goal) => goal.id == goalId);
    if (goalIndex == -1) return;
    
    final milestoneIndex = _goals[goalIndex].milestones.indexWhere(
      (milestone) => milestone.id == milestoneId
    );
    if (milestoneIndex == -1) return;
    
    final milestone = _goals[goalIndex].milestones[milestoneIndex];
    final updatedMilestone = milestone.copyWith(
      isCompleted: !milestone.isCompleted,
      completedDate: milestone.isCompleted ? null : DateTime.now(),
    );
    
    final updatedMilestones = List<GrowthMilestone>.from(_goals[goalIndex].milestones);
    updatedMilestones[milestoneIndex] = updatedMilestone;
    
    final allCompleted = updatedMilestones.every((milestone) => milestone.isCompleted);
    
    final updatedGoal = _goals[goalIndex].copyWith(
      milestones: updatedMilestones,
      isCompleted: allCompleted,
    );
    
    _goals[goalIndex] = updatedGoal;
    notifyListeners();
    
    // 更新数据库
    try {
      await _db.updateGrowthGoal(updatedGoal);
    } catch (e) {
      print('更新成长目标错误: $e');
    }
  }
  
  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((goal) => goal.id == goalId);
    notifyListeners();
    
    // 从数据库删除
    try {
      await _db.deleteGrowthGoal(goalId);
    } catch (e) {
      print('删除成长目标错误: $e');
    }
  }
}

class GrowthScreen extends StatelessWidget {
  final bool showBackButton;
  
  const GrowthScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GrowthProvider(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              title: '个人成长',
              showBackButton: showBackButton,
            ),
            body: const GrowthContent(),
          );
        }
      ),
    );
  }
}

class GrowthContent extends StatelessWidget {
  const GrowthContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GrowthProvider>(context);

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: provider.goals.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  '你还没有设置成长目标',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '点击下方按钮添加你的第一个目标',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('添加成长目标'),
                  onPressed: () {
                    _showAddGoalDialog(context, provider);
                  },
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.goals.length,
            itemBuilder: (context, index) {
              final goal = provider.goals[index];
              return _buildGoalCard(context, goal, provider);
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGoalDialog(context, provider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  void _showAddGoalDialog(BuildContext context, GrowthProvider provider) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final List<TextEditingController> milestoneControllers = [TextEditingController()];
    DateTime? targetDate;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('添加成长目标'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: '目标标题',
                        hintText: '例如：学习冥想',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: '目标描述',
                        hintText: '例如：通过冥想改善专注力和减轻焦虑',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('目标日期：'),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: targetDate ?? DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                            );
                            if (picked != null) {
                              setState(() {
                                targetDate = picked;
                              });
                            }
                          },
                          child: Text(
                            targetDate == null
                                ? '选择日期'
                                : formatDate(targetDate!, format: 'yyyy年MM月dd日'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('里程碑：'),
                    const SizedBox(height: 8),
                    ...List.generate(
                      milestoneControllers.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: milestoneControllers[index],
                                decoration: InputDecoration(
                                  labelText: '里程碑 ${index + 1}',
                                  hintText: '例如：每天坚持10分钟冥想',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: milestoneControllers.length > 1
                                  ? () {
                                      setState(() {
                                        milestoneControllers.removeAt(index);
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('添加里程碑'),
                      onPressed: () {
                        setState(() {
                          milestoneControllers.add(TextEditingController());
                        });
                      },
                    ),
                  ],
                ),
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
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        milestoneControllers.any((controller) => controller.text.isNotEmpty)) {
                      provider.addGoal(
                        titleController.text,
                        descriptionController.text,
                        targetDate,
                        milestoneControllers
                            .where((controller) => controller.text.isNotEmpty)
                            .map((controller) => controller.text)
                            .toList(),
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
      },
    );
  }
  
  Widget _buildGoalCard(BuildContext context, GrowthGoal goal, GrowthProvider provider) {
    final completedCount = goal.milestones.where((m) => m.isCompleted).length;
    final totalCount = goal.milestones.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;
    
    String statusText;
    Color statusColor;
    
    if (goal.isCompleted) {
      statusText = '已完成';
      statusColor = Colors.green;
    } else if (goal.targetDate != null && goal.targetDate!.isBefore(DateTime.now())) {
      statusText = '已过期';
      statusColor = Colors.red;
    } else {
      statusText = '进行中';
      statusColor = AppTheme.primaryColor;
    }
    
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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (goal.targetDate != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.event,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(goal.targetDate!, format: 'yyyy/MM/dd'),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () {
                    _showDeleteConfirmDialog(context, goal, provider);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              goal.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              goal.description,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        goal.isCompleted ? Colors.green : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$completedCount / $totalCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '里程碑',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...goal.milestones.map((milestone) => _buildMilestoneItem(context, goal.id, milestone, provider)).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMilestoneItem(BuildContext context, String goalId, GrowthMilestone milestone, GrowthProvider provider) {
    return CheckboxListTile(
      value: milestone.isCompleted,
      onChanged: (value) {
        provider.toggleMilestone(goalId, milestone.id);
      },
      title: Text(
        milestone.title,
        style: TextStyle(
          decoration: milestone.isCompleted ? TextDecoration.lineThrough : null,
          color: milestone.isCompleted ? Colors.grey : null,
        ),
      ),
      subtitle: milestone.completedDate != null
          ? Text(
              '完成于 ${formatDate(milestone.completedDate!)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            )
          : null,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  void _showDeleteConfirmDialog(BuildContext context, GrowthGoal goal, GrowthProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除成长目标'),
          content: Text('确定要删除 "${goal.title}" 及其所有里程碑吗？此操作不可撤销。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.deleteGoal(goal.id);
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('目标已删除'),
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