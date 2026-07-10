part of '../pages/tuition_page.dart';

class _TuitionFeeCard extends StatelessWidget {
  final TuitionFeeItem item;

  const _TuitionFeeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = _feeStatusColor(item.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TuitionColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: TuitionColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _feeStatusBackground(item.status),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_feeStatusIcon(item.status), color: statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayText(item.title),
                      style: const TextStyle(
                        color: TuitionColors.textStrong,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (item.description.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: TuitionColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _FeeStatusChip(item: item),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: TuitionColors.divider),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _FeeInfo(
                  label: TuitionStrings.amount,
                  value: _displayAmount(item.amountLabel),
                ),
              ),
              Expanded(
                child: _FeeInfo(
                  label: TuitionStrings.paid,
                  value: _displayAmount(item.paidAmountLabel),
                ),
              ),
              Expanded(
                child: _FeeInfo(
                  label: TuitionStrings.dueDate,
                  value: _displayText(item.dueDateLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeeStatusChip extends StatelessWidget {
  final TuitionFeeItem item;

  const _FeeStatusChip({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: _feeStatusBackground(item.status),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _feeStatusLabel(item),
        style: TextStyle(
          color: _feeStatusColor(item.status),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _FeeInfo extends StatelessWidget {
  final String label;
  final String value;

  const _FeeInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: TuitionColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: TuitionColors.textStrong,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
