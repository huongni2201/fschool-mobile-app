enum TuitionFeeStatus { paid, due, overdue, upcoming, unknown }

class TuitionOverview {
  final String semester;
  final String studentName;
  final String className;
  final num? totalAmount;
  final String totalAmountLabel;
  final num? paidAmount;
  final String paidAmountLabel;
  final num? remainingAmount;
  final String remainingAmountLabel;
  final DateTime? nextDueDate;
  final String nextDueDateLabel;
  final double progress;
  final String statusLabel;
  final TuitionPaymentInfo paymentInfo;
  final List<TuitionFeeItem> feeItems;
  final List<TuitionTransaction> transactions;

  const TuitionOverview({
    required this.semester,
    required this.studentName,
    required this.className,
    required this.totalAmount,
    required this.totalAmountLabel,
    required this.paidAmount,
    required this.paidAmountLabel,
    required this.remainingAmount,
    required this.remainingAmountLabel,
    required this.nextDueDate,
    required this.nextDueDateLabel,
    required this.progress,
    required this.statusLabel,
    required this.paymentInfo,
    required this.feeItems,
    required this.transactions,
  });

  factory TuitionOverview.fromJson(Map<String, dynamic> json) {
    final payload = _payload(json);
    final summary = _mapFromObject(
      payload['summary'] ?? payload['overview'] ?? payload['tuitionSummary'],
    );
    final source = {...payload, ...summary};
    final student = _mapFromObject(
      source['student'] ?? source['studentInfo'] ?? source['profile'],
    );
    final paymentInfo = _mapFromObject(
      source['paymentInfo'] ?? source['bankInfo'] ?? source['payment'],
    );
    final totalAmount = _numFromKeys(source, const [
      'totalAmount',
      'total',
      'totalTuition',
      'amountTotal',
    ]);
    final paidAmount = _numFromKeys(source, const [
      'paidAmount',
      'paid',
      'amountPaid',
      'totalPaid',
    ]);
    final explicitRemainingAmount = _numFromKeys(source, const [
      'remainingAmount',
      'remaining',
      'balance',
      'debt',
      'unpaidAmount',
    ]);
    final remainingAmount =
        explicitRemainingAmount ??
        (totalAmount == null || paidAmount == null
            ? null
            : totalAmount - paidAmount);
    final nextDueDate = _dateFromKeys(source, const [
      'nextDueDate',
      'dueDate',
      'paymentDueDate',
    ]);

    return TuitionOverview(
      semester:
          _stringFromKeys(source, const [
            'semester',
            'period',
            'periodName',
            'term',
            'schoolYear',
          ]) ??
          '',
      studentName:
          _stringFromKeys(source, const ['studentName', 'learnerName']) ??
          _stringFromKeys(student, const ['name', 'fullName', 'studentName']) ??
          '',
      className:
          _stringFromKeys(source, const ['className', 'class', 'homeroom']) ??
          _stringFromKeys(student, const ['className', 'class', 'homeroom']) ??
          '',
      totalAmount: totalAmount,
      totalAmountLabel:
          _amountLabel(
            source,
            const ['totalAmount', 'total', 'totalTuition', 'amountTotal'],
            const ['totalAmountLabel', 'totalLabel', 'totalText'],
          ) ??
          '',
      paidAmount: paidAmount,
      paidAmountLabel:
          _amountLabel(
            source,
            const ['paidAmount', 'paid', 'amountPaid', 'totalPaid'],
            const ['paidAmountLabel', 'paidLabel', 'paidText'],
          ) ??
          '',
      remainingAmount: remainingAmount,
      remainingAmountLabel:
          _amountLabel(
            source,
            const [
              'remainingAmount',
              'remaining',
              'balance',
              'debt',
              'unpaidAmount',
            ],
            const [
              'remainingAmountLabel',
              'remainingLabel',
              'balanceLabel',
              'debtLabel',
            ],
          ) ??
          (remainingAmount == null ? '' : _currencyLabel(remainingAmount)),
      nextDueDate: nextDueDate,
      nextDueDateLabel: _dateLabel(
        source,
        const ['nextDueDate', 'dueDate', 'paymentDueDate'],
        const ['nextDueDateLabel', 'dueDateLabel', 'paymentDueDateLabel'],
      ),
      progress: _progress(
        source,
        totalAmount: totalAmount,
        paidAmount: paidAmount,
      ),
      statusLabel:
          _stringFromKeys(source, const [
            'statusLabel',
            'statusText',
            'label',
          ]) ??
          '',
      paymentInfo: TuitionPaymentInfo.fromJson(
        paymentInfo.isEmpty ? source : paymentInfo,
      ),
      feeItems: _firstList(source, const [
        'feeItems',
        'fees',
        'items',
        'tuitionItems',
        'payables',
        'charges',
      ]).map(TuitionFeeItem.fromJson).toList(growable: false),
      transactions: _firstList(source, const [
        'transactions',
        'paymentHistory',
        'payments',
        'history',
        'receipts',
      ]).map(TuitionTransaction.fromJson).toList(growable: false),
    );
  }
}

