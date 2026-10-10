import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class EmptyHabitsCard extends StatelessWidget {
  const EmptyHabitsCard({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: palette.leafSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.spa_rounded, color: palette.leaf, size: 27),
          ),
          const SizedBox(height: 15),
          Text(
            'A fresh start',
            style: TextStyle(
              color: palette.ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Build a habit or quit one, and get a daily\nreminder to check in.',
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.muted, fontSize: 13, height: 1.45),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('Create your first habit'),
          ),
        ],
      ),
    );
  }
}
