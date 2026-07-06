part of '../pages/requests_page.dart';

class _RequestsHeroCard extends StatelessWidget {
  const _RequestsHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: RequestsColors.heroGradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: RequestsColors.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  RequestsStrings.heroTitle,
                  style: TextStyle(
                    color: RequestsColors.surface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  RequestsStrings.heroDescription,
                  style: TextStyle(
                    color: RequestsColors.surfaceMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Icon(
            Icons.mark_email_unread_outlined,
            color: RequestsColors.surface,
            size: 54,
          ),
        ],
      ),
    );
  }
}
