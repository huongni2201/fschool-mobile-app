part of '../pages/clubs_page.dart';

class _ClubsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _ClubsHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: ClubsColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ClubsColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: ClubsColors.textStrong,
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
                ClubsStrings.pageTitle,
                style: TextStyle(
                  color: ClubsColors.textStrong,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                ClubsStrings.pageSubtitle,
                style: TextStyle(
                  color: ClubsColors.textMuted,
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
