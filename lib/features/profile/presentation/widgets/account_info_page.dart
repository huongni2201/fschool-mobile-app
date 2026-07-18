part of '../pages/profile_page.dart';

class _AccountInfoPage extends StatelessWidget {
  final StudentProfile? profile;

  const _AccountInfoPage({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isTeacher = TokenStorage.isTeacher;

    return _ProfileDetailShell(
      title: ProfileStrings.accountInfoTitle,
      subtitle: ProfileStrings.accountDetailSubtitle,
      icon: Icons.badge_outlined,
      children: [
        _InfoCard(
          children: [
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: ProfileStrings.fullNameLabel,
              value: _profileValue(profile?.fullName),
            ),
            _InfoRow(
              icon: Icons.confirmation_number_outlined,
              label: isTeacher
                  ? ProfileStrings.teacherCodeLabel
                  : ProfileStrings.studentCodeLabel,
              value: _profileValue(profile?.studentCode),
            ),
            _InfoRow(
              icon: Icons.groups_2_outlined,
              label: isTeacher
                  ? ProfileStrings.departmentLabel
                  : ProfileStrings.classLabel,
              value: _profileValue(profile?.className),
            ),
            _InfoRow(
              icon: Icons.location_city_outlined,
              label: ProfileStrings.campusLabel,
              value: _profileValue(profile?.campus),
            ),
            _InfoRow(
              icon: Icons.calendar_month_outlined,
              label: isTeacher
                  ? ProfileStrings.roleLabel
                  : ProfileStrings.schoolYearLabel,
              value: _profileValue(profile?.schoolYear),
            ),
            _InfoRow(
              icon: Icons.phone_outlined,
              label: ProfileStrings.phoneLabel,
              value: _profileValue(profile?.phone),
            ),
            _InfoRow(
              icon: Icons.mail_outline_rounded,
              label: ProfileStrings.emailLabel,
              value: _profileValue(profile?.email),
            ),
            _InfoRow(
              icon: Icons.cake_outlined,
              label: ProfileStrings.dateOfBirthLabel,
              value: _profileValue(profile?.dateOfBirth),
            ),
            _InfoRow(
              icon: Icons.wc_outlined,
              label: ProfileStrings.genderLabel,
              value: _profileValue(profile?.gender),
            ),
            _InfoRow(
              icon: Icons.home_outlined,
              label: ProfileStrings.addressLabel,
              value: _profileValue(profile?.address),
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }
}
