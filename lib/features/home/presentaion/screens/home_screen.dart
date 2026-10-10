import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../tracker/presentaion/controllers/tracker_controller.dart';
import '../widgets/empty_habits_card.dart';
import '../widgets/habit_card.dart';
import '../widgets/home_header.dart';
import '../widgets/routine_summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TrackerScope.of(context);
    final palette = context.palette;
    final trackers = controller.trackers;
    final now = DateTime.now();
    final dueToday = trackers
        .where((t) => t.isActive(now) && !t.isCheckedIn(now))
        .length;

    return Scaffold(
      floatingActionButton: trackers.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push('/create'),
              backgroundColor: palette.inkSurface,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New habit'),
            ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(
                    rewardCount: controller.rewards.length,
                    onRewardsTap: () => context.push('/rewards'),
                    onThemeTap: () =>
                        ThemeScope.read(context)
                            .toggle(Theme.of(context).brightness),
                  ),
                  const SizedBox(height: 26),
                  RoutineSummaryCard(
                    habitCount: trackers.length,
                    dueToday: dueToday,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Your habits',
                        style: TextStyle(
                          color: palette.ink,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        trackers.isEmpty
                            ? 'GET STARTED'
                            : '${trackers.length} TOTAL',
                        style: TextStyle(
                          color: palette.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            Expanded(
              child: trackers.isEmpty
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: EmptyHabitsCard(
                        onCreate: () => context.push('/create'),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 96),
                      itemCount: trackers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final tracker = trackers[index];
                        return HabitCard(
                          tracker: tracker,
                          onTap: () => context.push('/tracker/${tracker.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
