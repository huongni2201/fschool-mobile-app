part of '../pages/tuition_page.dart';

class _TransactionCard extends StatelessWidget {
  final TuitionTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final detail = [
      if (transaction.method.isNotEmpty) transaction.method,
      if (transaction.code.isNotEmpty) transaction.code,
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TuitionColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TuitionColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: TuitionColors.greenSoft,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: TuitionColors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayText(transaction.title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: TuitionColors.textStrong,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _displayText(detail),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: TuitionColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _displayAmount(transaction.amountLabel),
                style: const TextStyle(
                  color: TuitionColors.green,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _displayText(transaction.dateLabel),
                style: const TextStyle(
                  color: TuitionColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
