import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PrayerHeroCard extends StatefulWidget {
  const PrayerHeroCard({super.key});

  @override
  State<PrayerHeroCard> createState() => _PrayerHeroCardState();
}

class _PrayerHeroCardState extends State<PrayerHeroCard> {
  static const List<_PrayerSlot> _slots = [
    _PrayerSlot(name: 'الفجر', hour: 5, minute: 0),
    _PrayerSlot(name: 'الظهر', hour: 12, minute: 20),
    _PrayerSlot(name: 'العصر', hour: 15, minute: 45),
    _PrayerSlot(name: 'المغرب', hour: 18, minute: 30),
    _PrayerSlot(name: 'العشاء', hour: 20, minute: 0),
  ];

  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _resolveCurrentWindow(_now);
    final nextPrayer = current.next;
    final remaining = nextPrayer.time.difference(_now);

    return Container(
      constraints: BoxConstraints(minHeight: 220.h),
      decoration: BoxDecoration(
        color: AppColors.darkBgElevated,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.borderActive, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldPrimary.withValues(alpha: 0.08),
            blurRadius: 20.r,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الصلاة القادمة', style: AppTextStyles.caption),
            SizedBox(height: 4.h),
            Text(nextPrayer.slot.name, style: AppTextStyles.h1),
            Text(
              _formatTime(nextPrayer.time),
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textGold),
            ),
            SizedBox(height: 8.h),
            Text(_formatRemaining(remaining), style: AppTextStyles.h2),
            SizedBox(height: 10.h),
            LinearProgressIndicator(
              minHeight: 4.h,
              value: current.progress,
              borderRadius: BorderRadius.circular(99.r),
              color: AppColors.goldPrimary,
              backgroundColor: AppColors.darkSurface,
            ),
            SizedBox(height: 10.h),
            Row(
              children: _slots.map((slot) {
                final slotTime = _toToday(slot);
                final isPast = slotTime.isBefore(_now);
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        slot.name,
                        style: AppTextStyles.tiny.copyWith(
                          color: isPast
                              ? AppColors.textMuted
                              : AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _formatTime(slotTime),
                        style: AppTextStyles.tiny.copyWith(
                          color: isPast
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Icon(
                        isPast ? Icons.check_circle : Icons.circle_outlined,
                        size: 14.sp,
                        color: isPast
                            ? AppColors.greenPrimary
                            : AppColors.textMuted,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  _WindowState _resolveCurrentWindow(DateTime now) {
    final todaySlots = _slots.map(_toToday).toList();

    for (var i = 0; i < todaySlots.length; i++) {
      final current = todaySlots[i];
      final next = i == todaySlots.length - 1
          ? todaySlots.first.add(const Duration(days: 1))
          : todaySlots[i + 1];
      if (now.isBefore(next)) {
        final total = next.difference(current).inSeconds;
        final spent = now.difference(current).inSeconds.clamp(0, total);
        final progress = total == 0 ? 0.0 : spent / total;
        return _WindowState(
          next: _PrayerPoint(slot: _slots[(i + 1) % _slots.length], time: next),
          progress: progress.clamp(0, 1),
        );
      }
    }

    return _WindowState(
      next: _PrayerPoint(
          slot: _slots.first,
          time: todaySlots.first.add(const Duration(days: 1))),
      progress: 0,
    );
  }

  DateTime _toToday(_PrayerSlot slot) {
    return DateTime(_now.year, _now.month, _now.day, slot.hour, slot.minute);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatRemaining(Duration duration) {
    if (duration.isNegative) {
      return '00:00:00';
    }
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _PrayerSlot {
  const _PrayerSlot(
      {required this.name, required this.hour, required this.minute});

  final String name;
  final int hour;
  final int minute;
}

class _PrayerPoint {
  const _PrayerPoint({required this.slot, required this.time});

  final _PrayerSlot slot;
  final DateTime time;
}

class _WindowState {
  const _WindowState({required this.next, required this.progress});

  final _PrayerPoint next;
  final double progress;
}