class TuitionPaymentInfo {
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String transferContent;
  final String qrCodeUrl;

  const TuitionPaymentInfo({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.transferContent,
    required this.qrCodeUrl,
  });

  factory TuitionPaymentInfo.fromJson(Map<String, dynamic> json) {
    return TuitionPaymentInfo(
      bankName:
          _stringFromKeys(json, const ['bankName', 'bank', 'bankCode']) ?? '',
      accountNumber:
          _stringFromKeys(json, const [
            'accountNumber',
            'bankAccount',
            'accountNo',
            'bankAccountNumber',
          ]) ??
          '',
      accountName:
          _stringFromKeys(json, const [
            'accountName',
            'accountHolder',
            'beneficiary',
            'bankAccountName',
          ]) ??
          '',
      transferContent:
          _stringFromKeys(json, const [
            'transferContent',
            'content',
            'paymentContent',
            'note',
          ]) ??
          '',
      qrCodeUrl:
          _stringFromKeys(json, const ['qrCodeUrl', 'qrUrl', 'paymentQrUrl']) ??
          '',
    );
  }

  bool get hasAny =>
      bankName.isNotEmpty ||
      accountNumber.isNotEmpty ||
      accountName.isNotEmpty ||
      transferContent.isNotEmpty ||
      qrCodeUrl.isNotEmpty;
}

class TuitionFeeItem {
  final String id;
  final String title;
  final String description;
  final num? amount;
  final String amountLabel;
  final DateTime? dueDate;
  final String dueDateLabel;
  final num? paidAmount;
  final String paidAmountLabel;
  final TuitionFeeStatus status;
  final String statusLabel;

  const TuitionFeeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.amountLabel,
    required this.dueDate,
    required this.dueDateLabel,
    required this.paidAmount,
    required this.paidAmountLabel,
    required this.status,
    required this.statusLabel,
  });

  factory TuitionFeeItem.fromJson(Map<String, dynamic> json) {
    final title =
        _stringFromKeys(json, const ['title', 'name', 'feeName', 'label']) ??
        '';
    final rawStatus =
        _stringFromKeys(json, const ['status', 'state', 'paymentStatus']) ?? '';
    final status = _feeStatus(rawStatus);

    return TuitionFeeItem(
      id:
          _stringFromKeys(json, const ['id', 'feeId', 'code']) ??
          title.toLowerCase().replaceAll(RegExp(r'\s+'), '-'),
      title: title,
      description:
          _stringFromKeys(json, const ['description', 'summary', 'note']) ?? '',
      amount: _numFromKeys(json, const ['amount', 'totalAmount', 'feeAmount']),
      amountLabel:
          _amountLabel(
            json,
            const ['amount', 'totalAmount', 'feeAmount'],
            const ['amountLabel', 'amountText', 'feeAmountLabel'],
          ) ??
          '',
      dueDate: _dateFromKeys(json, const ['dueDate', 'paymentDueDate']),
      dueDateLabel: _dateLabel(
        json,
        const ['dueDate', 'paymentDueDate'],
        const ['dueDateLabel', 'paymentDueDateLabel'],
      ),
      paidAmount: _numFromKeys(json, const [
        'paidAmount',
        'paid',
        'amountPaid',
      ]),
      paidAmountLabel:
          _amountLabel(
            json,
            const ['paidAmount', 'paid', 'amountPaid'],
            const ['paidAmountLabel', 'paidLabel', 'paidText'],
          ) ??
          '',
      status: status,
      statusLabel:
          _stringFromKeys(json, const ['statusLabel', 'statusText']) ?? '',
    );
  }
}

