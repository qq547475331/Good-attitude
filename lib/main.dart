import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/breathing_screen.dart';
import 'screens/gratitude_screen.dart';
import 'screens/sleep_aid_screen.dart'; // 导入以获取全局音频服务
import 'screens/growth_screen.dart';
import 'utils/theme.dart';
import 'providers/theme_provider.dart';
import 'services/migration_service.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  // 执行数据迁移
  await MigrationService.instance.migrateData();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 注册应用生命周期观察者
    WidgetsBinding.instance.addObserver(this);
    
    // 确保音频服务初始化
    globalAudioService.init();
  }
  
  @override
  void dispose() {
    // 移除观察者
    WidgetsBinding.instance.removeObserver(this);
    
    // 正确销毁全局音频服务
    globalAudioService.dispose();
    
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 只在应用完全被销毁时处理
    if (state == AppLifecycleState.detached) {
      globalAudioService.dispose();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: '好心态',
          theme: themeProvider.themeData,
          home: const MainScreen(),
        );
      }
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const BreathingScreen(),
    const GratitudeScreen(),
    const SleepAidScreen(),
    const GrowthScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: '冥想',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '感恩',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight),
            label: '睡眠',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: '成长',
          ),
        ],
      ),
    );
  }
}
