part of '../pages/semester_grades_page.dart';

class _SemesterSwitcher extends StatelessWidget {
  final List<_SemesterOption> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _SemesterSwitcher({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SemesterGradeSizes.switcherPadding),
      decoration: BoxDecoration(
        color: SemesterGradeColors.surface,
        borderRadius: BorderRadius.circular(SemesterGradeSizes.switcherRadius),
        border: Border.all(color: SemesterGradeColors.border),
      ),
      child: Row(
        children: [
          for (var index = 0; index < options.length; index++)
            Expanded(
              child: _SemesterTab(
                option: options[index],
                isSelected: selectedIndex == index,
                onTap: () => onSelected(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _SemesterTab extends StatelessWidget {
  final _SemesterOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SemesterTab({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: SemesterGradeSizes.switcherAnimationMs,
      ),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected
            ? SemesterGradeColors.primarySoft
            : SemesterGradeColors.transparent,
        borderRadius: BorderRadius.circular(
          SemesterGradeSizes.switcherTabRadius,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          SemesterGradeSizes.switcherTabRadius,
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: SemesterGradeSizes.switcherTabPaddingVertical,
          ),
          child: Text(
            option.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? SemesterGradeColors.primary
                  : SemesterGradeColors.textMuted,
              fontSize: SemesterGradeSizes.switcherLabelSize,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
