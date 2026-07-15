part of '../pages/parent_home_page.dart';

class _ParentAttentionCard extends StatelessWidget {
  final ParentDashboard dashboard;
  final ParentStudent student;

  const _ParentAttentionCard({required this.dashboard, required this.student});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      ...student.alerts,
      ...dashboard.alerts,
    ].where((alert) => !_isAttendanceAlert(alert)).toList(growable: false);

    return _ParentInfoCard(
      title: ParentHomeStrings.attentionTitle,
      child: alerts.isEmpty
          ? const _EmptyInfoContent(
              icon: Icons.check_circle_outline_rounded,
              title: ParentHomeStrings.emptyAlertsTitle,
              message: ParentHomeStrings.emptyAlertsMessage,
            )
          : Column(
              children: [
                for (var index = 0; index < alerts.length; index++) ...[
                  _AlertTile(item: alerts[index]),
                  if (index != alerts.length - 1)
                    const Divider(height: 20, color: ParentHomeColors.border),
                ],
              ],
            ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final ParentAlert item;

  const _AlertTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _alertColor(item.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(_alertIcon(item.type), color: color, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  color: ParentHomeColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (item.message.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: const TextStyle(
                    color: ParentHomeColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyInfoContent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyInfoContent({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.homeOrangeSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.homeOrange, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ParentHomeColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(
                  color: ParentHomeColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
