part of '../pages/home_page.dart';

class _HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onLogout;

  const _HomeErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height - 120),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: AppColors.homeOrangeSoft,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.homeOrange,
                size: 42,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              AppStrings.homeLoadFailedTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.homeTextStrong,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.homeTextMuted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(AppStrings.homeReload),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.homeOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            TextButton(
              onPressed: onLogout,
              child: const Text(AppStrings.homeLogoutAndLoginAgain),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 90, height: 14),
                    SizedBox(height: 10),
                    _SkeletonBox(width: 180, height: 24),
                  ],
                ),
              ),
              _SkeletonBox(width: 44, height: 44, radius: 22),
              SizedBox(width: 10),
              _SkeletonBox(width: 48, height: 48, radius: 24),
            ],
          ),
          const SizedBox(height: 18),
          const _SkeletonBox(width: double.infinity, height: 156, radius: 26),
          const SizedBox(height: 22),
          const _SkeletonBox(width: 160, height: 20),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.92,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              8,
              (_) => const _SkeletonBox(
                width: double.infinity,
                height: 88,
                radius: 20,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const _SkeletonBox(width: double.infinity, height: 154, radius: 22),
          const SizedBox(height: 18),
          const _SkeletonBox(width: double.infinity, height: 204, radius: 22),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.homeSkeleton,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
