class RequestTypeItem {
  final String code;
  final String name;
  final String description;
  final String iconName;
  final bool requiresDateRange;
  final bool requiresAttachment;
  final List<RequestField> fields;

  const RequestTypeItem({
    required this.code,
    required this.name,
    required this.description,
    required this.iconName,
    required this.requiresDateRange,
    required this.requiresAttachment,
    required this.fields,
  });

  factory RequestTypeItem.fromJson(Map<String, dynamic> json) {
    return RequestTypeItem(
      code:
          _stringFromKeys(json, const ['code', 'typeCode', 'id', 'key']) ?? '',
      name:
          _stringFromKeys(json, const ['name', 'title', 'typeName', 'label']) ??
          'Loại đơn',
      description:
          _stringFromKeys(json, const ['description', 'subtitle', 'note']) ??
          '',
      iconName: _stringFromKeys(json, const ['icon', 'iconName']) ?? '',
      requiresDateRange:
          _boolFromKeys(json, const ['requiresDateRange', 'dateRange']) ??
          false,
      requiresAttachment:
          _boolFromKeys(json, const ['requiresAttachment', 'attachment']) ??
          false,
      fields: _listFromObject(
        json['fields'],
      ).map(RequestField.fromJson).toList(growable: false),
    );
  }
}

class RequestField {
  final String key;
  final String label;
  final String type;
  final bool required;

  const RequestField({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
  });

  factory RequestField.fromJson(Map<String, dynamic> json) {
    return RequestField(
      key: _stringFromKeys(json, const ['key', 'name', 'field']) ?? '',
      label: _stringFromKeys(json, const ['label', 'title']) ?? '',
      type: _stringFromKeys(json, const ['type', 'inputType']) ?? 'text',
      required: _boolFromKeys(json, const ['required', 'isRequired']) ?? false,
    );
  }
}

class StudentRequestItem {
  final String id;
  final String typeCode;
  final String typeName;
  final String title;
  final String status;
  final String statusLabel;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StudentRequestItem({
    required this.id,
    required this.typeCode,
    required this.typeName,
    required this.title,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentRequestItem.fromJson(Map<String, dynamic> json) {
    final status =
        _stringFromKeys(json, const ['status', 'state', 'statusCode']) ?? '';
    final typeName =
        _stringFromKeys(json, const ['typeName', 'requestTypeName', 'name']) ??
        _stringFromKeys(_mapFromObject(json['type']), const [
          'name',
          'title',
        ]) ??
        'Đơn từ';

    return StudentRequestItem(
      id:
          _stringFromKeys(json, const ['id', 'requestId', 'code']) ??
          '$typeName-${DateTime.now().microsecondsSinceEpoch}',
      typeCode:
          _stringFromKeys(json, const ['typeCode', 'requestTypeCode']) ??
          _stringFromKeys(_mapFromObject(json['type']), const ['code', 'id']) ??
          '',
      typeName: typeName,
      title: _stringFromKeys(json, const ['title', 'subject']) ?? typeName,
      status: status,
      statusLabel:
          _stringFromKeys(json, const ['statusLabel', 'statusText', 'label']) ??
          _defaultStatusLabel(status),
      createdAt: _dateFromKeys(json, const [
        'createdAt',
        'createdDate',
        'date',
      ]),
      updatedAt: _dateFromKeys(json, const ['updatedAt', 'updatedDate']),
    );
  }

  String get dateLabel {
    final date = createdAt ?? updatedAt;

    if (date == null) return '--/--/----';

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

Map<String, dynamic> _mapFromObject(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return const {};
}

List<Map<String, dynamic>> _listFromObject(Object? value) {
  if (value is! List) return const [];

  return value
      .map(_mapFromObject)
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
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

bool? _boolFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key];

    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();

      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
  }

  return null;
}

DateTime? _dateFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final raw = _stringValue(source[key]);

    if (raw == null) continue;

    final parsed = DateTime.tryParse(raw);

    if (parsed != null) return parsed;
  }

  return null;
}

String _defaultStatusLabel(String status) {
  final normalized = status.toLowerCase().trim();

  if (normalized.contains('submitted')) return 'Đã gửi';
  if (normalized.contains('processing') || normalized.contains('progress')) {
    return 'Đang xử lý';
  }
  if (normalized.contains('approved')) return 'Đã duyệt';
  if (normalized.contains('rejected')) return 'Từ chối';
  if (normalized.contains('cancelled') || normalized.contains('canceled')) {
    return 'Đã hủy';
  }

  return status.isEmpty ? 'Đang cập nhật' : status;
}
