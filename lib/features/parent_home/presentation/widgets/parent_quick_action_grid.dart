part of '../pages/parent_home_page.dart';

class _QuickActionGrid extends StatelessWidget {
  final VoidCallback onOpenGrades;
  final VoidCallback onOpenTuition;
  final VoidCallback onOpenRequests;
  final VoidCallback onOpenTimetable;

  const _QuickActionGrid({
    required this.onOpenGrades,
    required this.onOpenTuition,
    required this.onOpenRequests,
    required this.onOpenTimetable,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickActionItem(
        icon: Icons.workspace_premium_outlined,
        title: ParentHomeStrings.grades,
        subtitle: ParentHomeStrings.gradesSubtitle,
        color: ParentHomeColors.blue,
        onTap: onOpenGrades,
      ),
      _QuickActionItem(
        icon: Icons.receipt_long_outlined,
        title: ParentHomeStrings.tuition,
        subtitle: ParentHomeStrings.tuitionSubtitle,
        color: ParentHomeColors.amber,
        onTap: onOpenTuition,
      ),
      _QuickActionItem(
        icon: Icons.edit_note_rounded,
        title: ParentHomeStrings.requests,
        subtitle: ParentHomeStrings.requestsSubtitle,
        color: ParentHomeColors.red,
        onTap: onOpenRequests,
      ),
      _QuickActionItem(
        icon: Icons.calendar_month_outlined,
        title: ParentHomeStrings.timetable,
        subtitle: ParentHomeStrings.timetableSubtitle,
        color: AppColors.homeOrange,
        onTap: onOpenTimetable,
      ),
    ];

    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Expanded(child: _QuickActionCard(item: items[index])),
          if (index != items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _QuickActionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickActionItem item;

  const _QuickActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: item.onTap,
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ParentHomeColors.border),
            boxShadow: const [
              BoxShadow(
                color: ParentHomeColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ParentHomeColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
