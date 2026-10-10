import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../rewards/domain/reward.dart';
import '../../../rewards/presentaion/widgets/badge_medal.dart';
import '../../domain/habit_tracker.dart';
import '../../domain/motivation_messages.dart';

class CheckInSheet extends StatefulWidget {
  const CheckInSheet({
    super.key,
    required this.tracker,
    required this.day,
    required this.onAnswer,
  });

  final HabitTracker tracker;
  final int day;
  final Future<Reward?> Function(bool success) onAnswer;

  @override
  State<CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<CheckInSheet> {
  bool? _result;
  Reward? _earned;
  String _message = '';
  bool _busy = false;

  Future<void> _answer(bool success) async {
    if (_busy) return;
    setState(() => _busy = true);
    final earned = await widget.onAnswer(success);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _result = success;
      _earned = earned;
      _message = motivationFor(
        mode: widget.tracker.mode,
        success: success,
        day: widget.day,
        totalDays: widget.tracker.totalDays,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _result == null
                    ? _buildQuestion(context)
                    : _buildResult(context, _result!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final tracker = widget.tracker;
    final mode = tracker.mode;
    final palette = context.palette;
    return Column(
      key: const ValueKey('question'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'DAY ${widget.day} OF ${tracker.totalDays}',
          style: TextStyle(
            color: palette.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          mode.question(tracker.name),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: palette.ink,
            fontSize: 22,
            height: 1.25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 26),
        FilledButton(
          onPressed: _busy ? null : () => _answer(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
          ),
          child: Text(mode.successLabel),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: _busy ? null : () => _answer(false),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: AppColors.danger,
            side: BorderSide(color: palette.dangerSoft, width: 2),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(mode.failLabel),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context, bool success) {
    final earned = _earned;
    final palette = context.palette;
    return Column(
      key: const ValueKey('result'),
      mainAxisSize: MainAxisSize.min,
      children: [
        if (earned != null)
          BadgeMedal(tier: earned.tier, size: 88)
        else
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: success ? palette.leafSoft : palette.dangerSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              success ? Icons.check_rounded : Icons.favorite_rounded,
              size: 32,
              color: success ? AppColors.success : AppColors.danger,
            ),
          ),
        const SizedBox(height: 16),
        Text(
          earned != null
              ? 'Badge unlocked!'
              : success
              ? 'Day ${widget.day} complete'
              : 'Tomorrow is a fresh start',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: palette.ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (earned != null) ...[
          const SizedBox(height: 4),
          Text(
            earned.tier.title,
            style: TextStyle(
              color: palette.leaf,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          _message,
          textAlign: TextAlign.center,
          style: TextStyle(color: palette.muted, fontSize: 14, height: 1.45),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            if (earned == null) {
              Navigator.of(context).pop();
              return;
            }
            final router = GoRouter.of(context);
            Navigator.of(context).pop();
            router.push('/rewards');
          },
          child: Text(earned == null ? 'Continue' : 'View my rewards'),
        ),
        if (earned != null) ...[
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
        ],
      ],
    );
  }
}
