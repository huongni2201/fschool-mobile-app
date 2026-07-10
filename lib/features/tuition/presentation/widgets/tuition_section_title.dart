part of '../pages/tuition_page.dart';

class _TuitionSectionTitle extends StatelessWidget {
  final String title;

  const _TuitionSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: TuitionColors.textStrong,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
