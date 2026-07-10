part of '../pages/profile_page.dart';

class _ParentInfoPage extends StatelessWidget {
  final StudentProfile? profile;

  const _ParentInfoPage({required this.profile});

  @override
  Widget build(BuildContext context) {
    final parents = profile?.parents ?? const <ParentContact>[];

    return _ProfileDetailShell(
      title: ProfileStrings.parentInfoTitle,
      subtitle: ProfileStrings.parentDetailSubtitle,
      icon: Icons.family_restroom_outlined,
      children: [
        if (parents.isEmpty)
          const _ProfileMessageCard(
            icon: Icons.family_restroom_outlined,
            title: ProfileStrings.noParentInfoTitle,
            message: ProfileStrings.noParentInfoMessage,
          )
        else
          for (final parent in parents) ...[
            _ParentContactCard(parent: parent),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ParentContactCard extends StatelessWidget {
  final ParentContact parent;

  const _ParentContactCard({required this.parent});

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      children: [
        _InfoRow(
          icon: Icons.person_outline_rounded,
          label: ProfileStrings.fullNameLabel,
          value: _profileValue(parent.name),
        ),
        _InfoRow(
          icon: Icons.family_restroom_outlined,
          label: ProfileStrings.relationLabel,
          value: _profileValue(parent.relation),
        ),
        _InfoRow(
          icon: Icons.phone_outlined,
          label: ProfileStrings.phoneLabel,
          value: _profileValue(parent.phone),
        ),
        _InfoRow(
          icon: Icons.mail_outline_rounded,
          label: ProfileStrings.emailLabel,
          value: _profileValue(parent.email),
        ),
        _InfoRow(
          icon: Icons.home_outlined,
          label: ProfileStrings.addressLabel,
          value: _profileValue(parent.address),
          isLast: true,
        ),
      ],
    );
  }
}
