import 'package:flutter/material.dart';
import 'package:muslim_app/core/constants/color_scheme.dart';
import 'package:muslim_app/presentation/screens/quran_screen.dart';
import 'package:muslim_app/presentation/screens/adhkar_screen.dart';
import 'package:muslim_app/presentation/screens/audio_screen.dart';
import 'package:muslim_app/presentation/screens/prayer_times_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اكتشف تطبيقك الإسلامي اليوم!',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                _buildFeatureGrid(theme),
                const SizedBox(height: 24),
                _buildPrayerReminderCard(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(ThemeData theme) {
    final features = [
      {
        'title': 'القرآن الكريم',
        'icon': Icons.book_outlined,
        'gradient': AppGradients.primaryGradient,
        'screen': const QuranScreen(),
      },
      {
        'title': 'الأذكار',
        'icon': Icons.favorite_outline,
        'gradient': AppGradients.secondaryGradient,
        'screen': const AdhkarScreen(),
      },
      {
        'title': 'التلاوات',
        'icon': Icons.audiotrack_outlined,
        'gradient': LinearGradient(
          colors: [AppColors.primaryYellow, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'screen': const AudioScreen(),
      },
      {
        'title': 'مواقيت الصلاة',
        'icon': Icons.access_time_outlined,
        'gradient': const LinearGradient(
          colors: [Colors.teal, Colors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'screen': const PrayerTimesScreen(),
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final feature = features[index];
        return GestureDetector(
          onTap: () => _navigateTo(feature['screen'] as Widget),
          child: Container(
            decoration: BoxDecoration(
              gradient: feature['gradient'] as Gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  feature['icon'] as IconData,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

  Widget _buildPrayerReminderCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.primaryYellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تذكير الصلاة القادمة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الفجر',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                '05:30',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.3,
            backgroundColor: Colors.white24,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
