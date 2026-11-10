import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/data_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_components.dart';
import 'splash_loading_screen.dart';
import '../core/auth/auth_providers.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStateAsync = ref.watch(appStateProvider);
    final authState = ref.watch(authNotifierProvider);

    return appStateAsync.when(
      loading: () => const SplashLoadingScreen(message: 'Initializing Core...'),
      error: (error, stack) => FintechScaffold(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FintechCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.dangerLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.cloud_off_rounded,
                      color: AppTheme.danger,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Connection Error',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Unable to synchronize with core services. Ensure you have an active network connection or verify local permissions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FintechButton(
                    label: 'RETRY CONNECTION',
                    icon: Icons.refresh_rounded,
                    variant: FintechButtonVariant.primary,
                    onPressed: () => ref.invalidate(appStateProvider),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Debug: $error',
                    style: const TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      data: (appState) {
        final branches = appState.offices;
        final totalCustomers = appState.customers.length;
        final grossOutstanding = appState.loans.fold<double>(
          0.0,
          (sum, loan) => sum + loan.principalOutstanding,
        );

        return FintechScaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RECOVERY LEDGER',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  'Co-operative Recovery Platform',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              if (authState.employee != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: InkWell(
                    onTap: () => context.push('/settings'),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border, width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppTheme.primary,
                            child: Text(
                              authState.employee!.name.isNotEmpty
                                  ? authState.employee!.name[0].toUpperCase()
                                  : 'O',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: Text(
                              authState.employee!.name,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppTheme.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddBranchModal(context, ref),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'NEW UNIT',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP PORTFOLIO KPI TICKER
                Row(
                  children: [
                    Expanded(
                      child: FintechKPICard(
                        label: 'Gross Principal',
                        value: '₹${_formatCurrency(grossOutstanding)}',
                        icon: Icons.account_balance_wallet_outlined,
                        valueColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FintechKPICard(
                        label: 'Total Members',
                        value: '$totalCustomers',
                        subtitle: '${branches.length} Active Units',
                        icon: Icons.people_outline_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // 2. OPERATIONAL UNITS SECTION HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'OPERATIONAL UNITS',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    FintechBadge.neutral('${branches.length} UNITS'),
                  ],
                ),
                const SizedBox(height: 12),

                // 3. BRANCH CARDS
                if (branches.isEmpty)
                  FintechCard(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.domain_disabled_rounded,
                            size: 40,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No operational units found',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tap "New Unit" below to register a branch ledger.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
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
                    itemCount: branches.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final branch = branches[index];
                      final branchCustomers = appState.customers
                          .where((c) => c.officeId == branch.id)
                          .toList();
                      final customerIds = branchCustomers.map((c) => c.id).toSet();
                      final branchLoans = appState.loans
                          .where((l) => customerIds.contains(l.customerId))
                          .toList();
                      final branchOutstanding = branchLoans.fold<double>(
                        0.0,
                        (sum, l) => sum + l.principalOutstanding,
                      );

                      return FintechCard(
                        padding: const EdgeInsets.all(16),
                        onTap: () => context.push('/branch/${branch.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppTheme.border,
                                      width: 1.0,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.account_balance_outlined,
                                    size: 18,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        branch.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.textPrimary,
                                          letterSpacing: -0.3,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'UNIT CODE: ${branch.id.length > 8 ? branch.id.substring(0, 8).toUpperCase() : branch.id.toUpperCase()}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'monospace',
                                          color: AppTheme.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: AppTheme.textTertiary,
                                  ),
                                  splashRadius: 18,
                                  onPressed: () => _showDeleteBranchDialog(
                                    context,
                                    ref,
                                    branch.id,
                                    branch.name,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Divider(height: 1, color: AppTheme.border),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    FintechBadge.neutral(
                                      '${branchCustomers.length} MEMBERS',
                                      icon: Icons.person_outline_rounded,
                                    ),
                                    const SizedBox(width: 8),
                                    FintechBadge.neutral(
                                      '${branchLoans.length} LOANS',
                                      icon: Icons.receipt_long_outlined,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                        Text(
                                          '₹${_formatCurrency(branchOutstanding)}',
                                          style: const TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      size: 18,
                                      color: AppTheme.textTertiary,
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

  void _showDeleteBranchDialog(
    BuildContext context,
    WidgetRef ref,
    String branchId,
    String branchName,
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
              'Wipe Branch Ledger?',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "$branchName"? This action permanently wipes all associated members and active loan accounts in this unit from encrypted storage.',
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
            label: 'WIPE BRANCH',
            variant: FintechButtonVariant.danger,
            onPressed: () {
              ref.read(appStateProvider.notifier).deleteBranch(branchId);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showAddBranchModal(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
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
          'Register New Unit',
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
            const Text(
              'Provide an official designation or office identifier for this operational branch.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            FintechInput(
              controller: controller,
              label: 'Unit Name / Code',
              hint: 'e.g. Alappuzha HO',
              prefixIcon: Icons.business_outlined,
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
            label: 'REGISTER UNIT',
            variant: FintechButtonVariant.primary,
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(appStateProvider.notifier).addBranch(text);
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
