import 'package:flutter/material.dart';
import 'package:muslim_app/core/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/quran_screen.dart';
import 'presentation/screens/adhkar_screen.dart';
import 'presentation/screens/audio_screen.dart';
import 'presentation/screens/prayer_times_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MuslimApp(),
    ),
  );
}

class MuslimApp extends StatelessWidget {
  const MuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'التطبيق الإسلامي',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Widget> _screens = const [
    HomeScreen(),
    QuranScreen(),
    AdhkarScreen(),
    AudioScreen(),
    PrayerTimesScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home_filled),
      label: 'الرئيسية',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book_outlined),
      activeIcon: Icon(Icons.book_rounded),
      label: 'القرآن',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_outline),
      activeIcon: Icon(Icons.favorite_rounded),
      label: 'الأذكار',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.audiotrack_outlined),
      activeIcon: Icon(Icons.audiotrack_rounded),
      label: 'التلاوات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.access_time_outlined),
      activeIcon: Icon(Icons.access_time_filled),
      label: 'مواقيت الصلاة',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
        _animationController.forward(from: 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _animation,
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            items: _bottomNavItems,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            showUnselectedLabels: true,
            selectedIconTheme: const IconThemeData(size: 26),
            unselectedIconTheme: const IconThemeData(size: 24),
            selectedItemColor: theme.primaryColor,
            unselectedItemColor: theme.textTheme.bodyMedium?.color,
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
                theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
