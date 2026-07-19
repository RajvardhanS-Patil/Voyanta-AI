import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/app_router.dart';

import 'package:voyanta_ai/core/theme/app_theme.dart';
import 'package:voyanta_ai/core/theme/theme_provider.dart';

class VoyantaApp extends ConsumerWidget {
  const VoyantaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Voyanta AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.stitchLightTheme,
      darkTheme: AppTheme.stitchDarkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