class TuitionTransaction {
  final String id;
  final String title;
  final String method;
  final num? amount;
  final String amountLabel;
  final DateTime? date;
  final String dateLabel;
  final String code;

  const TuitionTransaction({
    required this.id,
    required this.title,
    required this.method,
    required this.amount,
    required this.amountLabel,
    required this.date,
    required this.dateLabel,
    required this.code,
  });

  factory TuitionTransaction.fromJson(Map<String, dynamic> json) {
    final title =
        _stringFromKeys(json, const ['title', 'name', 'description']) ?? '';
    final code =
        _stringFromKeys(json, const [
          'code',
          'transactionCode',
          'receiptCode',
        ]) ??
        '';

    return TuitionTransaction(
      id:
          _stringFromKeys(json, const ['id', 'transactionId', 'receiptId']) ??
          (code.isEmpty ? title : code),
      title: title,
      method:
          _stringFromKeys(json, const ['method', 'paymentMethod', 'channel']) ??
          '',
      amount: _numFromKeys(json, const ['amount', 'paidAmount', 'value']),
      amountLabel:
          _amountLabel(
            json,
            const ['amount', 'paidAmount', 'value'],
            const ['amountLabel', 'amountText', 'paidAmountLabel'],
          ) ??
          '',
      date: _dateFromKeys(json, const ['date', 'paidAt', 'createdAt']),
      dateLabel: _dateLabel(
        json,
        const ['date', 'paidAt', 'createdAt'],
        const ['dateLabel', 'paidAtLabel', 'createdAtLabel'],
      ),
      code: code,
    );
  }
}

Map<String, dynamic> _payload(Map<String, dynamic> json) {
  final data = _mapFromObject(json['data'] ?? json['result']);

  return data.isEmpty ? json : data;
}

Map<String, dynamic> _mapFromObject(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return const {};
}

List<Map<String, dynamic>> _firstList(
  Map<String, dynamic> source,
  List<String> keys,
) {
  for (final key in keys) {
    final value = source[key];

    if (value is List) {
      return value
          .map(_mapFromObject)
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }
  }

  return const [];
}

String? _stringFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = _stringValue(source[key]);

    if (value != null) return value;
  }

  return null;
}

String? _stringValue(Object? value) {
  if (value == null) return null;

  if (value is String) {
    final trimmed = value.trim();

    return trimmed.isEmpty ? null : trimmed;
  }

  if (value is num || value is bool) return value.toString();

  return null;
}

num? _numFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final parsed = _numValue(source[key]);

    if (parsed != null) return parsed;
  }

  return null;
}

num? _numValue(Object? value) {
  if (value is num) return value;
  if (value is! String) return null;

  final compact = value.trim().replaceAll(RegExp(r'[^\d,.\-]'), '');

  if (compact.isEmpty) return null;

  final normalized = _normalizeNumber(compact);

  return num.tryParse(normalized);
}

