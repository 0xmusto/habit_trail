import 'package:flutter/material.dart';

import '../../domain/badge_tier.dart';

extension BadgeTierStyle on BadgeTier {
  Color get color => switch (this) {
    BadgeTier.starter => const Color(0xFFCD7F32),
    BadgeTier.steady => const Color(0xFF8E9BAA),
    BadgeTier.committed => const Color(0xFFE9A23B),
    BadgeTier.unstoppable => const Color(0xFF2E9E6B),
    BadgeTier.legend => const Color(0xFF7C5CFC),
  };

  IconData get icon => switch (this) {
    BadgeTier.starter => Icons.eco_rounded,
    BadgeTier.steady => Icons.bolt_rounded,
    BadgeTier.committed => Icons.local_fire_department_rounded,
    BadgeTier.unstoppable => Icons.workspace_premium_rounded,
    BadgeTier.legend => Icons.diamond_rounded,
  };
}
