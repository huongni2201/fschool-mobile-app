part of '../pages/tuition_page.dart';

class _TuitionSummaryGrid extends StatelessWidget {
  final TuitionOverview overview;

  const _TuitionSummaryGrid({required this.overview});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniSummaryCard(
            icon: Icons.receipt_long_rounded,
            title: TuitionStrings.totalFee,
            value: _displayAmount(overview.totalAmountLabel),
            color: TuitionColors.blue,
            background: TuitionColors.blueSoft,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniSummaryCard(
            icon: Icons.verified_rounded,
            title: TuitionStrings.paidFee,
            value: _displayAmount(overview.paidAmountLabel),
            color: TuitionColors.green,
            background: TuitionColors.greenSoft,
          ),
        ),
      ],
    );
  }
}

class _MiniSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final Color background;

  const _MiniSummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TuitionColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TuitionColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: TuitionColors.textMuted,
              fontSize: 12,
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
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
