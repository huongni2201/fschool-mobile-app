part of '../pages/notifications_page.dart';

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final accent = _notificationCategoryColor(notification.category);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: NotificationColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: notification.isRead
              ? NotificationColors.border
              : NotificationColors.primaryLight,
        ),
        boxShadow: [
          BoxShadow(
            color: NotificationColors.shadow.withValues(alpha: 0.34),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NotificationIconBadge(
            icon: _notificationCategoryIcon(notification.category),
            color: accent,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: NotificationColors.textStrong,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.16,
                        ),
                      ),
                    ),
                    if (!notification.isRead) ...[
                      const SizedBox(width: 8),
                      const _UnreadDot(),
                    ],
                  ],
                ),
                if (notification.message.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    notification.message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: NotificationColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ],
                const SizedBox(height: 11),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _NotificationInfoPill(
                      icon: Icons.schedule_rounded,
                      label: _notificationTimeLabel(notification.createdAt),
                    ),
                    _NotificationInfoPill(
                      icon: _notificationCategoryIcon(notification.category),
                      label: _notificationCategoryLabel(notification.category),
                      color: accent,
                    ),
                    if (notification.actionLabel.isNotEmpty)
                      _NotificationInfoPill(
                        icon: Icons.open_in_new_rounded,
                        label: notification.actionLabel,
                        color: NotificationColors.primary,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _NotificationIconBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Icon(icon, color: color, size: 25),
    );
  }
}

class _NotificationInfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _NotificationInfoPill({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? NotificationColors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: NotificationColors.canvas,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: NotificationColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 15),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(top: 5),
      decoration: const BoxDecoration(
        color: NotificationColors.unreadDot,
        shape: BoxShape.circle,
      ),
    );
  }
}
