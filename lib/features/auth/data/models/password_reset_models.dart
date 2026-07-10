class PasswordResetOtpRequest {
  final String phoneNumber;

  const PasswordResetOtpRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber};
  }
}

class PasswordResetOtpVerificationRequest {
  final String phoneNumber;
  final String otp;

  const PasswordResetOtpVerificationRequest({
    required this.phoneNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'otp': otp};
  }
}

class PasswordResetRequest {
  final String phoneNumber;
  final String otp;
  final String? resetToken;
  final String newPassword;

  const PasswordResetRequest({
    required this.phoneNumber,
    required this.otp,
    required this.newPassword,
    this.resetToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otp': otp,
      if (resetToken != null && resetToken!.isNotEmpty)
        'resetToken': resetToken,
      'newPassword': newPassword,
    };
  }
}

class PasswordResetVerification {
  final String? resetToken;

  const PasswordResetVerification({this.resetToken});

  factory PasswordResetVerification.fromJson(Map<String, dynamic> json) {
    final data = _mapFromObject(json['data'] ?? json['result']);
    final source = data.isEmpty ? json : data;
    final token = _stringFromKeys(source, const [
      'resetToken',
      'token',
      'verificationToken',
    ]);

    return PasswordResetVerification(resetToken: token);
  }
}

Map<String, dynamic> _mapFromObject(Object? value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return const {};
}

String? _stringFromKeys(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key];

    if (value is String && value.trim().isNotEmpty) return value.trim();
  }

  return null;
}
