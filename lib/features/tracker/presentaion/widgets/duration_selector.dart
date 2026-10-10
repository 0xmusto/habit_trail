import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class DurationSelector extends StatelessWidget {
  const DurationSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const options = [7, 15, 30, 60, 90];

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final days in options)
          ChoiceChip(
            label: Text('$days days'),
            selected: days == value,
            showCheckmark: false,
            onSelected: (_) => onChanged(days),
            backgroundColor: palette.surface,
            selectedColor: palette.inkSurface,
            side: BorderSide(
              color: days == value ? palette.inkSurface : palette.border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            labelStyle: TextStyle(
              color: days == value ? Colors.white : palette.ink,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
      ],
    );
  }
}
