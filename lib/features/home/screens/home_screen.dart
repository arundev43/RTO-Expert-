import 'package:flutter/material.dart';
import '../../learn/screens/learn_screen.dart';
import '../../practice/screens/practice_home_screen.dart';
import '../../exam/screens/exam_intro_screen.dart';
import '../../more/screens/more_screen.dart';

/// Bottom-nav shell — replaces the old stacked-card home page. Each tab
/// is a lazily-built full screen, so switching tabs is instant and each
/// screen keeps its own scroll/filter state via IndexedStack.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  static const _tabs = [
    LearnScreen(),
    PracticeHomeScreen(),
    ExamIntroScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _tabIndex, children: _tabs),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Learn'),
          NavigationDestination(
              icon: Icon(Icons.edit_note_outlined),
              selectedIcon: Icon(Icons.edit_note),
              label: 'Practice'),
          NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer),
              label: 'Exam'),
          NavigationDestination(
              icon: Icon(Icons.more_horiz),
              selectedIcon: Icon(Icons.more_horiz),
              label: 'More'),
        ],
      ),
    );
  }
}
