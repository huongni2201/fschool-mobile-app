part of '../pages/notifications_page.dart';

class _NotificationFilterBar extends StatelessWidget {
  final _NotificationFilter selectedFilter;
  final NotificationFeed feed;
  final ValueChanged<_NotificationFilter> onSelected;

  const _NotificationFilterBar({
    required this.selectedFilter,
    required this.feed,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NotificationFilterChip(
          label: NotificationStrings.allFilter,
          count: feed.totalCount,
          isSelected: selectedFilter == _NotificationFilter.all,
          onTap: () => onSelected(_NotificationFilter.all),
        ),
        const SizedBox(width: 8),
        _NotificationFilterChip(
          label: NotificationStrings.unreadFilter,
          count: feed.unreadCount,
          isSelected: selectedFilter == _NotificationFilter.unread,
          onTap: () => onSelected(_NotificationFilter.unread),
        ),
      ],
    );
  }
}

class _NotificationFilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _NotificationFilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected
        ? NotificationColors.surface
        : NotificationColors.textStrong;
    final background = isSelected
        ? NotificationColors.primary
        : NotificationColors.surface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? NotificationColors.primary
                  : NotificationColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? NotificationColors.surface.withValues(alpha: 0.2)
                      : NotificationColors.primarySoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? NotificationColors.surface
                        : NotificationColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationSectionHeader extends StatelessWidget {
  final int count;

  const _NotificationSectionHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            NotificationStrings.notificationListTitle,
            style: TextStyle(
              color: NotificationColors.textStrong,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          NotificationStrings.countLabel(
            count,
            NotificationStrings.generalCategory,
          ),
          style: const TextStyle(
            color: NotificationColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
