import 'package:flutter/material.dart';

import '../../data/models/teacher_dashboard.dart';
import '../constants/teacher_home_colors.dart';
import '../constants/teacher_home_strings.dart';

class TeacherGradeClassCard extends StatelessWidget {
  final TeacherClassSummary classSummary;
  final VoidCallback onTap;

  const TeacherGradeClassCard({
    super.key,
    required this.classSummary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subject = classSummary.subjectName ?? classSummary.roleLabel;

    return Material(
      color: TeacherHomeColors.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: TeacherHomeColors.border),
            boxShadow: const [
              BoxShadow(
                color: TeacherHomeColors.shadow,
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: TeacherHomeColors.amber.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.groups_2_outlined,
                  color: TeacherHomeColors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classSummary.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TeacherHomeColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$subject - ${classSummary.studentCount} ${TeacherHomeStrings.studentCountSuffix}',
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
}
