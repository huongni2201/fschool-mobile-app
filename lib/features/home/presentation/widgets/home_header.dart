part of '../pages/home_page.dart';

class _HomeHeader extends StatelessWidget {
  final HomeDashboard dashboard;
  final VoidCallback onNotificationTap;
  final VoidCallback onLogout;

  const _HomeHeader({
    required this.dashboard,
    required this.onNotificationTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.homeGreeting,
                style: TextStyle(
                  color: AppColors.homeTextMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dashboard.studentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.homeTextStrong,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              if (dashboard.studentCode != null) ...[
                const SizedBox(height: 4),
                Text(
                  AppStrings.homeStudentCode(dashboard.studentCode!),
                  style: const TextStyle(
                    color: AppColors.homeTextMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        _NotificationButton(onPressed: onNotificationTap),
        const SizedBox(width: 10),
        PopupMenuButton<_HomeMenuAction>(
          offset: const Offset(0, 12),
          onSelected: (action) {
            if (action == _HomeMenuAction.logout) onLogout();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _HomeMenuAction.logout,
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 10),
                  Text(AppStrings.logout),
                ],
              ),
            ),
          ],
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.homeOrange,
            child: Text(
              dashboard.avatarText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _HomeMenuAction { logout }

class _NotificationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _NotificationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.homeOrangeSoft),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.homeOrange,
              size: 25,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.homeOrange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
