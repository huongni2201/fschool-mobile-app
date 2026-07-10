import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/tuition_models.dart';
import '../../domain/usecases/get_tuition_overview_usecase.dart';
import '../constants/tuition_colors.dart';
import '../constants/tuition_strings.dart';

part '../utils/tuition_helpers.dart';
part '../widgets/payment_instruction_card.dart';
part '../widgets/transaction_card.dart';
part '../widgets/tuition_fee_card.dart';
part '../widgets/tuition_header.dart';
part '../widgets/tuition_hero_card.dart';
part '../widgets/tuition_section_title.dart';
part '../widgets/tuition_state_views.dart';
part '../widgets/tuition_summary_grid.dart';

class TuitionPage extends StatefulWidget {
  const TuitionPage({super.key});

  @override
  State<TuitionPage> createState() => _TuitionPageState();
}

class _TuitionPageState extends State<TuitionPage> {
  late final GetTuitionOverviewUseCase _getTuitionOverviewUseCase;

  TuitionOverview? _overview;
  Object? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getTuitionOverviewUseCase = getIt<GetTuitionOverviewUseCase>();
    _loadTuition();
  }

  Future<void> _loadTuition({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final overview = await _getTuitionOverviewUseCase();

      if (!mounted) return;

      setState(() {
        _overview = overview;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
      });

      if (silent && _overview != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_tuitionErrorMessage(error))));
      }
    } finally {
      if (mounted && !silent) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshTuition() {
    return _loadTuition(silent: true);
  }

  Future<void> _copyPaymentInfo(TuitionPaymentInfo paymentInfo) async {
    await Clipboard.setData(
      ClipboardData(text: _paymentInfoCopyText(paymentInfo)),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(TuitionStrings.copiedPaymentInfo)),
    );
  }

  void _showPaymentComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(TuitionStrings.paymentComingSoon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overview = _overview;

    return Scaffold(
      backgroundColor: TuitionColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          color: TuitionColors.primary,
          onRefresh: _refreshTuition,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            children: [
              _TuitionHeader(onBack: () => Navigator.of(context).maybePop()),
              const SizedBox(height: 18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _buildContent(overview),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }

  Widget _buildContent(TuitionOverview? overview) {
    if (_isLoading && overview == null) {
      return const _TuitionLoadingView(key: ValueKey('tuition-loading'));
    }

    if (overview == null) {
      return _TuitionErrorView(
        key: const ValueKey('tuition-error'),
        message: _tuitionErrorMessage(_error),
        onRetry: _loadTuition,
      );
    }

    return Column(
      key: ValueKey('tuition-content-${overview.semester}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TuitionHeroCard(overview: overview, onPayNow: _showPaymentComingSoon),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _InlineTuitionWarning(
            message: _tuitionErrorMessage(_error),
            onRetry: () => _loadTuition(silent: true),
          ),
        ],
        const SizedBox(height: 16),
        _TuitionSummaryGrid(overview: overview),
        const SizedBox(height: 20),
        const _TuitionSectionTitle(title: TuitionStrings.feeListTitle),
        const SizedBox(height: 10),
        _buildFeeItems(overview.feeItems),
        const SizedBox(height: 8),
        if (overview.paymentInfo.hasAny)
          _PaymentInstructionCard(
            paymentInfo: overview.paymentInfo,
            onCopy: () => _copyPaymentInfo(overview.paymentInfo),
            onPayNow: _showPaymentComingSoon,
          )
        else
          const _TuitionMessageCard(
            icon: Icons.account_balance_outlined,
            title: TuitionStrings.emptyPaymentInfoTitle,
            message: TuitionStrings.emptyPaymentInfoMessage,
          ),
        const SizedBox(height: 20),
        const _TuitionSectionTitle(
          title: TuitionStrings.transactionHistoryTitle,
        ),
        const SizedBox(height: 10),
        _buildTransactions(overview.transactions),
      ],
    );
  }

  Widget _buildFeeItems(List<TuitionFeeItem> items) {
    if (items.isEmpty) {
      return const _TuitionMessageCard(
        icon: Icons.receipt_long_outlined,
        title: TuitionStrings.emptyFeesTitle,
        message: TuitionStrings.emptyFeesMessage,
      );
    }

    return Column(
      children: [
        for (final item in items) ...[
          _TuitionFeeCard(item: item),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildTransactions(List<TuitionTransaction> transactions) {
    if (transactions.isEmpty) {
      return const _TuitionMessageCard(
        icon: Icons.history_rounded,
        title: TuitionStrings.emptyTransactionsTitle,
        message: TuitionStrings.emptyTransactionsMessage,
      );
    }

    return Column(
      children: [
        for (final transaction in transactions) ...[
          _TransactionCard(transaction: transaction),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
