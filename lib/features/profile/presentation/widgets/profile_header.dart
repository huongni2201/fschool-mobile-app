part of '../pages/profile_page.dart';

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ProfileStrings.pageTitle,
          style: TextStyle(
            color: ProfileColors.textStrong,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        SizedBox(height: 6),
        Text(
          ProfileStrings.pageSubtitle,
          style: TextStyle(
            color: ProfileColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
