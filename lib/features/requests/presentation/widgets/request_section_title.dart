part of '../pages/requests_page.dart';

class _RequestSectionTitle extends StatelessWidget {
  final String title;

  const _RequestSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: RequestsColors.textStrong,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
