import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/data_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/background_scaffold.dart';
import 'splash_loading_screen.dart';
import '../core/auth/auth_providers.dart';
import '../core/security/security_providers.dart';
import '../domain/services/data_seeder_service.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStateAsync = ref.watch(appStateProvider);

    return appStateAsync.when(
      loading: () => const SplashLoadingScreen(message: 'Initializing Core...'),
      error: (error, stack) => BackgroundScaffold(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_rounded, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 24),
                  Text(
                    'Connection Error',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The app could not reach the backend. Ensure you have an active internet connection and that the Render service is not sleeping.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => ref.invalidate(appStateProvider),
                    child: const SizedBox(
                      height: 50,
                      width: 160,
                      child: GlassPill(
                        child: Text('RETRY CONNECTION', style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Debug: $error',
                    style: const TextStyle(color: Colors.white24, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      data: (appState) {
        final branches = appState.offices;

        final authState = ref.watch(authNotifierProvider);

        return BackgroundScaffold(
          appBar: AppBar(
            title: const Text('CO-OP RECOVERY'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            actions: [
              if (authState.employee != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: PopupMenuButton<String>(
                    color: AppTheme.surface,
                    icon: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.3),
                      child: Text(
                        authState.employee!.name.isNotEmpty
                            ? authState.employee!.name[0].toUpperCase()
                            : 'O',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authState.employee!.name,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              authState.employee!.email,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                authState.employee!.role.toUpperCase(),
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'import_pdf',
                        child: Row(
                          children: [
                            Icon(Icons.picture_as_pdf_rounded,
                                size: 18, color: AppTheme.accent),
                            SizedBox(width: 8),
                            Text('Import / Update PDF Data',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'clear_db',
                        child: Row(
                          children: [
                            Icon(Icons.delete_forever_rounded,
                                size: 18, color: Colors.orangeAccent),
                            SizedBox(width: 8),
                            Text('Clear Local Database',
                                style: TextStyle(color: Colors.orangeAccent)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'lock',
                        child: Row(
                          children: [
                            Icon(Icons.fingerprint_rounded,
                                size: 18, color: AppTheme.primary),
                            SizedBox(width: 8),
                            Text('Lock App (Biometrics)',
                                style: TextStyle(color: AppTheme.primary)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout,
                                size: 18, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text('Sign Out',
                                style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (val) {
                      if (val == 'import_pdf') {
                        _handlePdfImport(context, ref);
                      } else if (val == 'clear_db') {
                        _handleClearDatabase(context, ref);
                      } else if (val == 'lock') {
                        ref.read(appLockProvider.notifier).lock();
                      } else if (val == 'logout') {
                        ref.read(authNotifierProvider.notifier).signOut();
                      }
                    },
                  ),
                ),
            ],
          ),
          floatingActionButton: SizedBox(
            height: 60,
            width: 160,
            child: GestureDetector(
              onTap: () => _showAddBranchModal(context, ref),
              child: const GlassPill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'ADD BRANCH',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Select Unit',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Precision tracking for recovery operations.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: branches.length,
                      itemBuilder: (context, index) {
                        final branch = branches[index];
                        final employeeCount = appState.customers
                            .where((c) => c.officeId == branch.id)
                            .length;

                        return GestureDetector(
                          onTap: () => context.push('/branch/${branch.id}'),
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.grid_view_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      icon: const Icon(
                                        Icons.delete_sweep_outlined,
                                        color: Colors.redAccent,
                                        size: 18,
                                      ),
                                      onPressed: () => _showDeleteBranchDialog(
                                          context, ref, branch.id, branch.name),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      branch.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        GlassPill(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          child: Text(
                                            '$employeeCount EMPLOYEES',
                                            style: const TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              letterSpacing: 0.4,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.arrow_right_alt_rounded,
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteBranchDialog(
      BuildContext context, WidgetRef ref, String branchId, String branchName) {
    showDialog(
      context: context,
      builder: (ctx) => _GlassDialogWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wipe Branch Data?', 
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            Text('Are you sure you want to remove $branchName? This action wipes all associated employee and loan recovery data from the secure storage.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 45,
                  width: 110,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(appStateProvider.notifier).deleteBranch(branchId);
                      Navigator.pop(ctx);
                    },
                    child: const GlassPill(
                      child: Text('WIPE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBranchModal(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => _GlassDialogWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Register New Unit', 
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20)),
            const SizedBox(height: 24),
            _GlassInput(controller: controller, label: 'Unit Identification Name'),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 45,
                  width: 120,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(appStateProvider.notifier).addBranch(controller.text);
                      Navigator.pop(ctx);
                    },
                    child: const GlassPill(
                      child: Text('REGISTER', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleClearDatabase(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text('Clear Local Database',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to completely erase all local data? This will remove all branches, customer profiles, and loan ledgers from this device.',
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Wipe Everything',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(appStateProvider.notifier).clearDatabase();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Local database completely cleared.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _handlePdfImport(BuildContext context, WidgetRef ref) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/extracted_data.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final incomingBranches =
          data.keys.where((k) => k != 'Unknown').toList();

      final seeder = ref.read(dataSeederServiceProvider);
      final conflicts =
          await seeder.findConflictingBranches(incomingBranches);

      ImportConflictAction conflictAction = ImportConflictAction.replace;

      if (conflicts.isNotEmpty && context.mounted) {
        // Show conflict resolution dialog: ask user whether to replace or keep old
        final choice = await showDialog<ImportConflictAction>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.inventory_2_outlined,
                    color: AppTheme.accent, size: 26),
                SizedBox(width: 10),
                Text('Existing Records Found',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data for branch(es) "${conflicts.join(", ")}" already exists in your local database.\n\nWhich version would you like to keep?',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text(
                    '• Replace with New: Overwrites existing branch records with fresh PDF data.\n• Keep Old: Retains your existing branch records and cancels importing duplicates.',
                    style: TextStyle(
                        color: Colors.white60, fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.white60)),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.accent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pop(
                    ctx, ImportConflictAction.keepExisting),
                child: const Text('Keep Old Data',
                    style: TextStyle(color: AppTheme.accent)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () =>
                    Navigator.pop(ctx, ImportConflictAction.replace),
                child: const Text('Replace with New',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );

        if (choice == null) return;
        conflictAction = choice;
      }

      final result =
          await ref.read(appStateProvider.notifier).importDataFromJson(
                jsonString,
                wipeExisting: false,
                conflictAction: conflictAction,
              );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Imported ${result.officesCreated} branches, ${result.customersCreated} members, and ${result.loansCreated} loans successfully.',
            ),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import PDF data: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

class _GlassDialogWrapper extends StatelessWidget {
  final Widget child;
  const _GlassDialogWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: IntrinsicHeight(
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _GlassInput({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60, fontSize: 13),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }
}
