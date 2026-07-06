part of '../pages/semester_grades_page.dart';

class _SubjectGradeDetailPage extends StatefulWidget {
  final String periodId;
  final SubjectGrade subject;

  const _SubjectGradeDetailPage({
    required this.periodId,
    required this.subject,
  });

  @override
  State<_SubjectGradeDetailPage> createState() =>
      _SubjectGradeDetailPageState();
}

class _SubjectGradeDetailPageState extends State<_SubjectGradeDetailPage> {
  late final GetSubjectGradeDetailUseCase _getSubjectDetailUseCase;
  late SubjectGrade _subject;

  Object? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _subject = widget.subject;
    _getSubjectDetailUseCase = getIt<GetSubjectGradeDetailUseCase>();
    _loadSubjectDetail();
  }

  Future<void> _loadSubjectDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final subject = await _getSubjectDetailUseCase(
        periodId: widget.periodId,
        subject: widget.subject,
      );

      if (!mounted) return;

      setState(() {
        _subject = subject;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subject = _subject;
    final averageLabel =
        subject.average?.toStringAsFixed(1) ??
        SemesterGradeStrings.unavailableScore;
    final rankLabel = _rankLabel(subject.average ?? 0);

    return Scaffold(
      backgroundColor: SemesterGradeColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            SemesterGradeSizes.pagePaddingHorizontal,
            SemesterGradeSizes.pagePaddingTop,
            SemesterGradeSizes.pagePaddingHorizontal,
            SemesterGradeSizes.pagePaddingBottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubjectDetailHeader(subject: subject),
              const SizedBox(height: SemesterGradeSizes.spacing2xl),
              _SubjectDetailSummaryCard(
                subject: subject,
                averageLabel: averageLabel,
                rankLabel: rankLabel,
              ),
              const SizedBox(height: SemesterGradeSizes.spacing4xl),
              if (_isLoading)
                _ComponentScoreLoadingCard(accent: _subjectAccent(subject))
              else if (_error != null)
                _ComponentScoreErrorCard(
                  message: _gradeErrorMessage(_error),
                  onRetry: _loadSubjectDetail,
                )
              else
                _ComponentScoreSection(subject: subject),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }
}

class _SubjectDetailHeader extends StatelessWidget {
  final SubjectGrade subject;

  const _SubjectDetailHeader({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: SemesterGradeColors.surface,
          borderRadius: BorderRadius.circular(
            SemesterGradeSizes.headerBackButtonRadius,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(
              SemesterGradeSizes.headerBackButtonRadius,
            ),
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: SemesterGradeSizes.headerBackButtonSize,
              height: SemesterGradeSizes.headerBackButtonSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  SemesterGradeSizes.headerBackButtonRadius,
                ),
                border: Border.all(color: SemesterGradeColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: SemesterGradeColors.textStrong,
              ),
            ),
          ),
        ),
        const SizedBox(width: SemesterGradeSizes.spacingXl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                SemesterGradeStrings.subjectDetailTitle,
                style: TextStyle(
                  color: SemesterGradeColors.textStrong,
                  fontSize: SemesterGradeSizes.detailHeaderTitleSize,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: SemesterGradeSizes.spacingXs),
              Text(
                subject.subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SemesterGradeColors.textMuted,
                  fontSize: SemesterGradeSizes.headerSubtitleSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubjectDetailSummaryCard extends StatelessWidget {
  final SubjectGrade subject;
  final String averageLabel;
  final String rankLabel;

  const _SubjectDetailSummaryCard({
    required this.subject,
    required this.averageLabel,
    required this.rankLabel,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _subjectAccent(subject);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SemesterGradeSizes.overviewRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, accent.withValues(alpha: 0.76)],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.2),
            blurRadius: SemesterGradeSizes.overviewShadowBlur,
            offset: const Offset(0, SemesterGradeSizes.overviewShadowOffsetY),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SemesterGradeSizes.overviewRadius),
        child: Stack(
          children: [
            Positioned(
              right: SemesterGradeSizes.detailCircleTopRight,
              top: SemesterGradeSizes.detailCircleTopTop,
              child: _SoftCircle(
                size: SemesterGradeSizes.detailCircleSize,
                color: SemesterGradeColors.surface.withValues(alpha: 0.13),
              ),
            ),
            Positioned(
              left: SemesterGradeSizes.detailCircleBottomLeft,
              bottom: SemesterGradeSizes.detailCircleBottomBottom,
              child: _SoftCircle(
                size: SemesterGradeSizes.detailCircleSize,
                color: SemesterGradeColors.surface.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SemesterGradeSizes.overviewPaddingHorizontal,
                SemesterGradeSizes.overviewPaddingTop,
                SemesterGradeSizes.overviewPaddingHorizontal,
                SemesterGradeSizes.overviewPaddingBottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SemesterGradeSizes.detailIconBoxSize,
                        height: SemesterGradeSizes.detailIconBoxSize,
                        decoration: BoxDecoration(
                          color: SemesterGradeColors.surface.withValues(
                            alpha: 0.18,
                          ),
                          borderRadius: BorderRadius.circular(
                            SemesterGradeSizes.detailIconBoxRadius,
                          ),
                          border: Border.all(
                            color: SemesterGradeColors.surface.withValues(
                              alpha: 0.18,
                            ),
                          ),
                        ),
                        child: Icon(
                          _subjectIcon(subject.group),
                          color: SemesterGradeColors.surface,
                          size: SemesterGradeSizes.detailIconSize,
                        ),
                      ),
                      const SizedBox(width: SemesterGradeSizes.spacingXl),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject.subject,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: SemesterGradeColors.surface,
                                fontSize:
                                    SemesterGradeSizes.detailSubjectTitleSize,
                                fontWeight: FontWeight.w900,
                                height: 1.08,
                              ),
                            ),
                            const SizedBox(
                              height: SemesterGradeSizes.spacingSm,
                            ),
                            Text(
                              SemesterGradeStrings.subjectTeacherLine(
                                subject.group,
                                subject.teacher,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: SemesterGradeColors.surface.withValues(
                                  alpha: 0.82,
                                ),
                                fontSize: SemesterGradeSizes
                                    .detailSubjectSubtitleSize,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SemesterGradeSizes.spacing3xl),
                  Row(
                    children: [
                      Expanded(
                        child: _SubjectDetailMetric(
                          label: SemesterGradeStrings.subjectAverageTitle,
                          value: averageLabel,
                        ),
                      ),
                      const SizedBox(width: SemesterGradeSizes.spacingMd),
                      Expanded(
                        child: _SubjectDetailMetric(
                          label: SemesterGradeStrings.subjectRankTitle,
                          value: rankLabel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectDetailMetric extends StatelessWidget {
  final String label;
  final String value;

  const _SubjectDetailMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SemesterGradeSizes.detailMetricPaddingHorizontal,
        vertical: SemesterGradeSizes.detailMetricPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: SemesterGradeColors.surface.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(SemesterGradeSizes.statRadius),
        border: Border.all(
          color: SemesterGradeColors.surface.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: SemesterGradeColors.surface.withValues(alpha: 0.76),
              fontSize: SemesterGradeSizes.detailMetricLabelSize,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: SemesterGradeSizes.spacingSm - 1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SemesterGradeColors.surface,
              fontSize: SemesterGradeSizes.detailMetricValueSize,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentScoreSection extends StatelessWidget {
  final SubjectGrade subject;

  const _ComponentScoreSection({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          SemesterGradeStrings.componentScoresTitle,
          style: TextStyle(
            color: SemesterGradeColors.textStrong,
            fontSize: SemesterGradeSizes.sectionTitleSize,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: SemesterGradeSizes.spacingLg),
        _ComponentScorePanel(subject: subject),
      ],
    );
  }
}

class _ComponentScorePanel extends StatelessWidget {
  final SubjectGrade subject;

  const _ComponentScorePanel({required this.subject});

  @override
  Widget build(BuildContext context) {
    final accent = _subjectAccent(subject);
    final averageLabel =
        subject.average?.toStringAsFixed(2) ??
        SemesterGradeStrings.unavailableScore;
    final averageQualityLabel = _scoreQualityLabel(averageLabel);
    final rankLabel = _rankLabel(subject.average ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: SemesterGradeColors.surface,
        borderRadius: BorderRadius.circular(
          SemesterGradeSizes.componentListRadius,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.06),
            blurRadius: SemesterGradeSizes.overviewShadowBlur,
            offset: const Offset(0, SemesterGradeSizes.overviewShadowOffsetY),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < subject.scores.length; index++) ...[
            _ComponentScoreRow(score: subject.scores[index], accent: accent),
            if (index != subject.scores.length - 1)
              Divider(height: 1, color: accent.withValues(alpha: 0.1)),
          ],
          Divider(height: 1, color: accent.withValues(alpha: 0.1)),
          _ComponentScoreSummary(
            accent: accent,
            averageLabel: averageLabel,
            averageQualityLabel: averageQualityLabel,
            rankLabel: rankLabel,
          ),
        ],
      ),
    );
  }
}

class _ComponentScoreLoadingCard extends StatelessWidget {
  final Color accent;

  const _ComponentScoreLoadingCard({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SemesterGradeSizes.spacing3xl),
      decoration: BoxDecoration(
        color: SemesterGradeColors.surface,
        borderRadius: BorderRadius.circular(
          SemesterGradeSizes.componentListRadius,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Center(child: CircularProgressIndicator(color: accent)),
    );
  }
}

class _ComponentScoreErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ComponentScoreErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SemesterGradeSizes.spacing3xl),
      decoration: BoxDecoration(
        color: SemesterGradeColors.surface,
        borderRadius: BorderRadius.circular(
          SemesterGradeSizes.componentListRadius,
        ),
        border: Border.all(color: SemesterGradeColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: SemesterGradeColors.primary,
            size: 34,
          ),
          const SizedBox(height: SemesterGradeSizes.spacingMd),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SemesterGradeColors.textMuted,
              fontSize: SemesterGradeSizes.overviewSubtitleSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SemesterGradeSizes.spacingLg),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _ComponentScoreRow extends StatelessWidget {
  final ComponentScore score;
  final Color accent;

  const _ComponentScoreRow({required this.score, required this.accent});

  @override
  Widget build(BuildContext context) {
    final hasScore = score.value != SemesterGradeStrings.unavailableScore;
    final foreground = hasScore ? accent : SemesterGradeColors.textMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ComponentScoreIcon(
            icon: _componentIcon(score.label),
            accent: accent,
            hasScore: hasScore,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  score.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SemesterGradeColors.textStrong,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _componentDescription(score.label),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SemesterGradeColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 72),
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: hasScore
                      ? accent.withValues(alpha: 0.1)
                      : SemesterGradeColors.textMuted.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  score.value,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _scoreQualityLabel(score.value),
                style: const TextStyle(
                  color: SemesterGradeColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComponentScoreIcon extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final bool hasScore;

  const _ComponentScoreIcon({
    required this.icon,
    required this.accent,
    required this.hasScore,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      height: 66,
      child: Stack(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: accent, size: 30),
          ),
          if (hasScore)
            Positioned(
              right: 0,
              bottom: 8,
              child: Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: SemesterGradeColors.surface,
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: SemesterGradeColors.surface,
                  size: 15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ComponentScoreSummary extends StatelessWidget {
  final Color accent;
  final String averageLabel;
  final String averageQualityLabel;
  final String rankLabel;

  const _ComponentScoreSummary({
    required this.accent,
    required this.averageLabel,
    required this.averageQualityLabel,
    required this.rankLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;

          final average = _SummaryAverage(
            accent: accent,
            averageLabel: averageLabel,
            qualityLabel: averageQualityLabel,
          );
          final rank = _SummaryRank(rankLabel: rankLabel);

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [average, const SizedBox(height: 12), rank],
            );
          }

          return Row(
            children: [
              Expanded(child: average),
              Container(
                width: 1,
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: SemesterGradeColors.divider,
              ),
              Expanded(child: rank),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryAverage extends StatelessWidget {
  final Color accent;
  final String averageLabel;
  final String qualityLabel;

  const _SummaryAverage({
    required this.accent,
    required this.averageLabel,
    required this.qualityLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.bar_chart_rounded, color: accent, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            SemesterGradeStrings.subjectAverageTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SemesterGradeColors.textStrong,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          averageLabel,
          style: TextStyle(
            color: accent,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            qualityLabel,
            style: TextStyle(
              color: accent,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRank extends StatelessWidget {
  final String rankLabel;

  const _SummaryRank({required this.rankLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            SemesterGradeStrings.subjectRankTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: SemesterGradeColors.textStrong,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: SemesterGradeColors.successSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            rankLabel,
            style: const TextStyle(
              color: SemesterGradeColors.success,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(
          Icons.star_border_rounded,
          color: SemesterGradeColors.success,
          size: 30,
        ),
      ],
    );
  }
}

IconData _componentIcon(String label) {
  if (label == SemesterGradeStrings.scoreOral) {
    return Icons.record_voice_over_outlined;
  }
  if (label == SemesterGradeStrings.score15Minutes) {
    return Icons.timer_outlined;
  }
  if (label == SemesterGradeStrings.scorePeriod) {
    return Icons.assignment_outlined;
  }
  if (label == SemesterGradeStrings.scoreExam) {
    return Icons.edit_outlined;
  }
  if (label == SemesterGradeStrings.scoreProject) {
    return Icons.rocket_launch_outlined;
  }
  if (label == SemesterGradeStrings.scorePractical) {
    return Icons.terminal_outlined;
  }

  return Icons.fact_check_outlined;
}

String _componentDescription(String label) {
  if (label == SemesterGradeStrings.scoreOral) {
    return '\u0110\u00E1nh gi\u00E1 kh\u1EA3 n\u0103ng tr\u00ECnh b\u00E0y v\u00E0 hi\u1EC3u b\u00E0i';
  }
  if (label == SemesterGradeStrings.score15Minutes) {
    return 'Ki\u1EC3m tra nhanh ki\u1EBFn th\u1EE9c c\u01A1 b\u1EA3n';
  }
  if (label == SemesterGradeStrings.scorePeriod) {
    return '\u0110\u00E1nh gi\u00E1 ki\u1EBFn th\u1EE9c trong m\u1ED9t ti\u1EBFt h\u1ECDc';
  }
  if (label == SemesterGradeStrings.scoreExam) {
    return '\u0110\u00E1nh gi\u00E1 t\u1ED5ng h\u1EE3p cu\u1ED1i k\u1EF3';
  }
  if (label == SemesterGradeStrings.scoreProject) {
    return '\u0110\u00E1nh gi\u00E1 qua s\u1EA3n ph\u1EA9m v\u00E0 b\u00E0i l\u00E0m';
  }
  if (label == SemesterGradeStrings.scorePractical) {
    return '\u0110\u00E1nh gi\u00E1 k\u1EF9 n\u0103ng th\u1EF1c h\u00E0nh';
  }

  return 'C\u1EADp nh\u1EADt t\u1EEB b\u1EA3ng \u0111i\u1EC3m m\u00F4n h\u1ECDc';
}

String _scoreQualityLabel(String value) {
  final score = double.tryParse(value.replaceAll(',', '.'));

  if (score == null) return SemesterGradeStrings.updating;
  if (score >= 9) return SemesterGradeStrings.rankExcellent;
  if (score >= 8.5) return 'R\u1EA5t t\u1ED1t';
  if (score >= 8) return 'T\u1ED1t';
  if (score >= 7) return SemesterGradeStrings.rankFair;
  if (score >= 5) return '\u0110\u1EA1t';

  return SemesterGradeStrings.rankNeedsImprovement;
}
