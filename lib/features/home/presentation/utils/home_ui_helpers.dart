part of '../pages/home_page.dart';

Color _scheduleAccent(HomeScheduleStatus status) {
  return switch (status) {
    HomeScheduleStatus.done => AppColors.homeDone,
    HomeScheduleStatus.live => AppColors.homeOrange,
    HomeScheduleStatus.next => AppColors.homeNext,
    HomeScheduleStatus.normal => AppColors.homeTextMuted,
  };
}

Color _gradeColor(double? score) {
  if (score == null) return AppColors.homeTextMuted;
  if (score >= 8) return AppColors.homeOrange;
  if (score >= 6.5) return AppColors.homeGradeAverage;
  if (score >= 5) return AppColors.homeGradeLow;

  return AppColors.homeGradePoor;
}

String _homeErrorMessage(Object? error) {
  if (error == null) {
    return AppStrings.homeLoadDataFailed;
  }

  if (error is DioException) {
    final backendMessage = _extractBackendMessage(error.response?.data);

    if (backendMessage != null) return backendMessage;

    final statusCode = error.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return AppStrings.homeSessionExpired;
    }

    if (statusCode != null && statusCode >= 500) {
      return AppStrings.serverError;
    }

    return AppStrings.homeConnectionErrorDetailed;
  }

  if (error is AppException) return error.message;

  return AppStrings.homeLoadDataFailed;
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
