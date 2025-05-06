import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';
import '../widgets/common/app_bar.dart';

class BreathingScreen extends StatefulWidget {
  final bool showBackButton;
  
  const BreathingScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
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
    return Scaffold(
      appBar: CustomAppBar(
        title: '呼吸练习',
        showBackButton: widget.showBackButton,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '呼吸练习'),
              Tab(text: '冥想'),
            ],
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                BreathingExercises(),
                MeditationList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BreathingExerciseScreen(
                    title: exercise['title'],
                    duration: exercise['duration'],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: exercise['color'],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      exercise['icon'],
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exercise['description'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${exercise['duration']} 分钟',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MeditationList extends StatelessWidget {
  const MeditationList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择冥想类型',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildMeditationTypeGrid(context),
          const SizedBox(height: 24),
          const Text(
            '推荐冥想',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecommendedList(context),
        ],
      ),
    );
  }

  Widget _buildMeditationTypeGrid(BuildContext context) {
    final List<Map<String, dynamic>> types = AppConstants.meditationTypes
        .asMap()
        .entries
        .map((entry) => {
              'title': entry.value,
              'color': getRandomColor(entry.key),
              'icon': _getMeditationIcon(entry.value),
            })
        .toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        return InkWell(
          onTap: () {
            // 导航到特定类型的冥想列表
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MeditationDetailScreen(
                  title: type['title'],
                  icon: type['icon'],
                  color: type['color'],
                  isTypeDetail: true,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: type['color'],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  type['icon'],
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  type['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecommendedList(BuildContext context) {
    final List<Map<String, dynamic>> recommended = [
      {
        'title': '减轻失眠焦虑',
        'duration': 15,
        'plays': 2389,
        'color': Colors.indigo.shade400,
        'description': '这个冥想专注于减轻睡前焦虑，帮助你平静思绪，为良好的睡眠做准备。通过引导呼吸和身体扫描，逐渐释放白天积累的紧张感。',
      },
      {
        'title': '清晨唤醒冥想',
        'duration': 10,
        'plays': 1560,
        'color': Colors.amber.shade700,
        'description': '开始新的一天的理想方式。这个冥想帮助你以平和的心态醒来，设定积极的意图，并为一天的挑战做好准备。包含温和的伸展和感恩练习。',
      },
      {
        'title': '职场减压练习',
        'duration': 20,
        'plays': 3201,
        'color': Colors.teal.shade400,
        'description': '专为工作日中的短暂休息设计。这个冥想帮助你重置注意力，减轻工作压力，并恢复精神能量。包含简短的正念练习和专注呼吸技巧。',
      },
    ];

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recommended.length,
      itemBuilder: (context, index) {
        final item = recommended[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: item['color'],
              child: const Icon(
                Icons.spa,
                color: Colors.white,
              ),
            ),
            title: Text(
              item['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text('${item['duration']} 分钟'),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.headphones,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text('${item['plays']}'),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_circle_filled),
              color: AppTheme.primaryColor,
              onPressed: () {
                // 播放冥想
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeditationDetailScreen(
                      title: item['title'],
                      duration: item['duration'],
                      color: item['color'],
                      description: item['description'],
                      meditationType: _getMeditationTypeForRecommended(item['title']),
                    ),
                  ),
                );
              },
            ),
            onTap: () {
              // 点击整个卡片也导航到详情页
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeditationDetailScreen(
                    title: item['title'],
                    duration: item['duration'],
                    color: item['color'],
                    description: item['description'],
                    meditationType: _getMeditationTypeForRecommended(item['title']),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getMeditationIcon(String type) {
    switch (type) {
      case '减压冥想':
        return Icons.self_improvement;
      case '专注冥想':
        return Icons.center_focus_strong;
      case '睡前放松':
        return Icons.bedtime;
      case '晨间唤醒':
        return Icons.wb_sunny;
      case '情绪平衡':
        return Icons.balance;
      default:
        return Icons.spa;
    }
  }

  String _getMeditationTypeForRecommended(String title) {
    // 根据冥想标题确定冥想类型
    switch (title) {
      case '减轻失眠焦虑':
        return '睡前放松';
      case '清晨唤醒冥想':
        return '晨间唤醒';
      case '职场减压练习':
        return '减压冥想';
      default:
        // 尝试从标题中识别冥想类型
        if (title.contains('减压') || title.contains('放松')) {
          return '减压冥想';
        } else if (title.contains('专注') || title.contains('注意力')) {
          return '专注冥想';
        } else if (title.contains('睡眠') || title.contains('睡前')) {
          return '睡前放松';
        } else if (title.contains('唤醒') || title.contains('晨间')) {
          return '晨间唤醒';
        } else if (title.contains('情绪') || title.contains('平衡')) {
          return '情绪平衡';
        }
        return '减压冥想'; // 默认类型
    }
  }
}

class BreathingExerciseScreen extends StatefulWidget {
  final String title;
  final int duration; // 分钟

  const BreathingExerciseScreen({
    super.key,
    required this.title,
    required this.duration,
  });

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  Timer? _timer;
  int _secondsRemaining = 0;
  String _breathPhase = '准备';
  bool _isActive = false;
  
  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.duration * 60;
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _breathPhase = '呼气';
        });
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _breathPhase = '吸气';
        });
        _animationController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
  
  void _startExercise() {
    setState(() {
      _isActive = true;
      _breathPhase = '吸气';
    });
    
    _animationController.forward();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopExercise();
        }
      });
    });
  }
  
  void _stopExercise() {
    _timer?.cancel();
    _animationController.stop();
    
    setState(() {
      _isActive = false;
      _breathPhase = '完成';
    });
  }
  
  void _resetExercise() {
    _timer?.cancel();
    _animationController.reset();
    
    setState(() {
      _isActive = false;
      _secondsRemaining = widget.duration * 60;
      _breathPhase = '准备';
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _breathPhase,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 200 * _animation.value,
                  height: 200 * _animation.value,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 100 * _animation.value,
                      height: 100 * _animation.value,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              formatDuration(_secondsRemaining),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isActive)
                  ElevatedButton(
                    onPressed: _startExercise,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('开始'),
                  )
                else
                  ElevatedButton(
                    onPressed: _stopExercise,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('结束'),
                  ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: _resetExercise,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('重置'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MeditationDetailScreen extends StatefulWidget {
  final String title;
  final IconData? icon;
  final Color color;
  final int? duration;
  final String? description;
  final bool isTypeDetail;
  final String? meditationType;

  const MeditationDetailScreen({
    super.key,
    required this.title,
    required this.color,
    this.icon,
    this.duration,
    this.description,
    this.isTypeDetail = false,
    this.meditationType,
  });

  @override
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _progress = 0.0;
  late AnimationController _animationController;
  Timer? _timer;
  int _secondsElapsed = 0;
  int _totalSeconds = 0;
  String _breathPhase = '准备';
  int _breathInDuration = 4;  // 默认吸气时间
  int _breathOutDuration = 4;  // 默认呼气时间
  int _holdDuration = 0;  // 默认屏息时间
  int _currentCycleSeconds = 0;  // 当前呼吸周期计时
  int _totalCycle = 8;  // 呼吸总周期
  String _guidanceText = '保持自然舒适的呼吸节奏，专注于呼吸的感觉';  // 引导文本

  @override
  void initState() {
    super.initState();
    
    // 首先初始化动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    if (widget.duration != null) {
      _totalSeconds = widget.duration! * 60;
    }
    
    // 然后设置呼吸模式
    _setupBreathingPattern();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // 根据冥想类型设置不同的呼吸模式
  void _setupBreathingPattern() {
    if (widget.isTypeDetail) return;
    
    // 首先检查是否有指定冥想类型
    String typeToCheck = widget.meditationType ?? widget.title;
    
    // 根据冥想标题或指定类型设置呼吸节奏
    switch (typeToCheck) {
      case '减压冥想':
      case '职场减压练习':
      case '快速减压 · 5分钟':
      case '身心放松 · 10分钟':
      case '压力消融 · 15分钟':
      case '内心宁静 · 20分钟':
        _breathInDuration = 4;
        _breathOutDuration = 6;
        _holdDuration = 0;
        _guidanceText = '缓慢吸气4秒，然后更长时间地呼气6秒，释放紧张感';
        break;
      case '专注冥想':
      case '注意力聚焦 · 5分钟':
      case '心流体验 · 12分钟':
      case '深度专注 · 18分钟':
      case '意识锻炼 · 25分钟':
        _breathInDuration = 4;
        _breathOutDuration = 4;
        _holdDuration = 4;
        _guidanceText = '平稳吸气4秒，保持4秒，呼气4秒，形成方形呼吸节奏';
        break;
      case '睡前放松':
      case '减轻失眠焦虑':
      case '入睡准备 · 8分钟':
      case '身体扫描 · 12分钟':
      case '安眠冥想 · 18分钟':
      case '深度睡眠 · 25分钟':
        _breathInDuration = 4;
        _breathOutDuration = 8;
        _holdDuration = 7;
        _guidanceText = '4-7-8呼吸法：吸气4秒，保持7秒，呼气8秒，帮助快速入睡';
        break;
      case '晨间唤醒':
      case '清晨唤醒冥想':
      case '活力唤醒 · 5分钟':
      case '日出冥想 · 8分钟':
      case '新日之始 · 12分钟':
      case '晨间仪式 · 15分钟':
        _breathInDuration = 6;
        _breathOutDuration = 2;
        _holdDuration = 1;
        _guidanceText = '深长吸气6秒，短促有力地呼气2秒，唤醒身心活力';
        break;
      case '情绪平衡':
      case '情绪觉察 · 5分钟':
      case '平衡之道 · 10分钟':
      case '情绪转化 · 15分钟':
      case '内在和谐 · 20分钟':
        _breathInDuration = 5;
        _breathOutDuration = 5;
        _holdDuration = 2;
        _guidanceText = '均衡吸气5秒，短暂保持2秒，均衡呼气5秒，保持情绪稳定';
        break;
      default:
        _breathInDuration = 4;
        _breathOutDuration = 4;
        _holdDuration = 0;
        _guidanceText = '保持自然舒适的呼吸节奏，专注于呼吸的感觉';
    }
    
    // 计算单个呼吸周期总时长
    _totalCycle = _breathInDuration + _holdDuration + _breathOutDuration;
    
    // 设置动画时长
    _animationController.duration = Duration(seconds: _breathInDuration);
  }

  void _togglePlay() {
    if (_isPlaying) {
      _timer?.cancel();
      _animationController.stop();
    } else {
      _startBreathingCycle();
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsElapsed < _totalSeconds) {
          setState(() {
            _secondsElapsed++;
            _currentCycleSeconds++;
            _progress = _secondsElapsed / _totalSeconds;
            
            // 管理呼吸周期
            _updateBreathPhase();
          });
        } else {
          _timer?.cancel();
          _animationController.stop();
          setState(() {
            _isPlaying = false;
            _progress = 0.0;
            _secondsElapsed = 0;
            _currentCycleSeconds = 0;
            _breathPhase = '完成';
          });
        }
      });
    }
    
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }
  
  void _startBreathingCycle() {
    setState(() {
      _breathPhase = '吸气';
      _currentCycleSeconds = 0;
    });
    
    // 重置动画并开始
    _animationController.reset();
    _animationController.forward();
  }
  
  void _updateBreathPhase() {
    // 根据当前周期秒数来确定呼吸阶段
    int cyclePosition = _currentCycleSeconds % _totalCycle;
    
    if (cyclePosition < _breathInDuration) {
      // 吸气阶段
      if (_breathPhase != '吸气') {
        setState(() {
          _breathPhase = '吸气';
        });
        _animationController.forward();
      }
    } else if (cyclePosition < _breathInDuration + _holdDuration) {
      // 屏息阶段
      if (_breathPhase != '保持') {
        setState(() {
          _breathPhase = '保持';
        });
        _animationController.stop();
      }
    } else if (cyclePosition < _totalCycle) {
      // 呼气阶段
      if (_breathPhase != '呼气') {
        setState(() {
          _breathPhase = '呼气';
        });
        _animationController.reverse();
      }
    }
    
    // 如果完成一个周期，重新开始
    if (cyclePosition == _totalCycle - 1) {
      _currentCycleSeconds = 0;
    }
  }

  Widget _buildTypeDetailContent() {
    // 根据冥想类型提供特定的课程列表
    final List<Map<String, dynamic>> meditations = _getTypeSpecificMeditations(widget.title);
    
    // 获取该类型的呼吸设置
    final breathPattern = _getBreathPatternForType(widget.title);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 呼吸演示区域
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '呼吸模式演示',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBreathPhaseInfo('吸气', breathPattern['inhaleDuration'], widget.color),
                      if (breathPattern['holdDuration'] > 0)
                        _buildBreathPhaseInfo('保持', breathPattern['holdDuration'], Colors.amber),
                      _buildBreathPhaseInfo('呼气', breathPattern['exhaleDuration'], Colors.teal),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  breathPattern['description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          // 关于此类型
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 8),
            child: Text(
              '关于此类型',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _getTypeDescription(widget.title),
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
          
          // 推荐课程
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 8),
            child: Text(
              '推荐课程',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: meditations.length,
            itemBuilder: (context, index) {
              final item = meditations[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: widget.color.withOpacity(0.2),
                  child: Icon(
                    widget.icon ?? Icons.spa,
                    color: widget.color,
                  ),
                ),
                title: Text(item['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('${item['duration']} 分钟'),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item['level'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (item['description'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          item['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  color: AppTheme.primaryColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationDetailScreen(
                          title: item['title'],
                          duration: item['duration'],
                          color: widget.color,
                          icon: widget.icon,
                          description: item['description'] ?? _getTypeDescription(widget.title),
                          meditationType: widget.title, // 传递冥想类型
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  // 构建呼吸阶段信息卡片
  Widget _buildBreathPhaseInfo(String phase, int duration, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$duration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          phase,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '秒',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  // 获取特定冥想类型的呼吸设置
  Map<String, dynamic> _getBreathPatternForType(String type) {
    switch (type) {
      case '减压冥想':
        return {
          'inhaleDuration': 4,
          'holdDuration': 0,
          'exhaleDuration': 6,
          'description': '缓慢吸气4秒，然后更长时间地呼气6秒，释放紧张感',
        };
      case '专注冥想':
        return {
          'inhaleDuration': 4,
          'holdDuration': 4,
          'exhaleDuration': 4,
          'description': '平稳吸气4秒，保持4秒，呼气4秒，形成方形呼吸节奏',
        };
      case '睡前放松':
        return {
          'inhaleDuration': 4,
          'holdDuration': 7,
          'exhaleDuration': 8,
          'description': '4-7-8呼吸法：吸气4秒，保持7秒，呼气8秒，帮助快速入睡',
        };
      case '晨间唤醒':
        return {
          'inhaleDuration': 6,
          'holdDuration': 1,
          'exhaleDuration': 2,
          'description': '深长吸气6秒，短促有力地呼气2秒，唤醒身心活力',
        };
      case '情绪平衡':
        return {
          'inhaleDuration': 5,
          'holdDuration': 2,
          'exhaleDuration': 5,
          'description': '均衡吸气5秒，短暂保持2秒，均衡呼气5秒，保持情绪稳定',
        };
      default:
        return {
          'inhaleDuration': 4,
          'holdDuration': 0,
          'exhaleDuration': 4,
          'description': '自然舒适的呼吸节奏，专注于呼吸的感觉',
        };
    }
  }
  
  // 获取特定类型的冥想课程列表
  List<Map<String, dynamic>> _getTypeSpecificMeditations(String type) {
    switch (type) {
      case '减压冥想':
        return [
          {
            'title': '快速减压 · 5分钟',
            'duration': 5,
            'level': '初级',
            'description': '适合工作间隙快速放松，缓解即时压力',
          },
          {
            'title': '身心放松 · 10分钟',
            'duration': 10,
            'level': '初级',
            'description': '逐步扫描全身，释放肌肉紧张，回归平静状态',
          },
          {
            'title': '压力消融 · 15分钟',
            'duration': 15,
            'level': '中级',
            'description': '通过延长呼气，激活副交感神经系统，深度放松',
          },
          {
            'title': '内心宁静 · 20分钟',
            'duration': 20,
            'level': '高级',
            'description': '建立压力缓冲区，培养面对压力的长期韧性',
          },
        ];
      case '专注冥想':
        return [
          {
            'title': '注意力聚焦 · 5分钟',
            'duration': 5,
            'level': '初级',
            'description': '基础呼吸锚定练习，找回当下的注意力',
          },
          {
            'title': '心流体验 · 12分钟',
            'duration': 12,
            'level': '中级',
            'description': '使用方形呼吸法，增强专注力和思维清晰度',
          },
          {
            'title': '深度专注 · 18分钟',
            'duration': 18,
            'level': '中级',
            'description': '延长保持阶段，增强注意力持续时间',
          },
          {
            'title': '意识锻炼 · 25分钟',
            'duration': 25,
            'level': '高级',
            'description': '培养元认知能力，观察思绪而不被带走',
          },
        ];
      case '睡前放松':
        return [
          {
            'title': '入睡准备 · 8分钟',
            'duration': 8,
            'level': '初级',
            'description': '使用4-7-8呼吸法，快速进入放松状态',
          },
          {
            'title': '身体扫描 · 12分钟',
            'duration': 12,
            'level': '初级',
            'description': '从头到脚逐步放松身体每个部位',
          },
          {
            'title': '安眠冥想 · 18分钟',
            'duration': 18,
            'level': '中级',
            'description': '延长呼气和保持阶段，深度放松紧张神经',
          },
          {
            'title': '深度睡眠 · 25分钟',
            'duration': 25,
            'level': '高级',
            'description': '帮助处理白天的情绪和疲劳，准备高质量睡眠',
          },
        ];
      case '晨间唤醒':
        return [
          {
            'title': '活力唤醒 · 5分钟',
            'duration': 5,
            'level': '初级',
            'description': '短促有力的呼吸节奏，快速唤醒身体',
          },
          {
            'title': '日出冥想 · 8分钟',
            'duration': 8,
            'level': '初级',
            'description': '结合能量呼吸和积极意图设定',
          },
          {
            'title': '新日之始 · 12分钟',
            'duration': 12,
            'level': '中级',
            'description': '有节奏的呼吸模式，激活身体能量中心',
          },
          {
            'title': '晨间仪式 · 15分钟',
            'duration': 15,
            'level': '高级',
            'description': '整合呼吸、意图和感恩，全面准备新的一天',
          },
        ];
      case '情绪平衡':
        return [
          {
            'title': '情绪觉察 · 5分钟',
            'duration': 5,
            'level': '初级',
            'description': '学习识别和接纳当前情绪状态',
          },
          {
            'title': '平衡之道 · 10分钟',
            'duration': 10,
            'level': '初级',
            'description': '通过均衡呼吸找回情绪中心',
          },
          {
            'title': '情绪转化 · 15分钟',
            'duration': 15,
            'level': '中级',
            'description': '学习转化负面情绪，找回内心平静',
          },
          {
            'title': '内在和谐 · 20分钟',
            'duration': 20,
            'level': '高级',
            'description': '深入探索情绪根源，建立长期情绪稳定性',
          },
        ];
      default:
        return [
          {
            'title': '基础入门 · 5分钟',
            'duration': 5,
            'level': '初级',
          },
          {
            'title': '进阶练习 · 10分钟',
            'duration': 10,
            'level': '初级',
          },
          {
            'title': '深度体验 · 15分钟',
            'duration': 15,
            'level': '中级',
          },
          {
            'title': '专业级别 · 20分钟',
            'duration': 20,
            'level': '高级',
          },
        ];
    }
  }

  Widget _buildMeditationDetailContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // 显示当前呼吸阶段
                if (_isPlaying)
                  Text(
                    _breathPhase,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                const SizedBox(height: 24),
                // 呼吸动画
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(0.3),
                            blurRadius: 20 * _animationController.value,
                            spreadRadius: 5 * _animationController.value,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 100 * (_isPlaying ? _animationController.value : 0.8),
                          height: 100 * (_isPlaying ? _animationController.value : 0.8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color.withOpacity(0.7),
                          ),
                          child: _isPlaying 
                              ? null 
                              : Icon(
                                  Icons.play_arrow,
                                  size: 60,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // 呼吸引导文本
                if (_isPlaying)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      _guidanceText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // 进度条
                if (_isPlaying)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${formatDuration(_secondsElapsed)} / ${formatDuration(_totalSeconds)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                // 控制按钮
                ElevatedButton.icon(
                  onPressed: widget.duration != null ? _togglePlay : null,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlaying ? '暂停' : '开始冥想'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 呼吸节奏说明
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '时长: ${widget.duration} 分钟',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.air,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '呼吸节奏: 吸气 $_breathInDuration 秒${_holdDuration > 0 ? '，保持 $_holdDuration 秒' : ''}，呼气 $_breathOutDuration 秒',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '关于此冥想',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description ?? '这是一段关于冥想的引导文字，让您放松身心，专注当下。通过引导呼吸和身体感知，帮助您舒缓压力，增强专注力。',
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '冥想提示',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTipItem('找一个安静的地方，保持舒适的坐姿'),
                _buildTipItem('集中注意力于您的呼吸，感受空气的流动'),
                _buildTipItem('当思绪漫游时，轻轻地将注意力带回呼吸'),
                _buildTipItem('不要对分心感到沮丧，这是正常现象'),
                _buildTipItem('保持耐心和开放的心态，享受当下的片刻'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: widget.color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeDescription(String type) {
    switch (type) {
      case '减压冥想':
        return '减压冥想帮助您缓解日常生活中积累的压力和焦虑。通过引导呼吸和放松技巧，这类冥想能够帮助您重置神经系统，找回内心的平静。适合任何感到压力或紧张的时刻。';
      case '专注冥想':
        return '专注冥想训练您集中注意力的能力，增强思维的清晰度。通过锚定呼吸或特定对象，培养稳定的专注力。这类冥想可以提高工作效率，并帮助您更好地应对分心的环境。';
      case '睡前放松':
        return '睡前放松冥想专为改善睡眠质量而设计。通过身体扫描和渐进式放松技巧，帮助您释放一天的紧张感，为深度、优质的睡眠做好准备。建议在睡前30分钟进行。';
      case '晨间唤醒':
        return '晨间唤醒冥想帮助您以平和而警觉的状态开始新的一天。结合温和的呼吸练习和积极的意图设定，这类冥想可以增强您的能量水平，为一天的活动做好准备。';
      case '情绪平衡':
        return '情绪平衡冥想教导您观察和接纳各种情绪，而不被它们所控制。通过培养对情绪的觉知和理解，您可以发展更健康的情绪反应模式，提高情绪智力和内心稳定性。';
      default:
        return '这种冥想类型帮助您建立与当下时刻的联系，培养不加评判的觉知。通过定期练习，您可以体验到更大的内心平静、减少压力，并增强对生活挑战的适应能力。';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        showBackButton: true,
      ),
      body: widget.isTypeDetail
          ? _buildTypeDetailContent()
          : _buildMeditationDetailContent(),
    );
  }
} 