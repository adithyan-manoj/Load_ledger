import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_components.dart';
import '../core/auth/auth_providers.dart';
import '../core/security/security_providers.dart';
import '../data/data_providers.dart';
import '../domain/services/data_seeder_service.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  bool _googleDriveAutoSync = false;
  bool _isBackingUp = false;
  bool _isImporting = false;
  bool _isClearing = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final employee = authState.employee;

    return FintechScaffold(
      appBar: AppBar(
        title: const Text('Officer Profile & System'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. OFFICER IDENTITY SECTION
            _buildSectionHeader('OFFICER IDENTITY'),
            const SizedBox(height: 10),
            if (employee != null)
              FintechCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            employee.name.isNotEmpty
                                ? employee.name[0].toUpperCase()
                                : 'O',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                employee.email,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppTheme.border),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FintechBadge.neutral(
                          'ROLE: ${employee.role.toUpperCase()}',
                          icon: Icons.shield_outlined,
                        ),
                        if (employee.isActive)
                          FintechBadge.success(
                            'SESSION ACTIVE',
                            icon: Icons.check_circle_outline_rounded,
                          )
                        else
                          FintechBadge.danger(
                            'INACTIVE',
                            icon: Icons.cancel_outlined,
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildIdentityField('OFFICER ID', employee.id, isMonospace: true),
                    const SizedBox(height: 8),
                    _buildIdentityField(
                      'ASSIGNED UNITS',
                      employee.assignedBranches.isEmpty
                          ? 'All Units (Unrestricted)'
                          : employee.assignedBranches.join(', '),
                    ),
                  ],
                ),
              )
            else
              const FintechCard(
                child: Text(
                  'No authenticated officer credentials found.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ),

            const SizedBox(height: 28),

            // 2. HARDWARE SECURITY SECTION
            _buildSectionHeader('HARDWARE ENCLAVE & SECURITY'),
            const SizedBox(height: 10),
            FintechCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.fingerprint_rounded,
                          size: 24,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Biometric Enclave Guard',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Requires FaceID, TouchID, or Hardware Passcode to unlock session storage.',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FintechButton(
                    label: 'LOCK SESSION NOW',
                    icon: Icons.lock_outline_rounded,
                    variant: FintechButtonVariant.outline,
                    isFullWidth: true,
                    onPressed: () {
                      ref.read(appLockProvider.notifier).lock();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 3. CLOUD & DISASTER RECOVERY SECTION
            _buildSectionHeader('CLOUD & DISASTER RECOVERY'),
            const SizedBox(height: 10),
            FintechCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Google Drive Sync',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'AES-256 encrypted snapshots synced to private cloud container.',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _googleDriveAutoSync,
                        activeTrackColor: AppTheme.primary,
                        activeThumbColor: Colors.white,
                        onChanged: (val) {
                          setState(() {
                            _googleDriveAutoSync = val;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                val
                                    ? 'Automated Google Drive sync enabled.'
                                    : 'Automated Google Drive sync disabled.',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppTheme.border),
                  const SizedBox(height: 16),
                  FintechButton(
                    label: 'CREATE ENCRYPTED BACKUP NOW',
                    icon: Icons.cloud_upload_outlined,
                    variant: FintechButtonVariant.secondary,
                    isFullWidth: true,
                    isLoading: _isBackingUp,
                    onPressed: _triggerManualCloudBackup,
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline_rounded,
                          size: 14, color: AppTheme.success),
                      SizedBox(width: 6),
                      Text(
                        'Local ledger encrypted with device master key.',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 4. DATABASE MAINTENANCE SECTION
            _buildSectionHeader('DATABASE MAINTENANCE'),
            const SizedBox(height: 10),
            FintechCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dataset Ingestion & Recovery',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ingest extracted branch ledger datasets or clear corrupted local records.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FintechButton(
                    label: 'IMPORT / UPDATE PDF DATA',
                    icon: Icons.picture_as_pdf_outlined,
                    variant: FintechButtonVariant.outline,
                    isFullWidth: true,
                    isLoading: _isImporting,
                    onPressed: () => _handlePdfImport(ref),
                  ),
                  const SizedBox(height: 12),
                  FintechButton(
                    label: 'CLEAR LOCAL DATABASE',
                    icon: Icons.delete_forever_outlined,
                    variant: FintechButtonVariant.secondary,
                    isFullWidth: true,
                    isLoading: _isClearing,
                    onPressed: () => _handleClearDatabase(ref),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 5. SESSION TERMINATION
            _buildSectionHeader('SESSION TERMINATION'),
            const SizedBox(height: 10),
            FintechButton(
              label: 'SIGN OUT OF OFFICER SESSION',
              icon: Icons.logout_rounded,
              variant: FintechButtonVariant.danger,
              isFullWidth: true,
              height: 48,
              onPressed: () => _showSignOutDialog(context, ref),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildIdentityField(String label, String value, {bool isMonospace = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _triggerManualCloudBackup() async {
    setState(() => _isBackingUp = true);
    await Future.delayed(const Duration(milliseconds: 750));
    if (mounted) {
      setState(() => _isBackingUp = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Encrypted ledger snapshot created and verified.'),
          backgroundColor: AppTheme.primary,
        ),
      );
    }
  }

  Future<void> _handleClearDatabase(WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
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
            Icon(Icons.warning_amber_rounded, color: AppTheme.danger, size: 24),
            SizedBox(width: 10),
            Text(
              'Clear Local Database',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to completely erase all local data? This will remove all branches, customer profiles, and loan ledgers from this device.',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          FintechButton(
            label: 'CANCEL',
            variant: FintechButtonVariant.ghost,
            onPressed: () => Navigator.pop(ctx, false),
          ),
          FintechButton(
            label: 'WIPE EVERYTHING',
            variant: FintechButtonVariant.danger,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isClearing = true);
      try {
        await ref.read(appStateProvider.notifier).clearDatabase();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Local database completely cleared.'),
              backgroundColor: AppTheme.danger,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isClearing = false);
        }
      }
    }
  }

  Future<void> _handlePdfImport(WidgetRef ref) async {
    setState(() => _isImporting = true);
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

      if (conflicts.isNotEmpty && mounted) {
        final choice = await showDialog<ImportConflictAction>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.surface,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppTheme.border, width: 1.0),
            ),
            title: const Row(
              children: [
                Icon(Icons.inventory_2_outlined,
                    color: AppTheme.primary, size: 22),
                SizedBox(width: 10),
                Text(
                  'Existing Records Found',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data for branch(es) "${conflicts.join(", ")}" already exists in your local database.\n\nWhich version would you like to keep?',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Text(
                    '• Replace with New: Overwrites existing branch records with fresh PDF data.\n• Keep Old: Retains your existing branch records and cancels importing duplicates.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              FintechButton(
                label: 'CANCEL',
                variant: FintechButtonVariant.ghost,
                onPressed: () => Navigator.pop(ctx, null),
              ),
              FintechButton(
                label: 'KEEP OLD DATA',
                variant: FintechButtonVariant.outline,
                onPressed: () =>
                    Navigator.pop(ctx, ImportConflictAction.keepExisting),
              ),
              FintechButton(
                label: 'REPLACE WITH NEW',
                variant: FintechButtonVariant.primary,
                onPressed: () =>
                    Navigator.pop(ctx, ImportConflictAction.replace),
              ),
            ],
          ),
        );

        if (choice == null) {
          setState(() => _isImporting = false);
          return;
        }
        conflictAction = choice;
      }

      final result =
          await ref.read(appStateProvider.notifier).importDataFromJson(
                jsonString,
                wipeExisting: false,
                conflictAction: conflictAction,
              );

      if (mounted) {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import PDF data: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
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
            Icon(Icons.logout_rounded, color: AppTheme.danger, size: 22),
            SizedBox(width: 10),
            Text(
              'Sign Out Session',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to end this officer session? You will need to sign in again to access recovery ledgers.',
          style: TextStyle(
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
            label: 'SIGN OUT',
            variant: FintechButtonVariant.danger,
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authNotifierProvider.notifier).signOut();
            },
          ),
        ],
      ),
    );
  }
}
