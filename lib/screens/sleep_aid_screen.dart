import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/theme.dart';
import '../widgets/common/app_bar.dart';
import '../services/audio_service.dart';
import '../utils/helpers.dart';

// 全局音频服务实例，确保在整个应用中使用同一个实例
final AudioService globalAudioService = AudioService();

class SleepAidScreen extends StatelessWidget {
  final bool showBackButton;
  
  const SleepAidScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '睡眠辅助',
        showBackButton: showBackButton,
      ),
      body: const SleepAidContent(),
    );
  }
}

class SleepAidContent extends StatefulWidget {
  const SleepAidContent({super.key});

  @override
  State<SleepAidContent> createState() => _SleepAidContentState();
}

class _SleepAidContentState extends State<SleepAidContent> with SingleTickerProviderStateMixin {
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
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '助眠声音'),
            Tab(text: '入睡提示'),
          ],
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              SleepSoundsTab(),
              SleepTipsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class SleepSoundsTab extends StatefulWidget {
  const SleepSoundsTab({super.key});

  @override
  State<SleepSoundsTab> createState() => _SleepSoundsTabState();
}

class _SleepSoundsTabState extends State<SleepSoundsTab> with WidgetsBindingObserver {
  // 使用全局音频服务实例
  final AudioService _audioService = globalAudioService;
  String? _currentPlayingSound;
  double _volume = 0.7;
  bool _isTimerSet = false;
  int _timerMinutes = 30;
  Timer? _sleepTimer;
  
  final List<Map<String, dynamic>> _natureSounds = [
    {
      'title': '雨声',
      'asset': 'audio/rain.wav',
      'icon': Icons.water_drop,
      'color': Colors.blue.shade700,
    },
    {
      'title': '森林',
      'asset': 'audio/forest.wav',
      'icon': Icons.forest,
      'color': Colors.green.shade700,
    },
    {
      'title': '海浪',
      'asset': 'audio/waves.wav',
      'icon': Icons.waves,
      'color': Colors.cyan.shade700,
    },
    {
      'title': '溪流',
      'asset': 'audio/stream.wav',
      'icon': Icons.water,
      'color': Colors.lightBlue.shade700,
    },
    {
      'title': '鸟叫声',
      'asset': 'audio/bird.wav',
      'icon': Icons.flutter_dash,
      'color': Colors.amber.shade700,
    },
  ];
  
  final List<Map<String, dynamic>> _whiteNoiseSounds = [
    {
      'title': '白噪音',
      'asset': 'audio/white_noise.mp3',
      'icon': Icons.noise_aware,
      'color': Colors.grey.shade700,
    },
    {
      'title': '风扇声',
      'asset': 'audio/fan.flac',
      'icon': Icons.air,
      'color': Colors.blueGrey.shade700,
    },
  ];
  
  final List<Map<String, dynamic>> _meditationSounds = [
    {
      'title': '冥想音乐1',
      'asset': 'audio/Meditation-Theta-Waves.mp3',
      'icon': Icons.self_improvement,
      'color': Colors.purple.shade700,
    },
    {
      'title': '冥想音乐2',
      'asset': 'audio/Meditation-Soundscape-852-Hz.mp3',
      'icon': Icons.self_improvement,
      'color': Colors.deepPurple.shade700,
    },
    {
      'title': '平静睡眠',
      'asset': 'audio/peaceful-sleep-188311.mp3',
      'icon': Icons.nightlight,
      'color': Colors.indigo.shade700,
    },
    {
      'title': '情绪疗愈',
      'asset': 'audio/emotions-246693.mp3',
      'icon': Icons.psychology,
      'color': Colors.pink.shade700,
    },
    {
      'title': '水磨坊冥想',
      'asset': 'audio/The-Old-Water-Mill-Meditation.mp3',
      'icon': Icons.water_drop,
      'color': Colors.teal.shade700,
    },
    {
      'title': '睡眠音乐1',
      'asset': 'audio/sleep-music-vol16-195422.mp3',
      'icon': Icons.bedtime,
      'color': Colors.blue.shade800,
    },
    {
      'title': '睡眠音乐2',
      'asset': 'audio/sleep-music-vol11-190198.mp3',
      'icon': Icons.bedtime,
      'color': Colors.indigo.shade800,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _audioService.init();
    
    // 注册应用生命周期观察者
    WidgetsBinding.instance.addObserver(this);
    
    // 检查当前是否有音频在播放
    _currentPlayingSound = _audioService.currentAsset;
    _volume = _audioService.isPlaying ? _volume : 0.7;
  }
  
  @override
  void dispose() {
    _sleepTimer?.cancel();
    
    // 不在这里销毁音频服务，只移除观察者
    WidgetsBinding.instance.removeObserver(this);
    
    super.dispose();
  }
  
  // 处理应用生命周期事件
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('应用生命周期状态变化: $state');
    
    // 在应用进入后台或恢复时不做额外处理，让音频继续播放
    if (state == AppLifecycleState.paused) {
      // 应用进入后台，但不暂停音频
    } else if (state == AppLifecycleState.resumed) {
      // 应用恢复前台，刷新UI状态
      setState(() {
        _currentPlayingSound = _audioService.currentAsset;
      });
    }
  }
  