String _normalizeNumber(String value) {
  if (value.contains(',') && value.contains('.')) {
    if (value.lastIndexOf(',') > value.lastIndexOf('.')) {
      return value.replaceAll('.', '').replaceAll(',', '.');
    }

    return value.replaceAll(',', '');
  }

  if (value.contains(',')) {
    final parts = value.split(',');
    final last = parts.last;

    if (parts.length > 1 && last.length == 3) return parts.join();

    return value.replaceAll(',', '.');
  }

  if (value.contains('.')) {
    final parts = value.split('.');
    final last = parts.last;

    if (parts.length > 1 && last.length == 3) return parts.join();
  }

  return value;
}

DateTime? _dateFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key];

    if (value is DateTime) return value;
    if (value is String) {
      final parsed = DateTime.tryParse(value.trim());

      if (parsed != null) return parsed;
    }
  }

  return null;
}

String _dateLabel(
  Map<String, dynamic> source,
  List<String> dateKeys,
  List<String> labelKeys,
) {
  final label = _stringFromKeys(source, labelKeys);

  if (label != null) return label;

  final date = _dateFromKeys(source, dateKeys);

  if (date == null) {
    return _stringFromKeys(source, dateKeys) ?? '';
  }

  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String? _amountLabel(
  Map<String, dynamic> source,
  List<String> amountKeys,
  List<String> labelKeys,
) {
  final label = _stringFromKeys(source, labelKeys);

  if (label != null) return label;

  for (final key in amountKeys) {
    final value = source[key];

    if (value is num) return _currencyLabel(value);
    if (value is String && value.trim().isNotEmpty) {
      final trimmed = value.trim();
      final compact = trimmed.replaceAll(RegExp(r'[^\d,.\-]'), '');
      final parsed = _numValue(trimmed);

      if (parsed != null && compact == trimmed) return _currencyLabel(parsed);

      return trimmed;
    }
  }

  return null;
}

String _currencyLabel(num value) {
  final rounded = value.round();
  final sign = rounded < 0 ? '-' : '';
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();

  for (var index = 0; index < digits.length; index++) {
    final positionFromEnd = digits.length - index;

    buffer.write(digits[index]);

    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return '$sign$bufferđ';
}

double _progress(
  Map<String, dynamic> source, {
  required num? totalAmount,
  required num? paidAmount,
}) {
  final rawProgress = _numFromKeys(source, const [
    'progress',
    'paymentProgress',
    'paidPercent',
    'percent',
  ]);

  if (rawProgress != null) {
    final normalized = rawProgress > 1 ? rawProgress / 100 : rawProgress;

    return normalized.toDouble().clamp(0, 1).toDouble();
  }

  if (totalAmount == null || paidAmount == null || totalAmount <= 0) return 0;

  return (paidAmount / totalAmount).toDouble().clamp(0, 1).toDouble();
}

TuitionFeeStatus _feeStatus(String status) {
  final normalized = status.toLowerCase().trim();

  if (normalized.contains('paid') ||
      normalized.contains('complete') ||
      normalized.contains('settled') ||
      normalized.contains('đã đóng') ||
      normalized.contains('da dong')) {
    return TuitionFeeStatus.paid;
  }
  if (normalized.contains('overdue') ||
      normalized.contains('late') ||
      normalized.contains('quá hạn') ||
      normalized.contains('qua han')) {
    return TuitionFeeStatus.overdue;
  }
  if (normalized.contains('upcoming') ||
      normalized.contains('future') ||
      normalized.contains('sắp tới') ||
      normalized.contains('sap toi')) {
    return TuitionFeeStatus.upcoming;
  }
  if (normalized.contains('due') ||
      normalized.contains('unpaid') ||
      normalized.contains('pending') ||
      normalized.contains('debt') ||
      normalized.contains('cần đóng') ||
      normalized.contains('can dong')) {
    return TuitionFeeStatus.due;
  }

  return normalized.isEmpty ? TuitionFeeStatus.unknown : TuitionFeeStatus.due;
}
