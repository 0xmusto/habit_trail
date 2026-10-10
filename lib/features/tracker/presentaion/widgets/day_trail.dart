import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/habit_tracker.dart';
import 'day_node.dart';
import 'trail_painter.dart';

/// A winding path that starts at the bottom (day 1) and climbs up to the goal.
class DayTrail extends StatefulWidget {
  const DayTrail({
    super.key,
    required this.tracker,
    required this.now,
    required this.onDayTap,
  });

  final HabitTracker tracker;
  final DateTime now;
  final ValueChanged<int> onDayTap;

  @override
  State<DayTrail> createState() => _DayTrailState();
}

class _DayTrailState extends State<DayTrail> {
  static const _rowHeight = 96.0;
  static const _nodeSize = 54.0;
  static const _topPad = 130.0;
  static const _bottomPad = 64.0;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToToday());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The scroll view is reversed, so offset 0 is the bottom of the trail.
  void _jumpToToday() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    final day = widget.tracker.currentDay(widget.now);
    final target =
        _bottomPad + (day - 0.5) * _rowHeight - position.viewportDimension / 2;
    _controller.jumpTo(target.clamp(0.0, position.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    final tracker = widget.tracker;
    final days = tracker.totalDays;
    final height = _topPad + days * _rowHeight + _bottomPad;

    return SingleChildScrollView(
      reverse: true,
      controller: _controller,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final amplitude = math.max(0.0, (width - _nodeSize) / 2 - 28);
          final points = <Offset>[
            for (var d = 1; d <= days; d++)
              Offset(
                width / 2 + math.sin((d - 1) * 0.9) * amplitude,
                height - _bottomPad - (d - 0.5) * _rowHeight,
              ),
            Offset(width / 2, 52),
          ];
          final walked = <bool>[
            for (var d = 1; d <= days; d++) tracker.results.containsKey(d),
          ];

          return SizedBox(
            height: height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: TrailPainter(
                      points: points,
                      walked: walked,
                      baseColor: context.palette.locked,
                      walkedColor: AppColors.success,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: _GoalMarker(days: days, reached: tracker.isCompleted),
                ),
                for (var d = 1; d <= days; d++)
                  Positioned(
                    left: points[d - 1].dx - _nodeSize / 2,
                    top: points[d - 1].dy - _nodeSize / 2,
                    child: _buildNode(d),
                  ),
                Positioned(
                  bottom: 14,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'START HERE',
                      style: TextStyle(
                        color: context.palette.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNode(int day) {
    final state = widget.tracker.dayState(day, widget.now);
    final tappable = state == DayState.today || state == DayState.pending;
    return DayNode(
      day: day,
      state: state,
      size: _nodeSize,
      onTap: tappable ? () => widget.onDayTap(day) : null,
    );
  }
}

class _GoalMarker extends StatelessWidget {
  const _GoalMarker({required this.days, required this.reached});

  final int days;
  final bool reached;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: reached ? AppColors.lime : palette.leafSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.emoji_events_rounded,
            size: 32,
            color: reached ? AppColors.ink : palette.leaf,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          reached ? 'GOAL REACHED' : '$days DAY GOAL',
          style: TextStyle(
            color: palette.ink,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
