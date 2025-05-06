// 应用程序常量
class AppConstants {
  // 应用名称
  static const String appName = '好心态';
  
  // 底部导航栏项目
  static const List<String> bottomNavItems = [
    '首页',
    '冥想',
    '感恩',
    '睡眠',
    '成长'
  ];
  
  // 冥想类型
  static const List<String> meditationTypes = [
    '减压冥想',
    '专注冥想',
    '睡前放松',
    '晨间唤醒',
    '情绪平衡'
  ];
  
  // 冥想时长选项（分钟）
  static const List<int> meditationDurations = [
    5,
    10,
    15,
    20,
    30
  ];
  
  // 睡眠声音类型
  static const List<String> sleepSoundTypes = [
    '自然声音',
    '白噪音',
    '冥想音乐',
    '睡前故事'
  ];
  
  // 思想重构步骤
  static const List<String> thoughtRestructuringSteps = [
    '记录引起焦虑的想法',
    '识别思维陷阱',
    '寻找证据',
    '替代想法',
    '反思新认知'
  ];
  
  // 思维陷阱类型
  static const List<String> thinkingTraps = [
    '非黑即白思维',
    '灾难化',
    '情绪推理',
    '以偏概全',
    '心理过滤',
    '否定积极',
    '跳跃结论',
    '标签化',
    '个人化',
    '应该陈述'
  ];
  
  // 思维陷阱描述
  static const Map<String, String> thinkingTrapDescriptions = {
    '非黑即白思维': '将事情简化为两个极端的类别，没有中间状态',
    '灾难化': '预测最坏的结果，过分夸大事情的负面影响',
    '情绪推理': '根据情绪判断事实，认为感觉到的就是真实的',
    '以偏概全': '根据单一事件得出笼统结论',
    '心理过滤': '只注意负面细节，忽视所有积极方面',
    '否定积极': '坚持认为积极经历"不算数"',
    '跳跃结论': '在没有足够证据的情况下做出负面判断',
    '标签化': '给自己或他人贴上极端负面标签',
    '个人化': '认为外部事件都与自己有关，或完全是自己的责任',
    '应该陈述': '使用"应该"、"必须"等刚性规则要求自己或他人'
  };
  
  // 情绪类型
  static const List<String> moodTypes = [
    '平静',
    '快乐',
    '焦虑',
    '悲伤',
    '愤怒',
    '疲惫',
    '充满希望',
    '满足',
    '沮丧',
    '压力大'
  ];
  
  // 默认提醒时间
  static const int defaultReminderHour = 22;  // 晚上10点
  static const int defaultReminderMinute = 0;
} 