import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/habit_tracker.dart';

class DayNode extends StatelessWidget {
  const DayNode({
    super.key,
    required this.day,
    required this.state,
    required this.size,
    this.onTap,
  });

  final int day;
  final DayState state;
  final double size;
  final VoidCallback? onTap;

  Widget _number(Color color) => Text(
    '$day',
    style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.w800),
  );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (Color fill, Color? border, Widget content) = switch (state) {
      DayState.success => (
        AppColors.success,
        null,
        const Icon(Icons.check_rounded, color: Colors.white, size: 28),
      ),
      DayState.failed => (
        AppColors.danger,
        null,
        const Icon(Icons.close_rounded, color: Colors.white, size: 26),
      ),
      DayState.today => (
        palette.surface,
        palette.emphasis,
        _number(palette.emphasis),
      ),
      DayState.pending => (
        palette.surface,
        AppColors.amber,
        _number(AppColors.amber),
      ),
      DayState.locked => (palette.locked, null, _number(palette.muted)),
    };

    final node = Material(
      color: fill,
      elevation: state == DayState.today ? 4 : 0,
      shape: CircleBorder(
        side: border == null
            ? BorderSide.none
            : BorderSide(color: border, width: 3),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Center(child: content),
      ),
    );

    return Semantics(
      label: 'Day $day, ${state.name}',
      button: onTap != null,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (state == DayState.today)
              Positioned.fill(child: _PulseRing(color: palette.emphasis)),
            Positioned.fill(child: node),
          ],
        ),
      ),
    );
  }
}

class _PulseRing extends StatefulWidget {
  const _PulseRing({required this.color});

  final Color color;

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeOut.transform(_controller.value);
          return Transform.scale(
            scale: 1 + 0.45 * t,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.35 * (1 - t)),
                  width: 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
