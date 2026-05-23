import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/config/design_tokens.dart';
import 'package:edu_smart_assistant/widgets/feedback/skeleton_card.dart';

class SkeletonList extends StatelessWidget {
  final int count;
  final double cardHeight;
  final double cardRadius;

  const SkeletonList({
    super.key,
    this.count = 4,
    this.cardHeight = 72,
    this.cardRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: List.generate(count, (i) => Padding(
          padding: EdgeInsets.only(bottom: i < count - 1 ? AppSpacing.sm : 0),
          child: SkeletonCard(
            height: cardHeight,
            radius: cardRadius,
          ),
        )),
      ),
    );
  }
}
