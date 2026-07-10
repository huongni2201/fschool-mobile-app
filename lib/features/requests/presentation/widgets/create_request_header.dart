part of '../pages/create_request_page.dart';

class _CreateRequestHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const _CreateRequestHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: RequestsColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: RequestsColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: RequestsColors.textStrong,
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
                RequestsStrings.createPageTitle,
                style: TextStyle(
                  color: RequestsColors.textStrong,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                RequestsStrings.createPageSubtitle,
                style: TextStyle(
                  color: RequestsColors.textMuted,
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
