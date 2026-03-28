import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/providers/app_settings_providers.dart';
import '../../../../shared/providers/firebase_providers.dart';
import '../../../../shared/widgets/noor_button.dart';
import '../../../../shared/widgets/noor_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final authState = ref.watch(authStateProvider);
    final authAction = ref.watch(authActionControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.tr('account'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          NoorCard(
            child: authState.when(
              data: (user) {
                final email = user?.email;
                final isAnonymous = user?.isAnonymous ?? true;
                final label = email ?? l10n.tr('anonymousUser');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${l10n.tr('signedInAs')}: $label'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
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
                        padding: const EdgeInsets.only(top: 8),
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
          const SizedBox(height: 24),
          Text(l10n.tr('theme'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
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
          const SizedBox(height: 24),
          Text(l10n.tr('language'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: locale.languageCode,
            decoration: const InputDecoration(border: OutlineInputBorder()),
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
              const SizedBox(height: 8),
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
              child: const Text('Cancel'),
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
}
