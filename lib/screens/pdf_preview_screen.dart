import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import '../data/data_providers.dart';
import '../services/pdf_service.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_components.dart';

class PdfPreviewScreen extends ConsumerWidget {
  final String branchId;
  final int month;
  final int year;
  const PdfPreviewScreen({
    super.key,
    required this.branchId,
    required this.month,
    required this.year,
  });

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
                    'PDF Generation Failed',
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
            appState.offices.where((o) => o.id == branchId).toList();
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
            .where((c) => c.officeId == branchId)
            .expand((c) => appState.loans
                .where((l) => l.customerId == c.id)
                .map((l) => l.id))
            .toSet();

        final branchDrafts = appState.monthlyRecoveries
            .where((d) =>
                d.month == month &&
                d.year == year &&
                branchLoanIds.contains(d.loanId))
            .toList();

        if (branchDrafts.isEmpty) {
          return FintechScaffold(
            appBar: AppBar(
              title: const Text('Export Collection Draft'),
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
                      const Icon(Icons.receipt_long_outlined,
                          size: 40, color: AppTheme.textTertiary),
                      const SizedBox(height: 16),
                      const Text(
                        'No Drafts Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No recoveries generated for ${office.name} in $month/$year',
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
          );
        }

        return FintechScaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Export Collection Draft',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '${office.name} · $month/$year',
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
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: PdfPreview(
                  build: (format) => PdfService.generateRecoveryPdf(
                    office: office,
                    month: month,
                    year: year,
                    drafts: branchDrafts,
                    customers: appState.customers,
                    loans: appState.loans,
                  ),
                  allowPrinting: true,
                  allowSharing: true,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  previewPageMargin: const EdgeInsets.all(12),
                  pdfPreviewPageDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
