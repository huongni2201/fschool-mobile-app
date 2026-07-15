part of '../pages/teacher_home_page.dart';

class _TeacherClassScopeCard extends StatelessWidget {
  final TeacherDashboard dashboard;

  const _TeacherClassScopeCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final homeroom = dashboard.homeroomClass;
    final classes = dashboard.managedClasses.take(4).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (homeroom != null) ...[
          _TeacherInfoCard(child: _HomeroomContent(homeroom: homeroom)),
          const SizedBox(height: 18),
        ],
        _TeacherInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TeacherSectionHeader(
                title: TeacherHomeStrings.teachingScopeTitle,
              ),
              const SizedBox(height: 10),
              if (classes.isEmpty)
                const _TeacherEmptyContent(
                  icon: Icons.groups_2_outlined,
                  title: TeacherHomeStrings.noManagedClassTitle,
                  message: TeacherHomeStrings.noManagedClassMessage,
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final item in classes) _ClassScopeChip(summary: item),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeroomContent extends StatelessWidget {
  final TeacherClassSummary homeroom;

  const _HomeroomContent({required this.homeroom});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: TeacherHomeColors.blue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.workspace_premium_outlined,
            color: TeacherHomeColors.blue,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                TeacherHomeStrings.homeroomTitle,
                style: TextStyle(
                  color: TeacherHomeColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                homeroom.name,
                style: const TextStyle(
                  color: TeacherHomeColors.ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${homeroom.studentCount} ${TeacherHomeStrings.studentCountSuffix}',
                style: const TextStyle(
                  color: TeacherHomeColors.muted,
                  fontSize: 12,
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

class _ClassScopeChip extends StatelessWidget {
  final TeacherClassSummary summary;

  const _ClassScopeChip({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 138),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TeacherHomeColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TeacherHomeColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            summary.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: TeacherHomeColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            summary.subjectName ?? summary.roleLabel,
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
    );
  }
}
