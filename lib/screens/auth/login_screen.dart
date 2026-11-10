import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_models.dart';
import '../../core/auth/auth_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/fintech_components.dart';

/// Screen displayed when user is unauthenticated or revoked.
/// Facilitates Google Sign-In with backend whitelist authorization.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _mockTokenController = TextEditingController(
    text: 'mock_id_token:officer@keralabank.co.in',
  );
  bool _showDebugMock = false;

  @override
  void dispose() {
    _mockTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Seal / Emblem
                  _buildSystemBadge(),
                  const SizedBox(height: 24),

                  // Main Login Fintech Card
                  FintechCard(
                    padding: const EdgeInsets.all(32),
                    borderRadius: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        const Text(
                          'Kerala Co-operative Bank',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Loan Ledger & Recovery',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Authorized Officer & Auditor Gateway',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Error / Revocation Status Alert
                        if (authState.isRevoked) ...[
                          _buildRevokedBanner(authState.errorMessage),
                          const SizedBox(height: 20),
                        ] else if (authState.hasError) ...[
                          _buildErrorBanner(authState.errorMessage, authNotifier),
                          const SizedBox(height: 20),
                        ],

                        // Security Notice Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.border,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 18,
                                color: AppTheme.primary,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Access strictly limited to pre-whitelisted officer credentials.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Google Sign-In Action Button
                        _buildGoogleSignInButton(authState, authNotifier),

                        // Debug / Simulator Mode for Testing without Google Play Services
                        if (kDebugMode) ...[
                          const SizedBox(height: 24),
                          _buildDebugSection(authState, authNotifier),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Footer note
                  const Text(
                    'End-to-End Encrypted • Hardware Security Enclave',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 11,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemBadge() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.account_balance_rounded,
          size: 34,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(AuthState state, AuthNotifier notifier) {
    final isLoading = state.isAuthenticating;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading
            ? null
            : () {
                notifier.signInWithGoogle();
              },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGoogleLogo(),
                    const SizedBox(width: 12),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildGoogleLogo() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color(0xFF4285F4),
                  Color(0xFF34A853),
                  Color(0xFFFBBC05),
                  Color(0xFFEA4335),
                ],
              ).createShader(const Rect.fromLTWH(0, 0, 20, 20)),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String? message, AuthNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.dangerLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.danger.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.gpp_bad_rounded,
            color: AppTheme.danger,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Authorization Denied',
                  style: TextStyle(
                    color: AppTheme.danger,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message ?? 'Your Google account is not authorized.',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: AppTheme.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => notifier.clearError(),
          ),
        ],
      ),
    );
  }

  Widget _buildRevokedBanner(String? message) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.dangerLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.danger,
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.phonelink_erase_rounded,
            color: AppTheme.danger,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Device Access Blacklisted',
                  style: TextStyle(
                    color: AppTheme.danger,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message ??
                      'This device has been remotely revoked by administration. Local session wiped.',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugSection(AuthState state, AuthNotifier notifier) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showDebugMock = !_showDebugMock;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _showDebugMock
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: AppTheme.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Developer Test Simulator',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showDebugMock) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _mockTokenController,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Simulated Token or Email',
              labelStyle: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
              isDense: true,
              filled: true,
              fillColor: AppTheme.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppTheme.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppTheme.border,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FintechButton(
                  label: 'SIMULATE LOGIN',
                  variant: FintechButtonVariant.secondary,
                  height: 38,
                  fontSize: 11,
                  isLoading: state.isAuthenticating,
                  onPressed: () {
                    notifier.signInWithGoogle(
                      customIdToken: _mockTokenController.text.trim(),
                      deviceName: 'Developer Workstation',
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FintechButton(
                  label: 'SIMULATE UNAUTHORIZED',
                  variant: FintechButtonVariant.outline,
                  height: 38,
                  fontSize: 11,
                  isLoading: state.isAuthenticating,
                  onPressed: () {
                    notifier.signInWithGoogle(
                      customIdToken: 'mock_id_token:unauthorized@unknown.com',
                      deviceName: 'Developer Workstation',
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