  void _togglePlay(String asset) async {
    if (_currentPlayingSound == asset && _audioService.isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play(asset: asset);
      _currentPlayingSound = asset;
    }
    setState(() {});
  }
  
  void _setTimer() {
    _sleepTimer?.cancel();
    if (_isTimerSet) {
      _sleepTimer = Timer(Duration(minutes: _timerMinutes), () {
        _audioService.stop();
        setState(() {
          _currentPlayingSound = null;
          _isTimerSet = false;
        });
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentPlayingSound != null) _buildNowPlaying(),
          const SizedBox(height: 20),
          const Text(
            '自然声音',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSoundGrid(_natureSounds),
          const SizedBox(height: 24),
          const Text(
            '白噪音',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSoundGrid(_whiteNoiseSounds),
          const SizedBox(height: 24),
          const Text(
            '冥想音乐',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSoundGrid(_meditationSounds),
          const SizedBox(height: 24),
          const Text(
            '睡眠设置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSleepSettings(),
        ],
      ),
    );
  }
  
  Widget _buildNowPlaying() {
    String title = '';
    Color color = Colors.blue;
    
    for (final soundList in [_natureSounds, _whiteNoiseSounds, _meditationSounds]) {
      for (final sound in soundList) {
        if (sound['asset'] == _currentPlayingSound) {
          title = sound['title'];
          color = sound['color'];
          break;
        }
      }
    }
    
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  '正在播放: $title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _audioService.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    if (_currentPlayingSound != null) {
                      _togglePlay(_currentPlayingSound!);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.volume_down,
                  color: Colors.white,
                  size: 20,
                ),
                Expanded(
                  child: Slider(
                    value: _volume,
                    onChanged: (value) {
                      setState(() {
                        _volume = value;
                        _audioService.setVolume(_volume);
                      });
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                const Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
            if (_isTimerSet)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '睡眠定时: $_timerMinutes 分钟',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSoundGrid(List<Map<String, dynamic>> sounds) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        final sound = sounds[index];
        final bool isPlaying = _currentPlayingSound == sound['asset'] && _audioService.isPlaying;
        
        return Card(
          color: isPlaying ? sound['color'] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isPlaying ? 6 : 2,
          child: InkWell(
            onTap: () => _togglePlay(sound['asset']),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sound['icon'],
                    color: isPlaying ? Colors.white : sound['color'],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sound['title'],
                    style: TextStyle(
                      color: isPlaying ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSleepSettings() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('睡眠定时'),
              subtitle: const Text('声音将在指定时间后自动停止'),
              value: _isTimerSet,
              onChanged: (value) {
                setState(() {
                  _isTimerSet = value;
                  _setTimer();
                });
              },
              activeColor: AppTheme.primaryColor,
            ),
            if (_isTimerSet)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('定时时长'),
                    DropdownButton<int>(
                      value: _timerMinutes,
                      items: [15, 30, 45, 60, 90, 120]
                          .map((minutes) => DropdownMenuItem<int>(
                                value: minutes,
                                child: Text('$minutes 分钟'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _timerMinutes = value;
                            _setTimer();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            const Divider(),
            SwitchListTile(
              title: const Text('循环播放'),
              subtitle: const Text('声音将持续循环播放'),
              value: _audioService.isLooping,
              onChanged: (value) {
                setState(() {
                  _audioService.setLooping(value);
                });
              },
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class SleepTipsTab extends StatelessWidget {
  const SleepTipsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tips = [
      {
        'title': '保持规律的睡眠时间',
        'description': '每天在同一时间上床睡觉和起床，包括周末。这有助于调节你的生物钟，改善睡眠质量。',
        'icon': Icons.schedule,
      },
      {
        'title': '创造舒适的睡眠环境',
        'description': '保持卧室安静、黑暗、凉爽。考虑使用遮光窗帘、白噪音机或舒适的床上用品。',
        'icon': Icons.hotel,
      },
      {
        'title': '限制睡前使用电子设备',
        'description': '睡前至少30分钟避免使用手机、平板电脑等电子设备，蓝光会抑制褪黑素分泌。',
        'icon': Icons.mobile_off,
      },
      {
        'title': '睡前放松',
        'description': '尝试深呼吸、冥想、热水澡或温和的拉伸运动，帮助身体准备好入睡。',
        'icon': Icons.spa,
      },
      {
        'title': '避免咖啡因和酒精',
        'description': '下午和晚上避免摄入咖啡因，睡前避免饮酒，这会干扰睡眠质量。',
        'icon': Icons.no_drinks,
      },
      {
        'title': '睡眠忧虑管理',
        'description': '睡前写下你的担忧或明天的任务清单，帮助清空思绪。如果睡不着，不要看时钟。',
        'icon': Icons.note_alt,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    tip['icon'],
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tip['description'],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 