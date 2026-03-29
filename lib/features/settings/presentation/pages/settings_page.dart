import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/providers/app_settings_providers.dart';
import '../../../../shared/providers/firebase_providers.dart';
import '../../../../shared/widgets/noor_button.dart';
import '../../../../shared/widgets/noor_card.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _checkedAutoGuide = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowAccessibilityGuideOnFirstOpen();
    });
  }

  Future<void> _maybeShowAccessibilityGuideOnFirstOpen() async {
    if (!mounted || _checkedAutoGuide) {
      return;
    }

    _checkedAutoGuide = true;
    final hasShown = ref.read(accessibilityGuideShownControllerProvider);
    final isDisabled = ref.read(accessibilityGuideDisabledControllerProvider);
    if (hasShown || isDisabled) {
      return;
    }

    await _showAccessibilityGuide(context: context, ref: ref, isAutoOpen: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final textScale = ref.watch(textScaleControllerProvider);
    final lineHeight = ref.watch(lineHeightControllerProvider);
    final highContrast = ref.watch(highContrastControllerProvider);
    final authState = ref.watch(authStateProvider);
    final authAction = ref.watch(authActionControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('settings'))),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: [
          NoorCard(
            margin: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.goldSubtle,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppColors.goldPrimary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.tr('settings'),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        l10n.tr('accessibilityGuideSubtitle'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showAccessibilityGuide(
                      context: context,
                      ref: ref,
                      isAutoOpen: false,
                    );
                  },
                  icon: Icon(Icons.help_outline_rounded, size: 20.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 8.w;
              final cardWidth = (constraints.maxWidth - spacing * 2) / 3;
              final compact = cardWidth < 110.w;

              return Wrap(
                spacing: spacing,
                runSpacing: 8.h,
                children: [
                  SizedBox(
                    width: compact
                        ? (constraints.maxWidth - spacing) / 2
                        : cardWidth,
                    child: _SettingStatCard(
                      label: l10n.tr('textSize'),
                      value: textScale.toStringAsFixed(2),
                      icon: Icons.text_fields_rounded,
                    ),
                  ),
                  SizedBox(
                    width: compact
                        ? (constraints.maxWidth - spacing) / 2
                        : cardWidth,
                    child: _SettingStatCard(
                      label: l10n.tr('lineHeight'),
                      value: lineHeight.toStringAsFixed(1),
                      icon: Icons.format_line_spacing_rounded,
                    ),
                  ),
                  SizedBox(
                    width: compact
                        ? (constraints.maxWidth - spacing) / 2
                        : cardWidth,
                    child: _SettingStatCard(
                      label: l10n.tr('highContrast'),
                      value: highContrast
                          ? l10n.tr('highContrastEnabled')
                          : l10n.tr('highContrastDisabled'),
                      icon: Icons.contrast_rounded,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 16.h),
          _sectionTitle(
            context,
            title: l10n.tr('account'),
            icon: Icons.person_rounded,
          ),
          SizedBox(height: 8.h),
          NoorCard(
            margin: EdgeInsets.zero,
            child: authState.when(
              data: (user) {
                final email = user?.email;
                final isAnonymous = user?.isAnonymous ?? true;
                final label = email ?? l10n.tr('anonymousUser');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${l10n.tr('signedInAs')}: $label'),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        NoorButton(
                          style: NoorButtonStyle.primary,
                          label: l10n.tr('signInGoogle'),
                          onPressed: authAction.isLoading
                              ? null
                              : () {
                                  ref
                                      .read(
                                          authActionControllerProvider.notifier)
                                      .signInWithGoogle();
                                },
                        ),
                        NoorButton(
                          style: NoorButtonStyle.secondary,
                          label: l10n.tr('signInApple'),
                          onPressed: authAction.isLoading
                              ? null
                              : () {
                                  ref
                                      .read(
                                          authActionControllerProvider.notifier)
                                      .signInWithApple();
                                },
                        ),
                        NoorButton(
                          style: NoorButtonStyle.secondary,
                          label: l10n.tr('signInEmail'),
                          onPressed: authAction.isLoading
                              ? null
                              : () {
                                  _showEmailAuthDialog(
                                    context: context,
                                    ref: ref,
                                    isSignUp: false,
                                  );
                                },
                        ),
                        NoorButton(
                          style: NoorButtonStyle.secondary,
                          label: l10n.tr('createAccountEmail'),
                          onPressed: authAction.isLoading
                              ? null
                              : () {
                                  _showEmailAuthDialog(
                                    context: context,
                                    ref: ref,
                                    isSignUp: true,
                                  );
                                },
                        ),
                        if (!isAnonymous)
                          NoorButton(
                            style: NoorButtonStyle.ghost,
                            label: l10n.tr('signOut'),
                            onPressed: authAction.isLoading
                                ? null
                                : () {
                                    ref
                                        .read(authActionControllerProvider
                                            .notifier)
                                        .signOutAndFallbackAnonymous();
                                  },
                          ),
                      ],
                    ),
                    if (authAction.hasError)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          authAction.error.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text(error.toString()),
            ),
          ),
          SizedBox(height: 16.h),
          _sectionTitle(
            context,
            title: l10n.tr('theme'),
            icon: Icons.palette_rounded,
          ),
          SizedBox(height: 8.h),
          NoorCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.tr('theme'),
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8.h),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(l10n.tr('system')),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(l10n.tr('light')),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(l10n.tr('dark')),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selected) {
                    ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(selected.first);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _sectionTitle(
            context,
            title: l10n.tr('readingSettings'),
            icon: Icons.menu_book_rounded,
          ),
          SizedBox(height: 8.h),
          NoorCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(l10n.tr('lineHeight'),
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(width: 6.w),
                    Tooltip(
                      message: l10n.tr('tooltipLineHeight'),
                      child: Icon(Icons.info_outline_rounded, size: 18.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(l10n.tr('lineHeightCompact')),
                    Expanded(
                      child: Slider(
                        min: 1.2,
                        max: 2.0,
                        divisions: 4,
                        value: lineHeight,
                        label: lineHeight.toStringAsFixed(1),
                        onChanged: (value) {
                          ref
                              .read(lineHeightControllerProvider.notifier)
                              .setHeight(value);
                        },
                      ),
                    ),
                    Text(l10n.tr('lineHeightRelaxed')),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(l10n.tr('textSize'),
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(width: 6.w),
                    Tooltip(
                      message: l10n.tr('tooltipTextSize'),
                      child: Icon(Icons.info_outline_rounded, size: 18.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(l10n.tr('textSizeSmall')),
                    Expanded(
                      child: Slider(
                        min: 0.9,
                        max: 1.3,
                        divisions: 4,
                        value: textScale,
                        label: textScale.toStringAsFixed(2),
                        onChanged: (value) {
                          ref
                              .read(textScaleControllerProvider.notifier)
                              .setScale(value);
                        },
                      ),
                    ),
                    Text(l10n.tr('textSizeLarge')),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          NoorCard(
            margin: EdgeInsets.zero,
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(l10n.tr('highContrast')),
                  SizedBox(width: 6.w),
                  Tooltip(
                    message: l10n.tr('tooltipHighContrast'),
                    child: Icon(Icons.info_outline_rounded, size: 18.sp),
                  ),
                ],
              ),
              subtitle: Text(
                highContrast
                    ? l10n.tr('highContrastEnabled')
                    : l10n.tr('highContrastDisabled'),
              ),
              value: highContrast,
              onChanged: (value) {
                ref
                    .read(highContrastControllerProvider.notifier)
                    .setEnabled(value);
              },
            ),
          ),
          SizedBox(height: 12.h),
          _sectionTitle(
            context,
            title: l10n.tr('accessibilityPresets'),
            icon: Icons.auto_awesome_rounded,
          ),
          SizedBox(height: 8.h),
          NoorCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر النمط المناسب لطريقة قراءتك',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    NoorButton(
                      style: NoorButtonStyle.primary,
                      label: l10n.tr('presetRecommended'),
                      onPressed: () {
                        _applyLanguageRecommendedPreset(
                          ref,
                          localeCode: locale.languageCode,
                        );
                      },
                    ),
                    NoorButton(
                      style: NoorButtonStyle.secondary,
                      label: l10n.tr('presetBalanced'),
                      onPressed: () {
                        _applyAccessibilityPreset(
                          ref,
                          textScale: 1.0,
                          lineHeight: 1.5,
                          highContrast: false,
                        );
                      },
                    ),
                    NoorButton(
                      style: NoorButtonStyle.secondary,
                      label: l10n.tr('presetComfort'),
                      onPressed: () {
                        _applyAccessibilityPreset(
                          ref,
                          textScale: 1.2,
                          lineHeight: 1.8,
                          highContrast: true,
                        );
                      },
                    ),
                    NoorButton(
                      style: NoorButtonStyle.secondary,
                      label: l10n.tr('presetCompact'),
                      onPressed: () {
                        _applyAccessibilityPreset(
                          ref,
                          textScale: 0.95,
                          lineHeight: 1.3,
                          highContrast: false,
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      _resetAccessibility(ref);
                    },
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text(l10n.tr('resetAccessibility')),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _sectionTitle(
            context,
            title: l10n.tr('preview'),
            icon: Icons.visibility_rounded,
          ),
          SizedBox(height: 8.h),
          NoorCard(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.menu_book_rounded, size: 22.sp),
              title: Text(l10n.tr('accessibilityGuide')),
              subtitle: Text(l10n.tr('accessibilityGuideSubtitle')),
              trailing: Icon(Icons.chevron_right_rounded, size: 20.sp),
              onTap: () {
                _showAccessibilityGuide(
                  context: context,
                  ref: ref,
                  isAutoOpen: false,
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          NoorCard(
            margin: EdgeInsets.zero,
            highlight: highContrast,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.tr('preview'),
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8.h),
                Text(
                  l10n.tr('previewBody'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Chip(
                      label: Text(
                          '${l10n.tr('textSize')}: ${textScale.toStringAsFixed(2)}'),
                    ),
                    SizedBox(width: 8.w),
                    Chip(
                      label: Text(
                          '${l10n.tr('lineHeight')}: ${lineHeight.toStringAsFixed(1)}'),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  highContrast
                      ? l10n.tr('highContrastEnabled')
                      : l10n.tr('highContrastDisabled'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: highContrast
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _sectionTitle(
            context,
            title: l10n.tr('language'),
            icon: Icons.language_rounded,
          ),
          SizedBox(height: 8.h),
          NoorCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.tr('language'),
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  initialValue: locale.languageCode,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'fr', child: Text('Francais')),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(Locale(value));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.goldPrimary),
        SizedBox(width: 6.w),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Future<void> _showEmailAuthDialog({
    required BuildContext context,
    required WidgetRef ref,
    required bool isSignUp,
  }) async {
    final l10n = context.l10n;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isSignUp ? l10n.tr('createAccountEmail') : l10n.tr('signInEmail'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: l10n.tr('email')),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: l10n.tr('password')),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.tr('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text;

                if (email.isEmpty || password.length < 6) {
                  return;
                }

                final controller =
                    ref.read(authActionControllerProvider.notifier);
                if (isSignUp) {
                  await controller.signUpWithEmail(
                    email: email,
                    password: password,
                  );
                } else {
                  await controller.signInWithEmail(
                    email: email,
                    password: password,
                  );
                }

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(l10n.tr('continue')),
            ),
          ],
        );
      },
    );

    emailController.dispose();
    passwordController.dispose();
  }

  void _applyAccessibilityPreset(
    WidgetRef ref, {
    required double textScale,
    required double lineHeight,
    required bool highContrast,
  }) {
    ref.read(textScaleControllerProvider.notifier).setScale(textScale);
    ref.read(lineHeightControllerProvider.notifier).setHeight(lineHeight);
    ref.read(highContrastControllerProvider.notifier).setEnabled(highContrast);
  }

  void _resetAccessibility(WidgetRef ref) {
    _applyAccessibilityPreset(
      ref,
      textScale: 1.0,
      lineHeight: 1.5,
      highContrast: false,
    );
  }

  void _applyLanguageRecommendedPreset(
    WidgetRef ref, {
    required String localeCode,
  }) {
    switch (localeCode) {
      case 'ar':
        _applyAccessibilityPreset(
          ref,
          textScale: 1.15,
          lineHeight: 1.8,
          highContrast: true,
        );
      case 'fr':
        _applyAccessibilityPreset(
          ref,
          textScale: 1.05,
          lineHeight: 1.6,
          highContrast: false,
        );
      default:
        _applyAccessibilityPreset(
          ref,
          textScale: 1.0,
          lineHeight: 1.5,
          highContrast: false,
        );
    }
  }

  Future<void> _showAccessibilityGuide({
    required BuildContext context,
    required WidgetRef ref,
    required bool isAutoOpen,
  }) async {
    final l10n = context.l10n;

    final steps = [
      (
        title: l10n.tr('guideStepDisplayTitle'),
        body: l10n.tr('guideStepDisplayBody'),
      ),
      (
        title: l10n.tr('guideStepReadabilityTitle'),
        body: l10n.tr('guideStepReadabilityBody'),
      ),
      (
        title: l10n.tr('guideStepContrastTitle'),
        body: l10n.tr('guideStepContrastBody'),
      ),
    ];

    int currentStep = 0;
    bool disableGuidePrompts = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final step = steps[currentStep];
            final isFirst = currentStep == 0;
            final isLast = currentStep == steps.length - 1;

            return AlertDialog(
              title: Text(l10n.tr('accessibilityGuide')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.tr('step')} ${currentStep + 1}/${steps.length}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  Text(step.body),
                  SizedBox(height: 10.h),
                  CheckboxListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: disableGuidePrompts,
                    onChanged: (value) {
                      setState(() {
                        disableGuidePrompts = value ?? false;
                      });
                    },
                    title: Text(l10n.tr('dontShowGuideAgain')),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isFirst
                      ? null
                      : () {
                          setState(() {
                            currentStep -= 1;
                          });
                        },
                  child: Text(l10n.tr('previous')),
                ),
                if (isLast)
                  TextButton(
                    onPressed: () {
                      final localeCode =
                          ref.read(localeControllerProvider).languageCode;
                      _applyLanguageRecommendedPreset(
                        ref,
                        localeCode: localeCode,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(l10n.tr('applyRecommendedNow')),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (isLast) {
                      Navigator.of(context).pop();
                      return;
                    }
                    setState(() {
                      currentStep += 1;
                    });
                  },
                  child: Text(isLast ? l10n.tr('done') : l10n.tr('continue')),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (isAutoOpen) {
      await ref
          .read(accessibilityGuideShownControllerProvider.notifier)
          .markShown();
    }

    if (disableGuidePrompts) {
      await ref
          .read(accessibilityGuideDisabledControllerProvider.notifier)
          .setDisabled(true);
    }
  }
}

class _SettingStatCard extends StatelessWidget {
  const _SettingStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.darkBgSecondary, AppColors.darkBgElevated],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderActive, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.goldPrimary),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: 4.h),
          Container(
            width: 18.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: AppColors.goldPrimary.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(99.r),
            ),
          ),
        ],
      ),
    );
  }
}
