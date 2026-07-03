part of '../pages/home_page.dart';

class _ScheduleList extends StatelessWidget {
  final List<HomeScheduleItem> items;

  const _ScheduleList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.homeBorder),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _ScheduleRow(item: items[index]),
            if (index != items.length - 1)
              const Divider(height: 1, color: AppColors.homeDivider),
          ],
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final HomeScheduleItem item;

  const _ScheduleRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final accent = _scheduleAccent(item.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              item.timeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.homeTextStrong,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            width: 4,
            height: 34,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.homeTextStrong,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.detailLabel.isEmpty
                      ? AppStrings.homeInfoUpdating
                      : item.detailLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.homeTextMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (item.statusLabel.isNotEmpty)
            _StatusPill(
              label: item.statusLabel,
              foreground: accent,
              background: accent.withValues(alpha: 0.12),
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color foreground;
  final Color background;

  const _StatusPill({
    required this.label,
    required this.foreground,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
