part of '../pages/profile_page.dart';

class _SupportPage extends StatelessWidget {
  final StudentProfile? profile;

  const _SupportPage({required this.profile});

  @override
  Widget build(BuildContext context) {
    return _ProfileDetailShell(
      title: ProfileStrings.supportTitle,
      subtitle: ProfileStrings.supportSubtitle,
      icon: Icons.support_agent_rounded,
      children: [
        _SupportContactCard(
          icon: Icons.phone_in_talk_outlined,
          title: ProfileStrings.hotlineTitle,
          value: ProfileStrings.hotlineValue,
          onCopy: () => _copySupportInfo(context, ProfileStrings.hotlineValue),
        ),
        const SizedBox(height: 12),
        _SupportContactCard(
          icon: Icons.mail_outline_rounded,
          title: ProfileStrings.emailSupportTitle,
          value: ProfileStrings.emailSupportValue,
          onCopy: () =>
              _copySupportInfo(context, ProfileStrings.emailSupportValue),
        ),
        const SizedBox(height: 12),
        _SupportContactCard(
          icon: Icons.location_city_outlined,
          title: ProfileStrings.officeTitle,
          value: ProfileStrings.officeValue,
          onCopy: () => _copySupportInfo(context, ProfileStrings.officeValue),
        ),
        const SizedBox(height: 12),
        _ProfileMessageCard(
          icon: Icons.info_outline_rounded,
          title: ProfileStrings.supportNoteTitle,
          message:
              '${ProfileStrings.supportNoteMessage}\n${ProfileStrings.studentCodeLabel}: ${_profileValue(profile?.studentCode)}',
        ),
      ],
    );
  }

  Future<void> _copySupportInfo(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(ProfileStrings.copiedSupportInfo)),
    );
  }
}

class _SupportContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onCopy;

  const _SupportContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ProfileColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ProfileColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: ProfileColors.surfaceSoft,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: ProfileColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: ProfileColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: ProfileColors.textStrong,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCopy,
            icon: const Icon(Icons.copy_rounded),
            color: ProfileColors.primary,
            tooltip: ProfileStrings.copy,
          ),
        ],
      ),
    );
  }
}
