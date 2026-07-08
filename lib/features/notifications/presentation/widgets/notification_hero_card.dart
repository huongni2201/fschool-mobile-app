part of '../pages/notifications_page.dart';

class _NotificationHeroCard extends StatelessWidget {
  final NotificationFeed feed;

  const _NotificationHeroCard({required this.feed});

  @override
  Widget build(BuildContext context) {
    final readCount = feed.totalCount - feed.unreadCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: NotificationColors.primary,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: NotificationColors.primaryDark),
        boxShadow: const [
          BoxShadow(
            color: NotificationColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 13),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: NotificationColors.primarySoft,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: NotificationColors.primaryDark),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: NotificationColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NotificationStrings.heroTitle,
                      style: TextStyle(
                        color: NotificationColors.surface,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      NotificationStrings.heroSubtitle,
                      style: TextStyle(
                        color: NotificationColors.heroTextMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _NotificationHeroStat(
                value: feed.totalCount,
                label: NotificationStrings.totalLabel,
              ),
              const SizedBox(width: 10),
              _NotificationHeroStat(
                value: feed.unreadCount,
                label: NotificationStrings.unreadLabel,
              ),
              const SizedBox(width: 10),
              _NotificationHeroStat(
                value: readCount < 0 ? 0 : readCount,
                label: NotificationStrings.readLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationHeroStat extends StatelessWidget {
  final int value;
  final String label;

  const _NotificationHeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: NotificationColors.heroInnerSurface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: NotificationColors.primaryDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                color: NotificationColors.primary,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: NotificationColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
