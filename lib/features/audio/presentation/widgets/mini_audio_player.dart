import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class MiniAudioPlayer extends StatelessWidget {
  const MiniAudioPlayer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPlayPause,
    required this.onClose,
    required this.isPlaying,
    this.progress = 0,
  });

  final String title;
  final String subtitle;
  final VoidCallback onPlayPause;
  final VoidCallback onClose;
  final bool isPlaying;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 40.w,
                height: 40.w,
                color: AppColors.darkSurface,
                child: const Icon(Icons.music_note_rounded),
              ),
            ),
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle:
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onPlayPause,
                  icon: Icon(isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            minHeight: 2.h,
            value: progress.clamp(0, 1),
            color: AppColors.goldPrimary,
            backgroundColor: AppColors.darkBgElevated,
          ),
        ],
      ),
    );
  }
}
