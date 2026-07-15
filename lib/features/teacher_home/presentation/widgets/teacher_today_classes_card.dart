part of '../pages/teacher_home_page.dart';

class _TeacherTodayClassesCard extends StatelessWidget {
  final List<TeacherClassSession> items;

  const _TeacherTodayClassesCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _TeacherInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TeacherSectionHeader(title: TeacherHomeStrings.todayClasses),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const _TeacherEmptyContent(
              icon: Icons.event_available_outlined,
              title: TeacherHomeStrings.noTodayClassTitle,
              message: TeacherHomeStrings.noTodayClassMessage,
            )
          else
            for (var index = 0; index < items.take(4).length; index++) ...[
              _TodayClassTile(item: items[index]),
              if (index != items.take(4).length - 1)
                const Divider(height: 18, color: TeacherHomeColors.border),
            ],
        ],
      ),
    );
  }
}

class _TodayClassTile extends StatelessWidget {
  final TeacherClassSession item;

  const _TodayClassTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: TeacherHomeColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: TeacherHomeColors.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.subjectName} · ${item.className}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: TeacherHomeColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${item.timeLabel} · ${TeacherHomeStrings.roomLabel} ${item.room}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: TeacherHomeColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: TeacherHomeColors.mint.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            item.statusLabel,
            style: const TextStyle(
              color: TeacherHomeColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
