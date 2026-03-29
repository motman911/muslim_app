import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/noor_card.dart';

class DhikrCard extends StatefulWidget {
  const DhikrCard({
    super.key,
    required this.text,
    required this.source,
    required this.total,
  });

  final String text;
  final String source;
  final int total;

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final done = _current >= widget.total;

    return NoorCard(
      margin: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: done ? AppColors.greenSubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text('${_current.clamp(0, widget.total)} من ${widget.total}',
                style: AppTextStyles.caption),
            const SizedBox(height: 10),
            Text(widget.text,
                style: AppTextStyles.quranNormal, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('[${widget.source}]', style: AppTextStyles.tiny),
            const SizedBox(height: 12),
            SizedBox(
              width: 80,
              height: 80,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.goldLight, AppColors.goldPrimary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: IconButton(
                  onPressed: done
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _current += 1;
                          });
                        },
                  icon: Text(
                    '${_current.clamp(0, widget.total)}/${widget.total}',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.darkBg),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
