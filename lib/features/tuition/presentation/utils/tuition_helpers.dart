part of '../pages/tuition_page.dart';

String _tuitionErrorMessage(Object? error) {
  if (error == null) {
    return TuitionStrings.defaultLoadFailed;
  }

  if (error is DioException) {
    final backendMessage = _extractBackendMessage(error.response?.data);

    if (backendMessage != null) return backendMessage;

    final statusCode = error.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return TuitionStrings.sessionExpired;
    }

    if (statusCode != null && statusCode >= 500) {
      return TuitionStrings.serverError;
    }

    return TuitionStrings.connectionError;
  }

  if (error is AppException) return error.message;

  return TuitionStrings.defaultLoadFailed;
}

String? _extractBackendMessage(Object? data) {
  if (data is! Map) return null;

  final message = data['message'] ?? data['error'];

  if (message is String && message.trim().isNotEmpty) {
    return message.trim();
  }

  final nestedData = data['data'];

  if (nestedData is Map) return _extractBackendMessage(nestedData);

  return null;
}

Color _feeStatusColor(TuitionFeeStatus status) {
  return switch (status) {
    TuitionFeeStatus.paid => TuitionColors.green,
    TuitionFeeStatus.due => TuitionColors.primary,
    TuitionFeeStatus.overdue => TuitionColors.error,
    TuitionFeeStatus.upcoming => TuitionColors.warning,
    TuitionFeeStatus.unknown => TuitionColors.textMuted,
  };
}

Color _feeStatusBackground(TuitionFeeStatus status) {
  return switch (status) {
    TuitionFeeStatus.paid => TuitionColors.greenSoft,
    TuitionFeeStatus.due => TuitionColors.primarySoft,
    TuitionFeeStatus.overdue => TuitionColors.errorSoft,
    TuitionFeeStatus.upcoming => TuitionColors.warningSoft,
    TuitionFeeStatus.unknown => TuitionColors.canvas,
  };
}

IconData _feeStatusIcon(TuitionFeeStatus status) {
  return switch (status) {
    TuitionFeeStatus.paid => Icons.verified_rounded,
    TuitionFeeStatus.due => Icons.payments_rounded,
    TuitionFeeStatus.overdue => Icons.warning_amber_rounded,
    TuitionFeeStatus.upcoming => Icons.schedule_rounded,
    TuitionFeeStatus.unknown => Icons.help_outline_rounded,
  };
}

String _feeStatusLabel(TuitionFeeItem item) {
  if (item.statusLabel.trim().isNotEmpty) return item.statusLabel;

  return switch (item.status) {
    TuitionFeeStatus.paid => TuitionStrings.statusPaid,
    TuitionFeeStatus.due => TuitionStrings.statusDue,
    TuitionFeeStatus.overdue => TuitionStrings.statusOverdue,
    TuitionFeeStatus.upcoming => TuitionStrings.statusUpcoming,
    TuitionFeeStatus.unknown => TuitionStrings.statusUnknown,
  };
}

String _overviewStatusLabel(TuitionOverview overview) {
  if (overview.statusLabel.trim().isNotEmpty) return overview.statusLabel;
  if (overview.remainingAmount == null) return TuitionStrings.statusUnknown;

  return overview.remainingAmount! > 0
      ? TuitionStrings.statusPaymentDue
      : TuitionStrings.statusComplete;
}

String _displayText(String value) {
  final trimmed = value.trim();

  return trimmed.isEmpty ? TuitionStrings.updating : trimmed;
}

String _displayAmount(String value) {
  final trimmed = value.trim();

  if (trimmed.isEmpty || trimmed == TuitionStrings.noData) {
    return TuitionStrings.noData;
  }

  return trimmed;
}

String _paymentInfoCopyText(TuitionPaymentInfo paymentInfo) {
  return [
    if (paymentInfo.bankName.isNotEmpty)
      '${TuitionStrings.bank}: ${paymentInfo.bankName}',
    if (paymentInfo.accountNumber.isNotEmpty)
      '${TuitionStrings.accountNumber}: ${paymentInfo.accountNumber}',
    if (paymentInfo.accountName.isNotEmpty)
      '${TuitionStrings.accountName}: ${paymentInfo.accountName}',
    if (paymentInfo.transferContent.isNotEmpty)
      '${TuitionStrings.transferContent}: ${paymentInfo.transferContent}',
    if (paymentInfo.qrCodeUrl.isNotEmpty)
      '${TuitionStrings.qrCode}: ${paymentInfo.qrCodeUrl}',
  ].join('\n');
}
