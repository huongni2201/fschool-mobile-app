part of '../pages/home_page.dart';

class _ShortcutGrid extends StatelessWidget {
  final ValueChanged<String> onTap;
  final VoidCallback onOpenGrades;
  final VoidCallback onOpenTimetable;
  final VoidCallback onOpenExams;
  final VoidCallback onOpenRequests;
  final VoidCallback onOpenTuition;
  final VoidCallback onOpenClubs;

  const _ShortcutGrid({
    required this.onTap,
    required this.onOpenGrades,
    required this.onOpenTimetable,
    required this.onOpenExams,
    required this.onOpenRequests,
    required this.onOpenTuition,
    required this.onOpenClubs,
  });

  static const List<_ShortcutItem> _items = [
    _ShortcutItem(
      Icons.calendar_month_outlined,
      AppStrings.homeShortcutTimetable,
      opensTimetable: true,
    ),
    _ShortcutItem(
      Icons.bar_chart_rounded,
      AppStrings.homeShortcutScores,
      opensGrades: true,
    ),
    _ShortcutItem(
      Icons.credit_card_rounded,
      AppStrings.homeShortcutTuition,
      opensTuition: true,
    ),
    _ShortcutItem(
      Icons.alarm_outlined,
      AppStrings.homeShortcutExams,
      opensExams: true,
    ),
    _ShortcutItem(
      Icons.edit_document,
      AppStrings.homeShortcutRequests,
      opensRequests: true,
    ),
    _ShortcutItem(
      Icons.diversity_3_rounded,
      AppStrings.homeShortcutClubs,
      opensClubs: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final item = _items[index];

        return _ShortcutTile(
          item: item,
          onTap: item.opensTimetable
              ? onOpenTimetable
              : item.opensGrades
              ? onOpenGrades
              : item.opensExams
              ? onOpenExams
              : item.opensRequests
              ? onOpenRequests
              : item.opensTuition
              ? onOpenTuition
              : item.opensClubs
              ? onOpenClubs
              : () => onTap(item.label),
        );
      },
    );
  }
}

class _ShortcutItem {
  final IconData icon;
  final String label;
  final bool opensGrades;
  final bool opensTimetable;
  final bool opensExams;
  final bool opensRequests;
  final bool opensTuition;
  final bool opensClubs;

  const _ShortcutItem(
    this.icon,
    this.label, {
    this.opensGrades = false,
    this.opensTimetable = false,
    this.opensExams = false,
    this.opensRequests = false,
    this.opensTuition = false,
    this.opensClubs = false,
  });
}

class _ShortcutTile extends StatelessWidget {
  final _ShortcutItem item;
  final VoidCallback onTap;

  const _ShortcutTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.homeBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.homeOrangeSoft,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: AppColors.homeOrangeLight),
                ),
                child: Icon(item.icon, color: AppColors.homeOrange, size: 28),
              ),
              const SizedBox(height: 7),
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.homeTextMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
