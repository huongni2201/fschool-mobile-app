import 'package:flutter/material.dart';

import '../constants/teacher_home_colors.dart';
import '../constants/teacher_home_strings.dart';

class TeacherFlowTopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const TeacherFlowTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: TeacherHomeColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: TeacherHomeColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: TeacherHomeColors.ink,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: TeacherHomeColors.ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: TeacherHomeColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TeacherFlowLoadingCard extends StatelessWidget {
  const TeacherFlowLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: TeacherHomeColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TeacherHomeColors.border),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: TeacherHomeColors.primary),
      ),
    );
  }
}

class TeacherFlowSectionHeader extends StatelessWidget {
  final String title;

  const TeacherFlowSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: TeacherHomeColors.ink,
        fontSize: 17,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class TeacherFlowMessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const TeacherFlowMessageCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
      decoration: BoxDecoration(
        color: TeacherHomeColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TeacherHomeColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: TeacherHomeColors.primary, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TeacherHomeColors.ink,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: TeacherHomeColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(TeacherHomeStrings.reload),
              style: FilledButton.styleFrom(
                backgroundColor: TeacherHomeColors.primary,
                foregroundColor: TeacherHomeColors.surface,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
