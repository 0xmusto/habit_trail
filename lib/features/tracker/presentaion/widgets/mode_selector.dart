import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/habit_mode.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key, required this.value, required this.onChanged});

  final HabitMode value;
  final ValueChanged<HabitMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final mode in HabitMode.values) ...[
          Expanded(
            child: _ModeCard(
              mode: mode,
              selected: mode == value,
              onTap: () => onChanged(mode),
            ),
          ),
          if (mode != HabitMode.values.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final HabitMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final icon = mode == HabitMode.doHabit
        ? Icons.trending_up_rounded
        : Icons.block_rounded;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? palette.inkSurface : palette.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? palette.inkSurface : palette.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.14)
                      : palette.leafSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: selected ? AppColors.lime : palette.leaf,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                mode.title,
                style: TextStyle(
                  color: selected ? Colors.white : palette.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                mode.subtitle,
                style: TextStyle(
                  color: selected ? const Color(0xFFB9D4C8) : palette.muted,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
