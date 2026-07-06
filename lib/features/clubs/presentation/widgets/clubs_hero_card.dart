part of '../pages/clubs_page.dart';

class _ClubsHeroCard extends StatelessWidget {
  final int totalClubs;

  const _ClubsHeroCard({required this.totalClubs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ClubsColors.heroGradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: ClubsColors.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  ClubsStrings.heroTitle,
                  style: TextStyle(
                    color: ClubsColors.surface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  ClubsStrings.heroDescription,
                  style: TextStyle(
                    color: ClubsColors.surfaceMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ClubsColors.surface.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$totalClubs ${ClubsStrings.totalClubUnit}',
                    style: const TextStyle(
                      color: ClubsColors.surface,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.diversity_3_rounded,
            color: ClubsColors.surface,
            size: 56,
          ),
        ],
      ),
    );
  }
}
