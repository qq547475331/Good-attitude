# 好心态应用

一款帮助用户减轻焦虑，培养积极心态的应用程序。通过呼吸练习、冥想、感恩日记、助眠声音和个人成长目标等功能，帮助用户改善心理健康。

[Githhub地址](https://github.com/qq547475331/Good-attitude)

## 截图

![25-05-07 01-24-03 6005](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-03%206005.png)

![25-05-07 01-24-06 6006](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-06%206006.png)

![25-05-07 01-24-08 6007](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-08%206007.png)

![25-05-07 01-24-16 6008](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-16%206008.png)

![25-05-07 01-24-24 6009](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-24%206009.png)

![25-05-07 01-24-33 6010](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-33%206010.png)

![25-05-07 01-24-37 6011](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-37%206011.png)

![25-05-07 01-24-41 6012](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-41%206012.png)

![25-05-07 01-24-43 6013](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-43%206013.png)

![25-05-07 01-24-46 6014](https://picture-base.oss-cn-hangzhou.aliyuncs.com/25-05-07%2001-24-46%206014.png)

## 功能介绍

### 1. 首页

首页提供快速访问各个功能模块的入口，并包含每日问候和推荐阅读文章。

主要功能：
- 快速访问呼吸练习、冥想、感恩日记和助眠功能
- 推荐阅读，提供关于心理健康的文章
- 根据时间显示个性化问候

```dart
// 首页卡片UI示例
Widget _buildWelcomeCard(BuildContext context) {
  final now = DateTime.now();
  final hour = now.hour;
  
  String greeting;
  if (hour < 6) {
    greeting = '夜深了，注意休息';
  } else if (hour < 12) {
    greeting = '早上好';
  } else if (hour < 18) {
    greeting = '下午好';
  } else {
    greeting = '晚上好';
  }
  
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 问候信息与快速操作按钮
        ],
      ),
    ),
  );
}
```

### 2. 呼吸与冥想

提供多种呼吸练习模式和引导式冥想，帮助用户放松身心，缓解焦虑。

主要功能：
- 4-7-8放松呼吸、方形呼吸和腹式呼吸练习
- 引导式冥想音频
- 可视化呼吸动画指导

```dart
// 呼吸练习列表示例
class BreathingExercises extends StatelessWidget {
  const BreathingExercises({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercises = [
      {
        'title': '4-7-8放松呼吸',
        'description': '吸气4秒，屏息7秒，呼气8秒。有效镇静神经系统，缓解焦虑。',
        'duration': 3,
        'color': Colors.blue.shade400,
        'icon': Icons.air,
      },
      {
        'title': '方形呼吸',
        'description': '吸气4秒，屏息4秒，呼气4秒，屏息4秒。帮助平衡身心，改善专注力。',
        'duration': 5,
        'color': Colors.teal.shade400,
        'icon': Icons.crop_square,
      },
      {
        'title': '腹式呼吸',
        'description': '用腹部而非胸部呼吸，深吸缓呼。增强身体氧气供应，促进放松。',
        'duration': 5,
        'color': Colors.purple.shade400,
        'icon': Icons.favorite,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        // 构建呼吸练习卡片
      },
    );
  }
}
```

### 3. 感恩日记

帮助用户记录和回顾值得感恩的事情，培养积极情绪。

主要功能：
- 记录每日感恩事项
- 按日期浏览历史感恩记录
- 分类整理感恩内容

```dart
// 感恩记录数据模型
class GratitudeEntry {
  final String id;
  final String content;
  final DateTime date;
  final String? category;
  
  GratitudeEntry({
    required this.id,
    required this.content,
    required this.date,
    this.category,
  });
  
  // 从JSON转换方法
  factory GratitudeEntry.fromJson(Map<String, dynamic> json) {
    return GratitudeEntry(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }
  
  // 转换为JSON方法
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}
```

### 4. 睡眠辅助

提供各种助眠声音和睡眠建议，帮助用户改善睡眠质量。

主要功能：
- 自然声音（雨声、森林、海浪等）
- 白噪音
- 冥想音乐
- 睡眠定时器
- 睡眠建议与技巧

```dart
// 音频服务实现
class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLooping = false;
  String? _currentAsset;
  
  // 音频控制方法
  Future<void> play({String? asset}) async {
    try {
      if (asset != null && _currentAsset != asset) {
        _currentAsset = asset;
        await _audioPlayer.stop();
        
        String assetPath = asset;
        if (assetPath.startsWith('assets/')) {
          assetPath = assetPath.substring(7);
        }
        
        await _audioPlayer.setSource(AssetSource(assetPath));
        await _audioPlayer.setReleaseMode(_isLooping ? ReleaseMode.loop : ReleaseMode.release);
      }
      
      if (_currentAsset != null) {
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } catch (e) {
      _isPlaying = false;
    }
  }
}
```

### 5. 个人成长

帮助用户设定和追踪个人成长目标，推动积极变化。

主要功能：
- 创建个人成长目标
- 设置里程碑和完成日期
- 跟踪目标进度
- 记录成就

```dart
// 成长目标数据模型
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
  
  // 复制方法，用于状态更新
  GrowthGoal copyWith({
    String? title,
    String? description,
    DateTime? targetDate,
    List<GrowthMilestone>? milestones,
    bool? isCompleted,
  }) {
    return GrowthGoal(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate,
      targetDate: targetDate ?? this.targetDate,
      milestones: milestones ?? this.milestones,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
```

## 技术实现

### 主要依赖

- Flutter: 跨平台UI框架
- Provider: 状态管理
- SQLite: 本地数据存储
- AudioPlayers: 音频播放
- FL Chart: 图表展示

### 数据持久化

应用使用SQLite数据库存储用户数据：

```dart
// 数据库服务实现
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;
  
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
    
    // 其他表结构...
  }
}
```

### 音频服务

应用使用AudioPlayer管理各种音频播放：

```dart
// 全局音频服务实例，确保在整个应用中使用同一个实例
final AudioService globalAudioService = AudioService();
```

## 应用架构

应用采用Provider状态管理和服务层设计：

- 数据模型层: models/
- 视图层: screens/, widgets/
- 状态管理: providers/
- 服务层: services/
- 工具类: utils/

## 开发与运行

1. 确保已安装Flutter SDK
2. 克隆仓库
3. 运行 `flutter pub get` 安装依赖
4. 运行 `flutter run` 启动应用

## 发布版本构建

构建release版本:
```
flutter build apk --release  // Android版本
flutter build ios --release  // iOS版本
```

## 未来规划

- 添加用户账户和数据同步
- 增加更多引导式冥想内容
- 改进UI/UX设计
- 添加情绪追踪功能
- 支持定制化主题