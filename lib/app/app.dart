import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/app/router.dart';
import 'package:habit_tracker/core/theme/app_theme.dart';
import 'package:habit_tracker/core/theme/theme_controller.dart';
import 'package:habit_tracker/features/tracker/presentaion/controllers/tracker_controller.dart';

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final TrackerController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return TrackerScope(
      controller: controller,
      child: ThemeScope(
        controller: themeController,
        child: ListenableBuilder(
          listenable: themeController,
          builder: (context, _) => MaterialApp.router(
            title: 'Habit Trail',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeController.mode,
            routerConfig: appRouter,
            builder: (context, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: isDark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
                child: child!,
              );
            },
          ),
        ),
      ),
    );
  }
}
