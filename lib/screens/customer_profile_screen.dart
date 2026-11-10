import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/data_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_components.dart';

class CustomerProfileScreen extends ConsumerWidget {
  final String customerId;

  const CustomerProfileScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    'Profile Unavailable',
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
        final matchingCustomers =
            appState.customers.where((c) => c.id == customerId).toList();
        if (matchingCustomers.isEmpty) {
          return FintechScaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
            child: const Center(
              child: Text(
                'Member profile not found or removed.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          );
        }

        final customer = matchingCustomers.first;
        final matchingOffices =
            appState.offices.where((o) => o.id == customer.officeId).toList();
        final officeName = matchingOffices.isNotEmpty
            ? matchingOffices.first.name
            : 'Unknown Unit';
        final loans =
            appState.loans.where((l) => l.customerId == customerId).toList();

        final totalOutstanding = loans.fold<double>(
          0.0,
          (sum, l) => sum + l.principalOutstanding,
        );

        return FintechScaffold(
          appBar: AppBar(
            title: const Text('Member Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddLoanModal(context, ref),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text(
              'NEW LOAN',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. MEMBER IDENTITY CARD
                FintechCard(
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.border),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : 'M',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$officeName · Member #${customer.memberNo}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. EXPOSURE METRICS ROW
                Row(
                  children: [
                    Expanded(
                      child: FintechKPICard(
                        label: 'Total Outstanding',
                        value: '₹${_formatCurrency(totalOutstanding)}',
                        icon: Icons.account_balance_wallet_outlined,
                        valueColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FintechKPICard(
                        label: 'Loan Accounts',
                        value: '${loans.length}',
                        subtitle: '${loans.where((l) => l.status.toLowerCase() == "active").length} Active',
                        icon: Icons.receipt_long_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // 3. FINANCIAL EXPOSURE SECTION HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'FINANCIAL EXPOSURE',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    FintechBadge.neutral(
                      '${loans.length} ${loans.length == 1 ? 'ACCOUNT' : 'ACCOUNTS'}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. LOAN ACCOUNTS LIST
                if (loans.isEmpty)
                  FintechCard(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 36,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No active loan accounts found.',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tap "New Loan" below to initialize an account.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: loans.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final loan = loans[index];
                      final isOverdue =
                          loan.status.toLowerCase() == 'overdue' ||
                          loan.status.toLowerCase() == 'npa';

                      return FintechCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'A/C ${loan.accountNo}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'monospace',
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (isOverdue)
                                      FintechBadge.danger(
                                        loan.status.toUpperCase(),
                                      )
                                    else
                                      FintechBadge.success(
                                        loan.status.toUpperCase(),
                                      ),
                                  ],
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: AppTheme.textTertiary,
                                  ),
                                  splashRadius: 18,
                                  onPressed: () => _showDeleteLoanDialog(
                                    context,
                                    ref,
                                    loan.id,
                                    loan.accountNo,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: AppTheme.border),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'OUTSTANDING',
                                      style: TextStyle(
                                        color: AppTheme.textTertiary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '₹${loan.principalOutstanding.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: AppTheme.primary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'BASE MONTHLY EMI',
                                      style: TextStyle(
                                        color: AppTheme.textTertiary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '₹${loan.baseEmiAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 80), // Padding for FAB
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

  void _showDeleteLoanDialog(
    BuildContext context,
    WidgetRef ref,
    String loanId,
    String accountNo,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.border, width: 1.0),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.danger, size: 22),
            SizedBox(width: 10),
            Text(
              'Purge Loan Record?',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete loan account "$accountNo"? All active recovery drafts will be removed.',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          FintechButton(
            label: 'CANCEL',
            variant: FintechButtonVariant.ghost,
            onPressed: () => Navigator.pop(ctx),
          ),
          FintechButton(
            label: 'PURGE LOAN',
            variant: FintechButtonVariant.danger,
            onPressed: () {
              ref.read(appStateProvider.notifier).deleteLoan(loanId);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showAddLoanModal(BuildContext context, WidgetRef ref) {
    final acCtrl = TextEditingController();
    final osCtrl = TextEditingController();
    final emiCtrl = TextEditingController();

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
          'Initialize New Loan',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FintechInput(
              controller: acCtrl,
              label: 'Account Number (XX/YY-ZZ)',
              hint: 'e.g. LN-8812',
              prefixIcon: Icons.receipt_outlined,
            ),
            const SizedBox(height: 12),
            FintechInput(
              controller: osCtrl,
              label: 'Principal Outstanding Amount (₹)',
              hint: 'e.g. 50000',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee_rounded,
            ),
            const SizedBox(height: 12),
            FintechInput(
              controller: emiCtrl,
              label: 'Agreed Base EMI (₹)',
              hint: 'e.g. 2500',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.payments_outlined,
            ),
          ],
        ),
        actions: [
          FintechButton(
            label: 'CANCEL',
            variant: FintechButtonVariant.ghost,
            onPressed: () => Navigator.pop(ctx),
          ),
          FintechButton(
            label: 'INITIALIZE LOAN',
            variant: FintechButtonVariant.primary,
            onPressed: () {
              final ac = acCtrl.text.trim();
              final pos = double.tryParse(osCtrl.text.trim()) ?? 0.0;
              final emi = double.tryParse(emiCtrl.text.trim()) ?? 0.0;
              if (ac.isNotEmpty && pos > 0) {
                ref
                    .read(appStateProvider.notifier)
                    .addLoan(customerId, ac, pos, emi);
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
