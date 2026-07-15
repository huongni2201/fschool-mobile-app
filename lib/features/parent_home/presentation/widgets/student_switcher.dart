part of '../pages/parent_home_page.dart';

class _StudentSwitcher extends StatelessWidget {
  final List<ParentStudent> students;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _StudentSwitcher({
    required this.students,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: students.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final student = students[index];
          final isSelected = selectedIndex == index;

          return _StudentChip(
            student: student,
            isSelected: isSelected,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _StudentChip extends StatelessWidget {
  final ParentStudent student;
  final bool isSelected;
  final VoidCallback onTap;

  const _StudentChip({
    required this.student,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 230,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.homeOrange : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppColors.homeOrange : ParentHomeColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: ParentHomeColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _AvatarBadge(
                  text: student.avatarText,
                  foreground: isSelected ? AppColors.homeOrange : Colors.white,
                  background: isSelected ? Colors.white : AppColors.homeOrange,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : ParentHomeColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _studentSubtitle(student),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.78)
                              : ParentHomeColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _studentSubtitle(ParentStudent student) {
    final code = student.code;

    if (code == null || code.trim().isEmpty) {
      return '${ParentHomeStrings.classLabel} ${student.className}';
    }

    return '${ParentHomeStrings.classLabel} ${student.className} - $code';
  }
}

class _AvatarBadge extends StatelessWidget {
  final String text;
  final Color foreground;
  final Color background;

  const _AvatarBadge({
    required this.text,
    required this.foreground,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
