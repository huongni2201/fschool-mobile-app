part of '../pages/parent_home_page.dart';

class _ParentHomeLoadingView extends StatelessWidget {
  const _ParentHomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _SkeletonBox(width: double.infinity, height: 54)),
            const SizedBox(width: 10),
            const _SkeletonCircle(size: 44),
            const SizedBox(width: 10),
            const _SkeletonCircle(size: 44),
          ],
        ),
        const SizedBox(height: 18),
        _SkeletonBox(width: double.infinity, height: 84),
        const SizedBox(height: 18),
        _SkeletonBox(width: double.infinity, height: 220),
        const SizedBox(height: 20),
        _SkeletonBox(width: 180, height: 26),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.45,
          children: List.generate(
            4,
            (_) => _SkeletonBox(width: double.infinity, height: 110),
          ),
        ),
      ],
    );
  }
}

class _ParentHomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onLogout;

  const _ParentHomeErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return _CenteredStateCard(
      icon: Icons.cloud_off_rounded,
      title: ParentHomeStrings.loadFailedTitle,
      message: message,
      primaryLabel: ParentHomeStrings.reload,
      onPrimary: onRetry,
      secondaryLabel: ParentHomeStrings.logoutAndLoginAgain,
      onSecondary: onLogout,
    );
  }
}

class _ParentHomeEmptyStudentsView extends StatelessWidget {
  final String? parentName;
  final VoidCallback onNotificationTap;
  final VoidCallback onLogout;
  final VoidCallback onRetry;

  const _ParentHomeEmptyStudentsView({
    super.key,
    required this.parentName,
    required this.onNotificationTap,
    required this.onLogout,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ParentHomeHeader(
          parentName: parentName,
          onNotificationTap: onNotificationTap,
          onLogout: onLogout,
        ),
        const SizedBox(height: 22),
        _CenteredStateCard(
          icon: Icons.family_restroom_rounded,
          title: ParentHomeStrings.emptyStudentsTitle,
          message: ParentHomeStrings.emptyStudentsMessage,
          primaryLabel: ParentHomeStrings.reload,
          onPrimary: onRetry,
        ),
      ],
    );
  }
}

class _InlineParentHomeWarning extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineParentHomeWarning({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ParentHomeColors.warningBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ParentHomeColors.warningBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.homeOrange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: ParentHomeColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(ParentHomeStrings.reload),
          ),
        ],
      ),
    );
  }
}

class _CenteredStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const _CenteredStateCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: ParentHomeColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.homeOrangeSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.homeOrange, size: 34),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ParentHomeColors.ink,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ParentHomeColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPrimary,
              child: Text(primaryLabel),
            ),
          ),
          if (secondaryLabel != null && onSecondary != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
          ],
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.homeSkeleton,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  final double size;

  const _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.homeSkeleton,
        shape: BoxShape.circle,
      ),
    );
  }
}
