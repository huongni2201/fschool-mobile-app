import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/student_profile.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';
import '../constants/profile_colors.dart';
import '../constants/profile_strings.dart';

part '../constants/profile_display_data.dart';
part '../models/profile_menu_item.dart';
part '../widgets/profile_error_banner.dart';
part '../widgets/profile_header.dart';
part '../widgets/profile_hero_card.dart';
part '../widgets/profile_logout_button.dart';
part '../widgets/profile_menu_card.dart';
part '../widgets/profile_overview_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final GetStudentProfileUseCase _getProfileUseCase;

  StudentProfile? _profile;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _getProfileUseCase = getIt<GetStudentProfileUseCase>();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final profile = await _getProfileUseCase();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _hasError = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _hasError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await TokenStorage.clear();

    if (!mounted) return;

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(RouterNames.login, (route) => false);
  }

  void _showComingSoon(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(ProfileStrings.featureComingSoon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: ProfileColors.primary,
          onRefresh: _loadProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ProfileHeader(),
                if (_hasError) ...[
                  const SizedBox(height: 14),
                  _ProfileErrorBanner(onRetry: _loadProfile),
                ],
                const SizedBox(height: 18),
                _ProfileHeroCard(
                  profile: _profile,
                  isLoading: _isLoading && _profile == null,
                ),
                const SizedBox(height: 18),
                _ProfileOverviewCard(profile: _profile),
                const SizedBox(height: 20),
                _sectionTitle(ProfileStrings.information),
                const SizedBox(height: 10),
                _ProfileMenuCard(
                  items: _profileMenuItems,
                  onTap: _showComingSoon,
                ),
                const SizedBox(height: 20),
                _sectionTitle(ProfileStrings.settings),
                const SizedBox(height: 10),
                _ProfileLogoutButton(onLogout: _logout),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(
        activeTab: MainBottomNavTab.profile,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: ProfileColors.textStrong,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
