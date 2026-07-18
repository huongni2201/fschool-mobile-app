import 'package:flutter/material.dart';

import '../../data/models/teacher_dashboard.dart';
import '../constants/teacher_home_colors.dart';

class TeacherClassSummaryCard extends StatelessWidget {
  final TeacherClassSummary classSummary;

  const TeacherClassSummaryCard({super.key, required this.classSummary});

  @override
  Widget build(BuildContext context) {
    final subject = classSummary.subjectName ?? classSummary.roleLabel;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TeacherHomeColors.primary,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: TeacherHomeColors.shadow,
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.groups_2_outlined,
              color: Colors.white,
              size: 26,
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
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
