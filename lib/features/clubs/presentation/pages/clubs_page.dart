import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/club_models.dart';
import '../../domain/usecases/get_clubs_usecase.dart';
import '../constants/clubs_colors.dart';
import '../constants/clubs_strings.dart';

part '../widgets/club_card.dart';
part '../widgets/clubs_header.dart';
part '../widgets/clubs_hero_card.dart';
part '../widgets/clubs_message_card.dart';
part '../widgets/clubs_section_title.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  late final GetClubsUseCase _getClubsUseCase;

  List<ClubItem> _clubs = const [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _getClubsUseCase = getIt<GetClubsUseCase>();
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final clubs = await _getClubsUseCase();

      if (!mounted) return;

      setState(() {
        _clubs = clubs;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClubsColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: ClubsColors.primary,
          onRefresh: _loadClubs,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            children: [
              _ClubsHeader(onBack: () => Navigator.of(context).maybePop()),
              const SizedBox(height: 18),
              _ClubsHeroCard(totalClubs: _clubs.length),
              if (_hasError) ...[
                const SizedBox(height: 16),
                _ClubsMessageCard(
                  icon: Icons.cloud_off_rounded,
                  title: ClubsStrings.loadFailed,
                  message: ClubsStrings.emptyMessage,
                  onRetry: _loadClubs,
                ),
              ],
              const SizedBox(height: 20),
              const _ClubsSectionTitle(title: ClubsStrings.clubListTitle),
              const SizedBox(height: 10),
              _buildClubList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }

  Widget _buildClubList() {
    if (_isLoading && _clubs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 28),
          child: CircularProgressIndicator(color: ClubsColors.primary),
        ),
      );
    }

    if (_clubs.isEmpty) {
      return const _ClubsMessageCard(
        icon: Icons.diversity_3_rounded,
        title: ClubsStrings.emptyTitle,
        message: ClubsStrings.emptyMessage,
      );
    }

    return Column(
      children: [
        for (final club in _clubs) ...[
          _ClubCard(club: club),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
