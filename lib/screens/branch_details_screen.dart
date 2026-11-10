import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/data_providers.dart';
import '../domain/models/loan.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_components.dart';

class BranchDetailsScreen extends ConsumerStatefulWidget {
  final String branchId;
  const BranchDetailsScreen({super.key, required this.branchId});

  @override
  ConsumerState<BranchDetailsScreen> createState() => _BranchDetailsScreenState();
}

class _BranchDetailsScreenState extends ConsumerState<BranchDetailsScreen> {
  final Set<String> _expandedCustomerIds = {};
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                    'Unit Data Unavailable',
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
                'Unit record does not exist or was deleted.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          );
        }

        final office = matchingOffices.first;
        final allCustomers =
            appState.customers.where((c) => c.officeId == widget.branchId).toList();
        final customerIds = allCustomers.map((c) => c.id).toSet();
        final allBranchLoans =
            appState.loans.where((l) => customerIds.contains(l.customerId)).toList();

        // High-contrast KPI computations
        final grossPrincipal = allBranchLoans.fold<double>(
          0.0,
          (sum, l) => sum + l.principalOutstanding,
        );
        final activeLoansCount = allBranchLoans.where((l) {
          final s = l.status.toLowerCase();
          return s == 'active' || s == 'ongoing';
        }).length;
        final totalDemand = allBranchLoans.fold<double>(
          0.0,
          (sum, l) => sum + l.baseEmiAmount,
        );

        // Filter and Search
        final filteredCustomers = allCustomers.where((customer) {
          final customerLoans =
              allBranchLoans.where((l) => l.customerId == customer.id).toList();

          // Search match
          if (_searchQuery.isNotEmpty) {
            final nameMatch = customer.name.toLowerCase().contains(_searchQuery);
            final idMatch = customer.memberNo.toLowerCase().contains(_searchQuery);
            final loanMatch = customerLoans
                .any((l) => l.accountNo.toLowerCase().contains(_searchQuery));
            if (!nameMatch && !idMatch && !loanMatch) return false;
          }

          // Segmented filter match
          if (_selectedFilter == 'Active') {
            return customerLoans.any((l) =>
                l.status.toLowerCase() == 'active' ||
                l.status.toLowerCase() == 'ongoing');
          } else if (_selectedFilter == 'Overdue') {
            return customerLoans.any((l) =>
                l.status.toLowerCase() == 'overdue' ||
                l.status.toLowerCase() == 'npa');
          }

          return true;
        }).toList();

        return FintechScaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  office.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '${allCustomers.length} registered members',
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
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FintechButton(
                  label: 'DRAFTS',
                  icon: Icons.receipt_long_outlined,
                  variant: FintechButtonVariant.outline,
                  height: 34,
                  fontSize: 11,
                  onPressed: () =>
                      context.push('/branch/${widget.branchId}/drafts'),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddEmployeeModal(context, ref),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
            label: const Text(
              'ADD MEMBER',
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
                // 1. HIGH-CONTRAST KPI TICKER
                Row(
                  children: [
                    Expanded(
                      child: FintechKPICard(
                        label: 'Gross Principal',
                        value: '₹${_formatCurrency(grossPrincipal)}',
                        icon: Icons.account_balance_wallet_outlined,
                        valueColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FintechKPICard(
                        label: 'Active Loans',
                        value: '$activeLoansCount',
                        subtitle: '₹${_formatCurrency(totalDemand)} / mo Demand',
                        icon: Icons.receipt_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 2. SEARCH BAR & SEGMENTED FILTER BAR
                TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search member name, ID, or loan account...',
                    hintStyle: const TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 16),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: AppTheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FintechSegmentedBar(
                      options: const ['All', 'Active', 'Overdue'],
                      selected: _selectedFilter,
                      onSelected: (val) {
                        setState(() {
                          _selectedFilter = val;
                        });
                      },
                    ),
                    Text(
                      '${filteredCustomers.length} of ${allCustomers.length}',
                      style: const TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 3. INLINE ACCORDION MEMBER & LOAN LIST
                if (filteredCustomers.isEmpty)
                  FintechCard(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 36,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            allCustomers.isEmpty
                                ? 'No registered members in this unit.'
                                : 'No members matching filter "$_selectedFilter".',
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tap "Add Member" below to register a customer.',
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
                    itemCount: filteredCustomers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      final customerLoans = allBranchLoans
                          .where((l) => l.customerId == customer.id)
                          .toList();
                      final totalOs = customerLoans.fold<double>(
                        0.0,
                        (sum, l) => sum + l.principalOutstanding,
                      );
                      final isExpanded =
                          _expandedCustomerIds.contains(customer.id);

                      return _MemberAccordionTile(
                        customerName: customer.name,
                        memberNo: customer.memberNo,
                        loans: customerLoans,
                        totalOutstanding: totalOs,
                        isExpanded: isExpanded,
                        onToggleExpand: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedCustomerIds.remove(customer.id);
                            } else {
                              _expandedCustomerIds.add(customer.id);
                            }
                          });
                        },
                        onDeleteMember: () => _showDeleteMemberDialog(
                          context,
                          ref,
                          customer.id,
                          customer.name,
                        ),
                        onAddLoan: () => _showAddLoanModal(
                          context,
                          ref,
                          customer.id,
                          customer.name,
                        ),
                        onDeleteLoan: (loanId, accountNo) =>
                            _showDeleteLoanDialog(
                          context,
                          ref,
                          loanId,
                          accountNo,
                        ),
                        onManageProfile: () =>
                            context.push('/customer/${customer.id}'),
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

  void _showDeleteMemberDialog(
    BuildContext context,
    WidgetRef ref,
    String customerId,
    String customerName,
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
              'Remove Member Record?',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "$customerName"? This will permanently purge all associated loan accounts and recovery drafts for this member.',
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
            label: 'PURGE MEMBER',
            variant: FintechButtonVariant.danger,
            onPressed: () {
              ref.read(appStateProvider.notifier).deleteEmployee(customerId);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showAddEmployeeModal(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final memberCtrl = TextEditingController();

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
          'Register Unit Member',
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
              'Add a borrower or member to this operational branch unit.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            FintechInput(
              controller: nameCtrl,
              label: 'Full Official Name',
              hint: 'e.g. Rajesh Kumar',
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            FintechInput(
              controller: memberCtrl,
              label: 'Society Member No.',
              hint: 'e.g. M-104',
              prefixIcon: Icons.badge_outlined,
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
            label: 'REGISTER MEMBER',
            variant: FintechButtonVariant.primary,
            onPressed: () {
              final name = nameCtrl.text.trim();
              final no = memberCtrl.text.trim();
              if (name.isNotEmpty && no.isNotEmpty) {
                ref
                    .read(appStateProvider.notifier)
                    .addEmployee(widget.branchId, name, no);
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showAddLoanModal(
    BuildContext context,
    WidgetRef ref,
    String customerId,
    String customerName,
  ) {
    final accountCtrl = TextEditingController();
    final principalCtrl = TextEditingController();
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
        title: Text(
          'New Loan: $customerName',
          style: const TextStyle(
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
              controller: accountCtrl,
              label: 'Loan Account Number',
              hint: 'e.g. LN-9912',
              prefixIcon: Icons.receipt_outlined,
            ),
            const SizedBox(height: 12),
            FintechInput(
              controller: principalCtrl,
              label: 'Principal Outstanding (₹)',
              hint: 'e.g. 50000',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee_rounded,
            ),
            const SizedBox(height: 12),
            FintechInput(
              controller: emiCtrl,
              label: 'Base Monthly EMI (₹)',
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
              final acct = accountCtrl.text.trim();
              final pos = double.tryParse(principalCtrl.text.trim()) ?? 0.0;
              final emi = double.tryParse(emiCtrl.text.trim()) ?? 0.0;
              if (acct.isNotEmpty && pos > 0) {
                ref
                    .read(appStateProvider.notifier)
                    .addLoan(customerId, acct, pos, emi);
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
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
              'Delete Loan Account?',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete loan account "$accountNo"? All active recovery drafts will be removed.',
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
            label: 'DELETE LOAN',
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
}

/// Expandable accordion member tile with embedded active loan cards.
class _MemberAccordionTile extends StatelessWidget {
  final String customerName;
  final String memberNo;
  final List<Loan> loans;
  final double totalOutstanding;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onDeleteMember;
  final VoidCallback onAddLoan;
  final void Function(String loanId, String accountNo) onDeleteLoan;
  final VoidCallback onManageProfile;

  const _MemberAccordionTile({
    required this.customerName,
    required this.memberNo,
    required this.loans,
    required this.totalOutstanding,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onDeleteMember,
    required this.onAddLoan,
    required this.onDeleteLoan,
    required this.onManageProfile,
  });

  @override
  Widget build(BuildContext context) {
    return FintechCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. COLLAPSED MEMBER HEADER ROW
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      customerName.isNotEmpty
                          ? customerName[0].toUpperCase()
                          : 'M',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'MEMBER #$memberNo',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${totalOutstanding.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FintechBadge.neutral(
                        '${loans.length} ${loans.length == 1 ? 'LOAN' : 'LOANS'}',
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. EXPANDED ACCORDION CONTENT
          if (isExpanded) ...[
            const Divider(height: 1, color: AppTheme.border),
            Container(
              color: AppTheme.background,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ACTIVE LOAN ACCOUNTS',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 16,
                          color: AppTheme.danger,
                        ),
                        splashRadius: 16,
                        tooltip: 'Remove Member',
                        onPressed: onDeleteMember,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (loans.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'No active loan accounts found for this member.',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: loans.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final loan = loans[index];
                        final isOverdue =
                            loan.status.toLowerCase() == 'overdue' ||
                            loan.status.toLowerCase() == 'npa';

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.border),
                          ),
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
                                          fontSize: 13,
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
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 16,
                                      color: AppTheme.textTertiary,
                                    ),
                                    onPressed: () => onDeleteLoan(
                                      loan.id,
                                      loan.accountNo,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Divider(height: 1, color: AppTheme.border),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildLoanStat(
                                    'OUTSTANDING',
                                    '₹${loan.principalOutstanding.toStringAsFixed(0)}',
                                    isPrimary: true,
                                  ),
                                  _buildLoanStat(
                                    'BASE MONTHLY EMI',
                                    '₹${loan.baseEmiAmount.toStringAsFixed(0)}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 14),

                  // 3. ACTION BUTTONS ROW
                  Row(
                    children: [
                      Expanded(
                        child: FintechButton(
                          label: 'NEW LOAN',
                          icon: Icons.add_rounded,
                          variant: FintechButtonVariant.outline,
                          height: 36,
                          fontSize: 11,
                          onPressed: onAddLoan,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FintechButton(
                          label: 'FULL PROFILE',
                          icon: Icons.open_in_new_rounded,
                          variant: FintechButtonVariant.secondary,
                          height: 36,
                          fontSize: 11,
                          onPressed: onManageProfile,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoanStat(String label, String value, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textTertiary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: TextStyle(
            color: isPrimary ? AppTheme.primary : AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
