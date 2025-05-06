import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
    );
  }
} 