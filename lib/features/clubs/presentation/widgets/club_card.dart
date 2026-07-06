part of '../pages/clubs_page.dart';

class _ClubCard extends StatelessWidget {
  final ClubItem club;

  const _ClubCard({required this.club});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(club.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClubsColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ClubsColors.border),
        boxShadow: [
          BoxShadow(
            color: ClubsColors.primary.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ClubsColors.primarySoft,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: ClubsColors.border),
                ),
                child: const Icon(
                  Icons.groups_3_rounded,
                  color: ClubsColors.primary,
                  size: 29,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ClubsColors.textStrong,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    if (club.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        club.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ClubsColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ClubStatusBadge(label: club.statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (club.scheduleLabel.isNotEmpty)
                _ClubInfoPill(
                  icon: Icons.schedule_rounded,
                  label: club.scheduleLabel,
                ),
              if (club.location.isNotEmpty)
                _ClubInfoPill(
                  icon: Icons.meeting_room_outlined,
                  label: club.location,
                ),
              if (club.teacherName.isNotEmpty)
                _ClubInfoPill(
                  icon: Icons.person_outline_rounded,
                  label: '${ClubsStrings.teacherPrefix} ${club.teacherName}',
                ),
              if (club.memberCount != null)
                _ClubInfoPill(
                  icon: Icons.people_alt_outlined,
                  label: '${club.memberCount} ${ClubsStrings.memberUnit}',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    final normalized = status.toLowerCase();

    if (normalized.contains('joined') || normalized.contains('active')) {
      return ClubsColors.green;
    }
    if (normalized.contains('pending')) return ClubsColors.blue;
    if (normalized.contains('closed')) return ClubsColors.brown;

    return ClubsColors.primary;
  }
}

class _ClubInfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ClubInfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: ClubsColors.canvas,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ClubsColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ClubsColors.textMuted, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: ClubsColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _ClubStatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
