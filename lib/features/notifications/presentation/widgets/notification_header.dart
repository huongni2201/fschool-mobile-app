part of '../pages/notifications_page.dart';

class _NotificationHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _NotificationHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: NotificationColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: NotificationColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: NotificationColors.textStrong,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                NotificationStrings.pageTitle,
                style: TextStyle(
                  color: NotificationColors.textStrong,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                NotificationStrings.pageSubtitle,
                style: TextStyle(
                  color: NotificationColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
