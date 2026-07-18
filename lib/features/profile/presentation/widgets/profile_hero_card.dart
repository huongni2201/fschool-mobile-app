part of '../pages/profile_page.dart';

class _ProfileHeroCard extends StatelessWidget {
  final StudentProfile? profile;
  final bool isLoading;

  const _ProfileHeroCard({required this.profile, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final isTeacher = TokenStorage.isTeacher;
    final profileName =
        profile?.fullName ??
        (isTeacher
            ? ProfileStrings.defaultTeacherName
            : ProfileStrings.defaultStudentName);
    final avatarText =
        profile?.avatarText ??
        (isTeacher
            ? ProfileStrings.defaultTeacherAvatar
            : ProfileStrings.defaultAvatar);
    final profileCode = profile?.studentCode;
    final codeFallback = isTeacher
        ? ProfileStrings.teacherCodeFallback
        : ProfileStrings.studentCodeFallback;
    final codePrefix = isTeacher
        ? ProfileStrings.teacherCodePrefix
        : ProfileStrings.studentCodePrefix;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ProfileColors.heroGradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: ProfileColors.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: ProfileColors.surface.withValues(alpha: 0.18),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: ProfileColors.surface,
                      strokeWidth: 2.4,
                    ),
                  )
                : Text(
                    avatarText,
                    style: const TextStyle(
                      color: ProfileColors.surface,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ProfileColors.surface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profileCode == null
                      ? codeFallback
                      : '$codePrefix: $profileCode',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ProfileColors.heroTextMuted,
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
