import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/data_providers.dart';
import '../models/monthly_recovery.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_components.dart';

class MonthlyDraftsScreen extends ConsumerStatefulWidget {
  final String branchId;
  const MonthlyDraftsScreen({super.key, required this.branchId});

  @override
  ConsumerState<MonthlyDraftsScreen> createState() => _MonthlyDraftsScreenState();
}

class _MonthlyDraftsScreenState extends ConsumerState<MonthlyDraftsScreen> {
  final int _currentMonth = DateTime.now().month;
  final int _currentYear = DateTime.now().year;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final appStateAsync = ref.watch(appStateProvider);

    return appStateAsync.when(
      loading: () => const FintechScaffold(
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.primary,
          ),
        ),
      ),
      error: (e, s) => FintechScaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FintechCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppTheme.danger, size: 40),
                  const SizedBox(height: 16),
                  const Text(
                    'Drafts Unavailable',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      data: (appState) {
        final matchingOffices =
            appState.offices.where((o) => o.id == widget.branchId).toList();
        if (matchingOffices.isEmpty) {
          return FintechScaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
            child: const Center(
              child: Text(
                'Branch not found.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          );
        }

        final office = matchingOffices.first;

        final branchLoanIds = appState.customers
            .where((c) => c.officeId == widget.branchId)
            .expand((c) => appState.loans
                .where((l) => l.customerId == c.id)
                .map((l) => l.id))
            .toSet();

        // Ensure we only show drafts for this branch and current period
        final drafts = appState.monthlyRecoveries.where((d) {
          final isSamePeriod =
              d.month == _currentMonth && d.year == _currentYear;
          final belongsToBranch = branchLoanIds.contains(d.loanId);
          return isSamePeriod && belongsToBranch;
        }).toList();

        final totalDemand = drafts.fold<double>(
          0.0,
          (sum, d) => sum + d.totalRecovered,
        );

        return FintechScaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${office.name} Drafts',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Collection Period: $_currentMonth/$_currentYear',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (drafts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: FintechButton(
                    label: 'EXPORT PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    variant: FintechButtonVariant.outline,
                    height: 34,
                    fontSize: 11,
                    onPressed: () => context.push(
                      '/branch/${widget.branchId}/preview/$_currentMonth/$_currentYear',
                    ),
                  ),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. KPI SUMMARY & ACTION BAR
                Row(
                  children: [
                    Expanded(
                      child: FintechKPICard(
                        label: 'Total Demand',
                        value: '₹${_formatCurrency(totalDemand)}',
                        icon: Icons.payments_outlined,
                        valueColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FintechKPICard(
                        label: 'Draft Accounts',
                        value: '${drafts.length}',
                        subtitle: 'Period $_currentMonth/$_currentYear',
                        icon: Icons.receipt_long_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MASTER COLLECTION LEDGER',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    FintechButton(
                      label: drafts.isEmpty ? 'GENERATE DRAFTS' : 'REFRESH DRAFTS',
                      icon: Icons.sync_rounded,
                      variant: FintechButtonVariant.primary,
                      height: 34,
                      fontSize: 11,
                      isLoading: _isGenerating,
                      onPressed: () => _handleGenerateDrafts(ref),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2. DATA TABLE CARD
                Expanded(
                  child: FintechCard(
                    padding: EdgeInsets.zero,
                    child: drafts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.receipt_outlined,
                                  size: 40,
                                  color: AppTheme.textTertiary,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No recovery drafts generated for this period.',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Tap "Generate Drafts" above to compute monthly EMIs.',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: DataTable(
                                headingRowColor:
                                    WidgetStateProperty.all(AppTheme.surfaceVariant),
                                dividerThickness: 1.0,
                                horizontalMargin: 16,
                                columnSpacing: 20,
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.8,
                                ),
                                dataTextStyle: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                columns: const [
                                  DataColumn(label: Text('MEMBER')),
                                  DataColumn(label: Text('ACCOUNT')),
                                  DataColumn(label: Text('PRINCIPAL (₹)')),
                                  DataColumn(label: Text('INTEREST (₹)')),
                                  DataColumn(label: Text('PENAL (₹)')),
                                  DataColumn(label: Text('OTHERS (₹)')),
                                  DataColumn(label: Text('TOTAL DEMAND (₹)')),
                                  DataColumn(label: Text('ACTION')),
                                ],
                                rows: drafts.map((d) {
                                  final loan = appState.loans
                                      .firstWhere((l) => l.id == d.loanId);
                                  final customer = appState.customers
                                      .firstWhere((c) => c.id == loan.customerId);
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                        customer.name.toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      )),
                                      DataCell(Text(
                                        loan.accountNo,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                      DataCell(Text(
                                          '₹${d.principalDue.toStringAsFixed(0)}')),
                                      DataCell(Text(
                                          '₹${d.interest.toStringAsFixed(0)}')),
                                      DataCell(Text(
                                          '₹${d.penalInterest.toStringAsFixed(0)}')),
                                      DataCell(Text(
                                          '₹${d.otherCharges.toStringAsFixed(0)}')),
                                      DataCell(Text(
                                        '₹${d.totalRecovered.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.primary,
                                        ),
                                      )),
                                      DataCell(
                                        FintechButton(
                                          label: 'ADJUST',
                                          icon: Icons.edit_outlined,
                                          variant: FintechButtonVariant.secondary,
                                          height: 30,
                                          fontSize: 10,
                                          onPressed: () =>
                                              _showEditEmiDialog(context, ref, d),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)} L';
    } else {
      return amount.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
            (m) => '${m[1]},',
          );
    }
  }

  Future<void> _handleGenerateDrafts(WidgetRef ref) async {
    setState(() => _isGenerating = true);
    try {
      final msg = await ref.read(appStateProvider.notifier).generateDrafts(
            _currentMonth,
            _currentYear,
            branchId: widget.branchId,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showEditEmiDialog(
      BuildContext context, WidgetRef ref, MonthlyRecovery draft) {
    final principalCtrl =
        TextEditingController(text: draft.principalDue.toStringAsFixed(0));
    final interestCtrl =
        TextEditingController(text: draft.interest.toStringAsFixed(0));
    final penalCtrl =
        TextEditingController(text: draft.penalInterest.toStringAsFixed(0));
    final othersCtrl =
        TextEditingController(text: draft.otherCharges.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.border, width: 1.0),
        ),
        title: const Text(
          'Adjust Recovery Demand',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Modify principal, accrued interest, or penal penalties for this monthly draft.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),
              FintechInput(
                controller: principalCtrl,
                label: 'Principal Due (₹)',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.currency_rupee_rounded,
              ),
              const SizedBox(height: 12),
              FintechInput(
                controller: interestCtrl,
                label: 'Interest (₹)',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.percent_rounded,
              ),
              const SizedBox(height: 12),
              FintechInput(
                controller: penalCtrl,
                label: 'Penal Interest (₹)',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.warning_amber_rounded,
              ),
              const SizedBox(height: 12),
              FintechInput(
                controller: othersCtrl,
                label: 'Other Charges / Fees (₹)',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.add_circle_outline_rounded,
              ),
            ],
          ),
        ),
        actions: [
          FintechButton(
            label: 'CANCEL',
            variant: FintechButtonVariant.ghost,
            onPressed: () => Navigator.pop(ctx),
          ),
          FintechButton(
            label: 'UPDATE DRAFT',
            variant: FintechButtonVariant.primary,
            onPressed: () {
              ref.read(appStateProvider.notifier).updateDraft(
                    draft.id,
                    principalDue: double.tryParse(principalCtrl.text),
                    interest: double.tryParse(interestCtrl.text),
                    penalInt: double.tryParse(penalCtrl.text),
                    others: double.tryParse(othersCtrl.text),
                  );
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
