import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/badge_tier.dart';
import 'badge_style.dart';

class BadgeMedal extends StatelessWidget {
  const BadgeMedal({
    super.key,
    required this.tier,
    this.size = 64,
    this.locked = false,
  });

  final BadgeTier tier;
  final double size;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final color = tier.color;
    final palette = context.palette;
    return Semantics(
      label: locked ? '${tier.title}, locked' : tier.title,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: locked
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, Color.lerp(color, Colors.black, 0.28)!],
                ),
          color: locked ? palette.locked : null,
          border: Border.all(
            color: locked ? palette.border : Colors.white,
            width: size * 0.06,
          ),
          boxShadow: locked
              ? null
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: size * 0.25,
                    offset: Offset(0, size * 0.08),
                  ),
                ],
        ),
        child: Icon(
          locked ? Icons.lock_rounded : tier.icon,
          size: size * 0.46,
          color: locked ? palette.muted : Colors.white,
        ),
      ),
    );
  }
}
