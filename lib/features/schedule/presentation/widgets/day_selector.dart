part of '../pages/timetable_page.dart';

class _DaySelector extends StatelessWidget {
  final TimetableWeek week;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;

  const _DaySelector({
    required this.week,
    required this.selectedDate,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final day in week.days) ...[
          Expanded(
            child: _DayChip(
              day: day,
              isSelected: _isSameDate(day.date, selectedDate),
              isToday: _isSameDate(day.date, DateTime.now()),
              onTap: () => onSelected(day.date),
            ),
          ),
          if (day != week.days.last) const SizedBox(width: 7),
        ],
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  final TimetableDay day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayChip({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? Colors.white : AppColors.homeTextStrong;
    final muted = isSelected
        ? Colors.white.withValues(alpha: 0.78)
        : AppColors.homeTextMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.homeOrange : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isToday || isSelected
                  ? AppColors.homeOrange
                  : AppColors.homeBorder,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: AppColors.homeCardShadow,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Text(
                _shortWeekdayLabel(day.date.weekday),
                maxLines: 1,
                style: TextStyle(
                  color: muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                day.date.day.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: foreground,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 7),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: day.hasLessons
                      ? (isSelected ? Colors.white : AppColors.homeOrange)
                      : muted.withValues(alpha: 0.28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedDayHeader extends StatelessWidget {
  final TimetableDay day;
  final bool isTeacher;

  const _SelectedDayHeader({required this.day, required this.isTeacher});

  @override
  Widget build(BuildContext context) {
    final lessonLabel = day.lessons.isEmpty
        ? 'Không có ${isTeacher ? 'tiết dạy' : 'tiết học'}'
        : '${day.lessons.length} ${isTeacher ? 'tiết dạy' : 'tiết học'}';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${day.label}, ${_dayMonthLabel(day.date)}',
                style: const TextStyle(
                  color: AppColors.homeTextStrong,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lessonLabel,
                style: const TextStyle(
                  color: AppColors.homeTextMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.homeOrangeSoft,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.homeOrangeLight),
          ),
          child: Text(
            _isSameDate(day.date, DateTime.now())
                ? 'Hôm nay'
                : _dateLabel(day.date),
            style: const TextStyle(
              color: AppColors.homeOrange,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
