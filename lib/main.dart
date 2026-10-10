import 'package:flutter/material.dart';
import 'package:habit_tracker/app/app.dart';
import 'package:habit_tracker/app/router.dart';
import 'package:habit_tracker/core/home_widget/home_widget_service.dart';
import 'package:habit_tracker/core/notifications/notification_service.dart';
import 'package:habit_tracker/core/theme/theme_controller.dart';
import 'package:habit_tracker/features/tracker/data/tracker_repository.dart';
import 'package:habit_tracker/features/tracker/presentaion/controllers/tracker_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifications = NotificationService();
  await notifications.init(
    onOpenTracker: (id) => appRouter.push('/tracker/$id'),
  );

  final controller = TrackerController(
    repository: TrackerRepository(),
    notifications: notifications,
  );
  await controller.load();

  final themeController = ThemeController();
  await themeController.load();

  runApp(
    HabitTrackerApp(controller: controller, themeController: themeController),
  );

  HomeWidgetService.listenForTaps(
    (id) => WidgetsBinding.instance.addPostFrameCallback(
      (_) => appRouter.push('/tracker/$id'),
    ),
  );

  // Android 13+ only shows the system prompt if it has not been permanently denied.
  await notifications.requestPermission();
}
