part of '../pages/tuition_page.dart';

class _PaymentInstructionCard extends StatelessWidget {
  final TuitionPaymentInfo paymentInfo;
  final VoidCallback onCopy;
  final VoidCallback onPayNow;

  const _PaymentInstructionCard({
    required this.paymentInfo,
    required this.onCopy,
    required this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TuitionColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: TuitionColors.primaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: TuitionColors.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: TuitionColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TuitionStrings.paymentInfoTitle,
                      style: TextStyle(
                        color: TuitionColors.textStrong,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      TuitionStrings.paymentInfoDescription,
                      style: TextStyle(
                        color: TuitionColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (paymentInfo.bankName.isNotEmpty)
            _BankInfoRow(
              label: TuitionStrings.bank,
              value: paymentInfo.bankName,
            ),
          if (paymentInfo.accountNumber.isNotEmpty)
            _BankInfoRow(
              label: TuitionStrings.accountNumber,
              value: paymentInfo.accountNumber,
            ),
          if (paymentInfo.accountName.isNotEmpty)
            _BankInfoRow(
              label: TuitionStrings.accountName,
              value: paymentInfo.accountName,
            ),
          if (paymentInfo.transferContent.isNotEmpty)
            _BankInfoRow(
              label: TuitionStrings.transferContent,
              value: paymentInfo.transferContent,
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text(TuitionStrings.copy),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TuitionColors.primaryDark,
                    side: const BorderSide(color: TuitionColors.primaryLight),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPayNow,
                  icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                  label: const Text(TuitionStrings.qrCode),
                  style: FilledButton.styleFrom(
                    backgroundColor: TuitionColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BankInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _BankInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(
                color: TuitionColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: TuitionColors.textStrong,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
