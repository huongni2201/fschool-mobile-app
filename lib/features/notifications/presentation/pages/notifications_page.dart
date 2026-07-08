import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/notification_models.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../constants/notification_colors.dart';
import '../constants/notification_strings.dart';

part '../utils/notification_helpers.dart';
part '../widgets/notification_card.dart';
part '../widgets/notification_filter_bar.dart';
part '../widgets/notification_header.dart';
part '../widgets/notification_hero_card.dart';
part '../widgets/notification_state_views.dart';

enum _NotificationFilter { all, unread }

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationFeed? _feed;
  Object? _error;
  bool _isLoading = true;
  _NotificationFilter _filter = _NotificationFilter.all;

  @override
  void initState() {
    super.initState();

    _getNotificationsUseCase = getIt<GetNotificationsUseCase>();
    _loadNotifications();
  }

  Future<void> _loadNotifications({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final feed = await _getNotificationsUseCase();

      if (!mounted) return;

      setState(() {
        _feed = feed;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
      });

      if (silent && _feed != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_notificationErrorMessage(error))),
        );
      }
    } finally {
      if (mounted && !silent) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshNotifications() {
    return _loadNotifications(silent: true);
  }

  void _selectFilter(_NotificationFilter filter) {
    setState(() {
      _filter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final feed = _feed;

    return Scaffold(
      backgroundColor: NotificationColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: NotificationColors.primary,
          onRefresh: _refreshNotifications,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            children: [
              _NotificationHeader(
                onBack: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _buildContent(feed),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(
        activeTab: MainBottomNavTab.notifications,
      ),
    );
  }

  Widget _buildContent(NotificationFeed? feed) {
    if (_isLoading && feed == null) {
      return const _NotificationLoadingView(
        key: ValueKey('notifications-loading'),
      );
    }

    if (feed == null) {
      return _NotificationErrorView(
        key: const ValueKey('notifications-error'),
        message: _notificationErrorMessage(_error),
        onRetry: _loadNotifications,
      );
    }

    final notifications = _filteredNotifications(feed.notifications);

    return Column(
      key: ValueKey('notifications-content-${_filter.name}-${feed.totalCount}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NotificationHeroCard(feed: feed),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _InlineNotificationWarning(
            message: _notificationErrorMessage(_error),
            onRetry: () => _loadNotifications(silent: true),
          ),
        ],
        const SizedBox(height: 16),
        _NotificationFilterBar(
          selectedFilter: _filter,
          feed: feed,
          onSelected: _selectFilter,
        ),
        const SizedBox(height: 18),
        _NotificationSectionHeader(count: notifications.length),
        const SizedBox(height: 10),
        if (notifications.isEmpty)
          _EmptyNotificationCard(filter: _filter)
        else
          for (var index = 0; index < notifications.length; index++) ...[
            _NotificationCard(notification: notifications[index]),
            if (index != notifications.length - 1) const SizedBox(height: 12),
          ],
      ],
    );
  }

  List<NotificationItem> _filteredNotifications(
    List<NotificationItem> notifications,
  ) {
    return switch (_filter) {
      _NotificationFilter.all => notifications,
      _NotificationFilter.unread =>
        notifications.where((item) => !item.isRead).toList(growable: false),
    };
  }
}
