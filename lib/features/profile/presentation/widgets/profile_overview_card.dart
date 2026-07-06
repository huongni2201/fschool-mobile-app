part of '../pages/profile_page.dart';

class _ProfileOverviewCard extends StatelessWidget {
  final StudentProfile? profile;

  const _ProfileOverviewCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ProfileColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ProfileColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ProfileStatTile(
              icon: Icons.groups_2_outlined,
              label: ProfileStrings.classLabel,
              value: profile?.className ?? ProfileStrings.updating,
            ),
          ),
          Container(width: 1, height: 46, color: ProfileColors.divider),
          Expanded(
            child: _ProfileStatTile(
              icon: Icons.location_city_outlined,
              label: ProfileStrings.campusLabel,
              value: profile?.campus ?? ProfileStrings.updating,
            ),
          ),
          Container(width: 1, height: 46, color: ProfileColors.divider),
          Expanded(
            child: _ProfileStatTile(
              icon: Icons.calendar_month_outlined,
              label: ProfileStrings.schoolYearLabel,
              value: profile?.schoolYear ?? ProfileStrings.updating,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileStatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: ProfileColors.primary, size: 23),
        const SizedBox(height: 7),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ProfileColors.textStrong,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ProfileColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
