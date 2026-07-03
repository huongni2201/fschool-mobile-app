part of '../pages/semester_grades_page.dart';

class _GradeOverviewCard extends StatelessWidget {
  final double average;
  final String rankLabel;
  final int subjectCount;
  final int excellentCount;
  final String strongestSubject;

  const _GradeOverviewCard({
    required this.average,
    required this.rankLabel,
    required this.subjectCount,
    required this.excellentCount,
    required this.strongestSubject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SemesterGradeSizes.overviewRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SemesterGradeColors.primary,
            SemesterGradeColors.primaryDeep,
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: SemesterGradeColors.cardShadow,
            blurRadius: SemesterGradeSizes.overviewShadowBlur,
            offset: Offset(0, SemesterGradeSizes.overviewShadowOffsetY),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SemesterGradeSizes.overviewRadius),
        child: Stack(
          children: [
            Positioned(
              right: SemesterGradeSizes.overviewCircleTopRight,
              top: SemesterGradeSizes.overviewCircleTopTop,
              child: _SoftCircle(
                size: SemesterGradeSizes.overviewCircleTopSize,
                color: SemesterGradeColors.surface.withValues(alpha: 0.13),
              ),
            ),
            Positioned(
              left: SemesterGradeSizes.overviewCircleBottomLeft,
              bottom: SemesterGradeSizes.overviewCircleBottomBottom,
              child: _SoftCircle(
                size: SemesterGradeSizes.overviewCircleBottomSize,
                color: SemesterGradeColors.surface.withValues(alpha: 0.09),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SemesterGradeSizes.overviewPaddingHorizontal,
                SemesterGradeSizes.overviewPaddingTop,
                SemesterGradeSizes.overviewPaddingHorizontal,
                SemesterGradeSizes.overviewPaddingBottom,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact =
                      constraints.maxWidth <
                      SemesterGradeSizes.overviewCompactBreakpoint;

                  final scoreMeter = _ScoreMeter(
                    value: average / 10,
                    scoreLabel: average.toStringAsFixed(1),
                  );

                  final summary = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal:
                              SemesterGradeSizes.overviewBadgePaddingHorizontal,
                          vertical:
                              SemesterGradeSizes.overviewBadgePaddingVertical,
                        ),
                        decoration: BoxDecoration(
                          color: SemesterGradeColors.surface.withValues(
                            alpha: 0.18,
                          ),
                          borderRadius: BorderRadius.circular(
                            SemesterGradeSizes.overviewBadgeRadius,
                          ),
                          border: Border.all(
                            color: SemesterGradeColors.surface.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: const Text(
                          SemesterGradeStrings.overviewCurrent,
                          style: TextStyle(
                            color: SemesterGradeColors.surface,
                            fontSize: SemesterGradeSizes.overviewBadgeFontSize,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: SemesterGradeSizes.spacingLg),
                      Text(
                        rankLabel,
                        style: const TextStyle(
                          color: SemesterGradeColors.surface,
                          fontSize: SemesterGradeSizes.overviewTitleSize,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: SemesterGradeSizes.spacingSm),
                      Text(
                        SemesterGradeStrings.featuredSubject(strongestSubject),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: SemesterGradeColors.surface.withValues(
                            alpha: 0.82,
                          ),
                          fontSize: SemesterGradeSizes.overviewSubtitleSize,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ],
                  );

                  return Column(
                    children: [
                      if (isCompact)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            summary,
                            const SizedBox(
                              height: SemesterGradeSizes.spacing2xl,
                            ),
                            Center(child: scoreMeter),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(child: summary),
                            const SizedBox(
                              width: SemesterGradeSizes.spacing2xl,
                            ),
                            scoreMeter,
                          ],
                        ),
                      const SizedBox(height: SemesterGradeSizes.spacing2xl),
                      Row(
                        children: [
                          Expanded(
                            child: _OverviewStat(
                              icon: Icons.menu_book_rounded,
                              value: '$subjectCount',
                              label: SemesterGradeStrings.subjectUnit,
                            ),
                          ),
                          const SizedBox(width: SemesterGradeSizes.spacingMd),
                          Expanded(
                            child: _OverviewStat(
                              icon: Icons.workspace_premium_rounded,
                              value: '$excellentCount',
                              label: SemesterGradeStrings.excellentSubjectUnit,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreMeter extends StatelessWidget {
  final double value;
  final String scoreLabel;

  const _ScoreMeter({required this.value, required this.scoreLabel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SemesterGradeSizes.scoreMeterSize,
      height: SemesterGradeSizes.scoreMeterSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: SemesterGradeSizes.scoreMeterSize,
            height: SemesterGradeSizes.scoreMeterSize,
            child: CircularProgressIndicator(
              value: value.clamp(0, 1),
              strokeWidth: SemesterGradeSizes.scoreMeterStrokeWidth,
              backgroundColor: SemesterGradeColors.surface.withValues(
                alpha: 0.2,
              ),
              valueColor: const AlwaysStoppedAnimation<Color>(
                SemesterGradeColors.surface,
              ),
            ),
          ),
          Container(
            width: SemesterGradeSizes.scoreMeterInnerSize,
            height: SemesterGradeSizes.scoreMeterInnerSize,
            decoration: BoxDecoration(
              color: SemesterGradeColors.surface.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: SemesterGradeColors.surface.withValues(alpha: 0.24),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  scoreLabel,
                  style: const TextStyle(
                    color: SemesterGradeColors.surface,
                    fontSize: SemesterGradeSizes.scoreMeterValueSize,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: SemesterGradeSizes.spacingXxs),
                Text(
                  SemesterGradeStrings.semesterAverageShort,
                  style: TextStyle(
                    color: SemesterGradeColors.surface.withValues(alpha: 0.78),
                    fontSize: SemesterGradeSizes.scoreMeterLabelSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _OverviewStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SemesterGradeSizes.statPaddingHorizontal,
        vertical: SemesterGradeSizes.statPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: SemesterGradeColors.surface.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(SemesterGradeSizes.statRadius),
        border: Border.all(
          color: SemesterGradeColors.surface.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: SemesterGradeColors.surface,
            size: SemesterGradeSizes.statIconSize,
          ),
          const SizedBox(width: SemesterGradeSizes.statIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: SemesterGradeColors.surface,
                    fontSize: SemesterGradeSizes.statValueSize,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: SemesterGradeSizes.spacingXxs),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: SemesterGradeColors.surface.withValues(alpha: 0.78),
                    fontSize: SemesterGradeSizes.statLabelSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

