part of '../pages/home_page.dart';

class _GradeGrid extends StatelessWidget {
  final List<HomeGradeItem> items;

  const _GradeGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 12,
        childAspectRatio: 1.72,
      ),
      itemBuilder: (context, index) => _GradeCard(item: items[index]),
    );
  }
}

class _GradeCard extends StatelessWidget {
  final HomeGradeItem item;

  const _GradeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final gradeColor = _gradeColor(item.score);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.homeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.homeTextMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.scoreLabel,
                      style: const TextStyle(
                        color: AppColors.homeTextStrong,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _StatusPill(
                  label: item.label,
                  foreground: gradeColor,
                  background: gradeColor.withValues(alpha: 0.12),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 4,
              backgroundColor: AppColors.homeDivider,
              valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
            ),
          ),
        ],
      ),
    );
  }
}
