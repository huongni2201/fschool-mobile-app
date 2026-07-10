import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/request_display_models.dart';
import '../../domain/usecases/get_request_types_usecase.dart';
import '../../domain/usecases/get_student_requests_usecase.dart';
import '../constants/requests_colors.dart';
import '../constants/requests_strings.dart';

part '../widgets/recent_request_card.dart';
part '../widgets/request_section_title.dart';
part '../widgets/request_type_card.dart';
part '../widgets/requests_header.dart';
part '../widgets/requests_hero_card.dart';
part '../widgets/requests_message_card.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  late final GetRequestTypesUseCase _getRequestTypesUseCase;
  late final GetStudentRequestsUseCase _getStudentRequestsUseCase;

  List<RequestTypeItem> _requestTypes = const [];
  List<StudentRequestItem> _recentRequests = const [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _getRequestTypesUseCase = getIt<GetRequestTypesUseCase>();
    _getStudentRequestsUseCase = getIt<GetStudentRequestsUseCase>();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final requestTypes = await _getRequestTypesUseCase();
      final recentRequests = await _getStudentRequestsUseCase(limit: 10);

      if (!mounted) return;

      setState(() {
        _requestTypes = requestTypes;
        _recentRequests = recentRequests;
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

  Future<void> _openCreateRequest(RequestTypeItem requestType) async {
    final created = await Navigator.of(
      context,
    ).pushNamed(RouterNames.createRequest, arguments: requestType);

    if (created == true) {
      await _loadRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RequestsColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: RequestsColors.primary,
          onRefresh: _loadRequests,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RequestsHeader(onBack: () => Navigator.of(context).maybePop()),
                const SizedBox(height: 18),
                const _RequestsHeroCard(),
                if (_hasError) ...[
                  const SizedBox(height: 16),
                  _RequestsMessageCard(
                    icon: Icons.cloud_off_rounded,
                    title: RequestsStrings.loadFailed,
                    message: RequestsStrings.noRequestTypesMessage,
                    onRetry: _loadRequests,
                  ),
                ],
                const SizedBox(height: 20),
                const _RequestSectionTitle(
                  title: RequestsStrings.createRequestTitle,
                ),
                const SizedBox(height: 10),
                _buildRequestTypes(),
                const SizedBox(height: 20),
                const _RequestSectionTitle(
                  title: RequestsStrings.recentRequestsTitle,
                ),
                const SizedBox(height: 10),
                _buildRecentRequests(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }

  Widget _buildRequestTypes() {
    if (_isLoading && _requestTypes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 22),
          child: CircularProgressIndicator(color: RequestsColors.primary),
        ),
      );
    }

    if (_requestTypes.isEmpty) {
      return const _RequestsMessageCard(
        icon: Icons.edit_document,
        title: RequestsStrings.noRequestTypesTitle,
        message: RequestsStrings.noRequestTypesMessage,
      );
    }

    return Column(
      children: [
        for (final requestType in _requestTypes) ...[
          _RequestTypeCard(
            requestType: requestType,
            onTap: () => _openCreateRequest(requestType),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildRecentRequests() {
    if (_isLoading && _recentRequests.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_recentRequests.isEmpty) {
      return const _RequestsMessageCard(
        icon: Icons.description_outlined,
        title: RequestsStrings.noRequestsTitle,
        message: RequestsStrings.noRequestsMessage,
      );
    }

    return Column(
      children: [
        for (final request in _recentRequests) ...[
          _RecentRequestCard(request: request),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
