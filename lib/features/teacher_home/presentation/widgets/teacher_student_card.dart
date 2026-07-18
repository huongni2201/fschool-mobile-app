import 'package:flutter/material.dart';

import '../../data/models/teacher_grade_models.dart';
import '../constants/teacher_home_colors.dart';

class TeacherStudentCard extends StatelessWidget {
  final TeacherGradeStudent student;
  final VoidCallback onTap;

  const TeacherStudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TeacherHomeColors.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: TeacherHomeColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: TeacherHomeColors.blue.withValues(alpha: 0.12),
                child: Text(
                  student.avatarText,
                  style: const TextStyle(
                    color: TeacherHomeColors.blue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TeacherHomeColors.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _studentSubtitle(student),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TeacherHomeColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: TeacherHomeColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _studentSubtitle(TeacherGradeStudent student) {
    final code = student.code;

    if (code == null || code.trim().isEmpty) return student.statusLabel;

    return '${student.statusLabel} - Mã HS: $code';
  }
}
