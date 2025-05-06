import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/common/app_bar.dart';
import '../screens/breathing_screen.dart';
import '../screens/gratitude_screen.dart';
import '../screens/sleep_aid_screen.dart';
import '../screens/growth_screen.dart';
import '../screens/article_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppConstants.appName,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, '今日放松'),
            const SizedBox(height: 12),
            _buildQuickAccessGrid(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, '推荐阅读'),
            const SizedBox(height: 12),
            _buildArticleList(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '平静一下，感受当下',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(
                    Icons.self_improvement,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '「焦虑来自于对未知的恐惧，而平静源自对当下的专注。」',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 跳转到呼吸页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BreathingScreen(showBackButton: true)),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('开始一分钟呼吸'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
  
  Widget _buildQuickAccessGrid(BuildContext context) {
    final List<Map<String, dynamic>> quickAccess = [
      {
        'title': '睡前呼吸',
        'icon': Icons.nightlight_round,
        'color': Colors.indigo.shade400,
        'route': const BreathingScreen(showBackButton: true),
      },
      {
        'title': '记录感恩',
        'icon': Icons.favorite,
        'color': Colors.red.shade400,
        'route': const GratitudeScreen(showBackButton: true),
      },
      {
        'title': '思想重构',
        'icon': Icons.psychology,
        'color': Colors.amber.shade700,
        'route': const GrowthScreen(showBackButton: true),
      },
      {
        'title': '助眠声音',
        'icon': Icons.music_note,
        'color': Colors.teal.shade400,
        'route': const SleepAidScreen(showBackButton: true),
      },
    ];
    
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: quickAccess.length,
      itemBuilder: (context, index) {
        final item = quickAccess[index];
        return InkWell(
          onTap: () {
            // 导航到相应页面
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => item['route']),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: item['color'],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'],
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildArticleList(BuildContext context) {
    final List<Map<String, dynamic>> articles = [
      {
        'title': '如何缓解失眠焦虑',
        'summary': '探索实用技巧，帮助你放松身心，改善睡眠质量。',
        'icon': Icons.bedtime,
        'content': '失眠和焦虑是现代人常见的问题，它们往往相互影响，形成恶性循环。当我们焦虑时，大脑处于高度警觉状态，难以放松入睡；而睡眠不足又会加剧焦虑情绪。\n\n以下方法可以帮助你缓解这种情况：\n\n1. 建立规律的睡眠时间表：每天固定时间上床和起床，帮助调整生物钟。\n\n2. 创造理想的睡眠环境：保持卧室安静、黑暗和凉爽。\n\n3. 睡前放松仪式：可以是热水澡、轻柔的伸展运动或冥想。\n\n4. 限制睡前使用电子设备：蓝光会抑制褪黑素的产生。\n\n5. 白噪音：有些人发现轻柔的背景声音如雨声或风扇声有助于入睡。\n\n6. 深呼吸练习：4-7-8呼吸法（吸气4秒，屏息7秒，呼气8秒）被证明能有效减轻焦虑。\n\n7. 日间适度运动：但避免睡前3小时内进行剧烈活动。\n\n8. 注意饮食：避免睡前摄入咖啡因、酒精和大量食物。\n\n9. 写下担忧：在白天花时间记录你的忧虑，制定应对计划。\n\n10. 认知行为疗法技巧：识别并挑战导致焦虑的消极思维模式。\n\n记住，改善睡眠和减轻焦虑是一个渐进的过程，对自己要有耐心。如果问题持续或严重影响生活质量，请考虑咨询专业人士获取帮助。',
      },
      {
        'title': '专注当下的艺术',
        'summary': '学习正念冥想，摆脱对过去和未来的过度关注。',
        'icon': Icons.center_focus_strong,
        'content': '在这个信息过载的时代，我们的思绪常常在过去的遗憾和未来的担忧之间游走，很少真正活在当下。正念冥想是一种帮助我们回归现在的有效工具。\n\n什么是正念？\n正念是有意识地、不加评判地关注当下体验的能力。它不是试图清空思想，而是觉察它们，然后温和地将注意力带回当前时刻。\n\n正念的益处：\n• 减轻压力与焦虑\n• 提高注意力和集中力\n• 增强情绪调节能力\n• 改善人际关系\n• 促进身心健康\n\n开始练习正念的简单步骤：\n\n1. 找一个安静的地方，采取舒适的姿势坐下。\n\n2. 设定一个温和的计时器（初学者可以从5分钟开始）。\n\n3. 闭上眼睛或保持柔和的视线。\n\n4. 将注意力带到呼吸上，感受空气进入和离开身体的感觉。\n\n5. 当心智漫游时（这是正常的），温和地注意到它，然后将注意力重新引导回呼吸。\n\n6. 结束时，先注意身体的感觉，然后是周围的声音，最后睁开眼睛。\n\n日常生活中的正念练习：\n• 正念饮食：细细品味每一口食物的味道和质地。\n• 正念行走：注意脚接触地面的感觉，周围的声音和景象。\n• 正念倾听：完全投入到与他人的对话中，不急于回应。\n\n记住，正念不是一项需要完美执行的任务，而是一种培养的态度。每天花几分钟练习，逐渐将这种觉知带入日常生活的各个方面。',
      },
      {
        'title': '从比较中解脱',
        'summary': '为什么与他人比较会带来不必要的焦虑，以及如何避免。',
        'icon': Icons.compare_arrows,
        'content': '社会比较是人类的自然倾向，但在社交媒体时代，这种比较变得更加频繁和强烈，往往导致不必要的焦虑、自卑和不满足感。\n\n为什么我们总是比较？\n\n• 进化视角：通过与他人比较，我们的祖先能评估自己在群体中的地位和生存机会。\n• 自我评估：比较提供了评估自我价值和能力的参考标准。\n• 社会认同：比较帮助我们了解社会期望和规范。\n\n社会比较的负面影响：\n\n• 焦虑和抑郁情绪增加\n• 自尊心降低\n• 嫉妒和不满情绪\n• 对自己真实需求的忽视\n• 持续不断的压力\n\n如何摆脱比较的循环：\n\n1. 觉察比较的习惯：第一步是意识到何时陷入比较思维。\n\n2. 提醒自己看到的只是表象：特别是在社交媒体上，人们往往只展示生活中最光鲜的部分。\n\n3. 实践感恩：定期反思你生活中已有的积极方面。\n\n4. 定义个人价值标准：明确什么对你真正重要，而不是追随社会的期望。\n\n5. 限制社交媒体使用：如果某些平台或账号总是触发比较心理，考虑减少接触。\n\n6. 与自己比较：关注你自己的成长和进步，而不是与他人的差距。\n\n7. 庆祝他人的成功：将他人的成就视为灵感而非威胁。\n\n8. 接受不完美：认识到完美是不可能的，接受自己的弱点和局限。\n\n9. 寻找共鸣而非比较：与他人建立真实的联系，分享类似的挑战和困境。\n\n10. 专注于你能控制的事物：将精力集中在自己的行动和选择上。\n\n记住，从比较中解脱是一个过程，需要有意识的努力和持续的练习。随着时间的推移，你会发现自己更加平静，更能欣赏自己独特的旅程。',
      },
    ];
    
    return Column(
      children: articles.map((article) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                child: Icon(
                  article['icon'],
                  color: AppTheme.primaryColor,
                ),
              ),
              title: Text(
                article['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(article['summary']),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // 导航到文章详情
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleScreen(
                      title: article['title'],
                      content: article['content'],
                      icon: article['icon'],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
} 