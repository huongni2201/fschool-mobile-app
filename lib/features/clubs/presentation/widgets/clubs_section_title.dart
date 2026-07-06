part of '../pages/clubs_page.dart';

class _ClubsSectionTitle extends StatelessWidget {
  final String title;

  const _ClubsSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: ClubsColors.textStrong,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
