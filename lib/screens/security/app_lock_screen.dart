import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/security_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/fintech_components.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String? _errorMessage;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    // Prompt biometric sheet smoothly after first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerUnlock();
    });
  }

  Future<void> _triggerUnlock() async {
    if (_isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    final result =
        await ref.read(appLockProvider.notifier).authenticateAndUnlock();

    if (mounted) {
      setState(() {
        _isAuthenticating = false;
        if (!result.isAuthenticated && result.errorMessage != null) {
          _errorMessage = result.errorMessage;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: FintechCard(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.border,
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 32,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'SECURITY LOCK',
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Co-operative Loan Ledger',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Financial data is protected with hardware-backed AES-256 encryption. Verify identity to access customer records.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.dangerLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.danger.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 16,
                              color: AppTheme.danger,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: AppTheme.danger,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    FintechButton(
                      label: 'UNLOCK WITH BIOMETRICS',
                      icon: Icons.fingerprint_rounded,
                      variant: FintechButtonVariant.primary,
                      isFullWidth: true,
                      height: 50,
                      isLoading: _isAuthenticating,
                      onPressed: _triggerUnlock,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
