part of '../pages/tuition_page.dart';

class _TuitionHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _TuitionHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: TuitionColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: TuitionColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: TuitionColors.textStrong,
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
                TuitionStrings.pageTitle,
                style: TextStyle(
                  color: TuitionColors.textStrong,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                TuitionStrings.pageSubtitle,
                style: TextStyle(
                  color: TuitionColors.textMuted,
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
