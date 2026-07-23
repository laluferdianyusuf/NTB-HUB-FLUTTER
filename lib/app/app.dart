import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ntbhub_flutter/core/theme/app_theme.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/theme_provider.dart';
import '../features/users/auth/presentation/providers/auth_provider.dart';
import 'router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sessionBootstrapProvider);
    final themeState = ref.watch(appThemeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      routerConfig: appRouter,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeState.themeMode,
    );
  }
}
