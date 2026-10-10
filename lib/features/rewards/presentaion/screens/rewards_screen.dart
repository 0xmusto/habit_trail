import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../tracker/presentaion/controllers/tracker_controller.dart';
import '../../domain/badge_tier.dart';
import '../widgets/badge_tier_card.dart';
import '../widgets/earned_reward_tile.dart';
import '../widgets/rewards_summary_card.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = [...TrackerScope.of(context).rewards]
      ..sort((a, b) => b.earnedAt.compareTo(a.earnedAt));
    final counts = {
      for (final tier in BadgeTier.values)
        tier: rewards.where((r) => r.tier == tier).length,
    };
    final unlocked = counts.values.where((c) => c > 0).length;
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 22, 0),
                child: Row(
                  children: [
                    IconButton.filled(
                      onPressed: () => context.pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: palette.sage,
                        foregroundColor: palette.ink,
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Rewards',
                      style: TextStyle(
                        color: palette.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                child: RewardsSummaryCard(
                  earnedCount: rewards.length,
                  unlockedTiers: unlocked,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _SectionTitle('Badges')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 168,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final tier = BadgeTier.values[index];
                  return BadgeTierCard(tier: tier, count: counts[tier]!);
                }, childCount: BadgeTier.values.length),
              ),
            ),
            const SliverToBoxAdapter(child: _SectionTitle('History')),
            if (rewards.isEmpty)
              const SliverToBoxAdapter(child: _EmptyHistory())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
                sliver: SliverList.separated(
                  itemCount: rewards.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      EarnedRewardTile(reward: rewards[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 14),
      child: Text(
        title,
        style: TextStyle(
          color: context.palette.ink,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: palette.border),
        ),
        child: Text(
          'Badges you earn will show up here, along with the habit that earned them.',
          textAlign: TextAlign.center,
          style: TextStyle(color: palette.muted, fontSize: 13, height: 1.45),
        ),
      ),
    );
  }
}
