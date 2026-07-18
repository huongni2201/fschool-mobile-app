import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../data/models/teacher_dashboard.dart';
import '../constants/teacher_home_strings.dart';

List<TeacherClassSummary> classesForTeacherGrades(TeacherDashboard dashboard) {
  final items = <TeacherClassSummary>[
    if (dashboard.homeroomClass != null) dashboard.homeroomClass!,
    ...dashboard.managedClasses,
  ];
  final seen = <String>{};

  return items
      .where((item) {
        final key = item.id.isEmpty ? item.name : item.id;
        if (seen.contains(key)) return false;
        seen.add(key);

        return true;
      })
      .toList(growable: false);
}

String teacherFlowErrorMessage(Object? error) {
  if (error == null) return TeacherHomeStrings.loadFailedMessage;

  if (error is DioException) {
    final statusCode = error.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return TeacherHomeStrings.sessionExpired;
    }

    return TeacherHomeStrings.connectionError;
  }

  if (error is AppException) return error.message;

  return TeacherHomeStrings.loadFailedMessage;
}
