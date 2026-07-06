part of '../pages/requests_page.dart';

class _RequestTypeCard extends StatelessWidget {
  final RequestTypeItem requestType;

  const _RequestTypeCard({required this.requestType});

  @override
  Widget build(BuildContext context) {
    final color = _requestColor(requestType.code);

    return Material(
      color: RequestsColors.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _showComingSoon(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: RequestsColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_requestIcon(requestType), color: color, size: 27),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requestType.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: RequestsColors.textStrong,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      requestType.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: RequestsColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: RequestsColors.textMuted,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _requestIcon(RequestTypeItem requestType) {
    final value = '${requestType.iconName} ${requestType.code}'
        .toLowerCase()
        .trim();

    if (value.contains('absence') || value.contains('nghi')) {
      return Icons.event_busy_outlined;
    }
    if (value.contains('confirm') || value.contains('verified')) {
      return Icons.verified_user_outlined;
    }
    if (value.contains('tuition') || value.contains('fee')) {
      return Icons.receipt_long_outlined;
    }

    return Icons.edit_note_rounded;
  }

  Color _requestColor(String code) {
    final normalized = code.toLowerCase();

    if (normalized.contains('confirm')) {
      return RequestsColors.requestConfirmation;
    }
    if (normalized.contains('tuition') || normalized.contains('fee')) {
      return RequestsColors.requestTuition;
    }
    if (normalized.contains('other')) return RequestsColors.requestOther;

    return RequestsColors.primary;
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(RequestsStrings.createRequestComingSoon)),
    );
  }
}
