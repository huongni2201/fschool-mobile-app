part of '../pages/teacher_home_page.dart';

class _TeacherQuickActionGrid extends StatelessWidget {
  final ValueChanged<String> onTap;
  final VoidCallback onOpenTimetable;
  final VoidCallback onOpenGrades;
  final VoidCallback onOpenNotifications;

  const _TeacherQuickActionGrid({
    required this.onTap,
    required this.onOpenTimetable,
    required this.onOpenGrades,
    required this.onOpenNotifications,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      _TeacherQuickActionItem(
        icon: Icons.calendar_month_outlined,
        title: TeacherHomeStrings.teachingTimetable,
        color: TeacherHomeColors.blue,
        opensTimetable: true,
      ),
      _TeacherQuickActionItem(
        icon: Icons.workspace_premium_outlined,
        title: TeacherHomeStrings.viewGrades,
        color: TeacherHomeColors.amber,
        opensGrades: true,
      ),
      _TeacherQuickActionItem(
        icon: Icons.groups_2_outlined,
        title: TeacherHomeStrings.classList,
        color: TeacherHomeColors.primary,
      ),
      _TeacherQuickActionItem(
        icon: Icons.notifications_none_rounded,
        title: TeacherHomeStrings.notifications,
        color: TeacherHomeColors.purple,
        opensNotifications: true,
      ),
    ];

    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Expanded(
            child: _TeacherQuickActionCard(
              item: items[index],
              onTap: items[index].opensTimetable
                  ? onOpenTimetable
                  : items[index].opensGrades
                  ? onOpenGrades
                  : items[index].opensNotifications
                  ? onOpenNotifications
                  : () => onTap(items[index].title),
            ),
          ),
          if (index != items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _TeacherQuickActionItem {
  final IconData icon;
  final String title;
  final Color color;
  final bool opensTimetable;
  final bool opensGrades;
  final bool opensNotifications;

  const _TeacherQuickActionItem({
    required this.icon,
    required this.title,
    required this.color,
    this.opensTimetable = false,
    this.opensGrades = false,
    this.opensNotifications = false,
  });
}

class _TeacherQuickActionCard extends StatelessWidget {
  final _TeacherQuickActionItem item;
  final VoidCallback onTap;

  const _TeacherQuickActionCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TeacherHomeColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TeacherHomeColors.border),
            boxShadow: const [
              BoxShadow(
                color: TeacherHomeColors.shadow,
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
                  color: TeacherHomeColors.ink,
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
