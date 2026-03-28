import 'package:flutter/material.dart';

import 'adhkar_screen.dart';
import 'audio_screen.dart';
import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'quran_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  static const _pages = <Widget>[
    QuranScreen(),
    PrayerTimesScreen(),
    AdhkarScreen(),
    QiblaScreen(),
    AudioScreen(),
  ];

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.menu_book_rounded),
      label: 'Quran',
    ),
    NavigationDestination(
      icon: Icon(Icons.access_time_filled_rounded),
      label: 'Prayer',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_rounded),
      label: 'Azkar',
    ),
    NavigationDestination(
      icon: Icon(Icons.explore_rounded),
      label: 'Qibla',
    ),
    NavigationDestination(
      icon: Icon(Icons.graphic_eq_rounded),
      label: 'Audio',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }
}
