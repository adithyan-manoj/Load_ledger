import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_models.dart';
import '../../core/auth/auth_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/background_scaffold.dart';
import '../../widgets/glass_card.dart';

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

    return BackgroundScaffold(
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

                // Main Login Glass Card
                GlassCard(
                  padding: const EdgeInsets.all(32),
                  borderRadius: 28,
                  borderOpacity: 0.4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Text(
                        'Kerala Co-operative Bank',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Loan Ledger & Recovery',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Authorized Officer & Auditor Gateway',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 28),

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
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 18,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Access is strictly limited to pre-whitelisted employee Google accounts.',
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
                Text(
                  'End-to-End Encrypted • Local-First Architecture',
                  style: TextStyle(
                    color: AppTheme.textSecondary.withValues(alpha: 0.5),
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemBadge() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withValues(alpha: 0.3),
            AppTheme.accent.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.2),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.account_balance_rounded,
          size: 38,
          color: Colors.white,
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF1B261E),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGoogleLogo(),
                    const SizedBox(width: 14),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Color(0xFF1F1F1F),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
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
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color(0xFF4285F4),
                  Color(0xFF34A853),
                  Color(0xFFFBBC05),
                  Color(0xFFEA4335),
                ],
              ).createShader(const Rect.fromLTWH(0, 0, 22, 22)),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String? message, AuthNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFB00020).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFCF6679).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.gpp_bad_rounded,
            color: Color(0xFFCF6679),
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
                    color: Color(0xFFCF6679),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message ?? 'Your Google account is not authorized.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Colors.white60),
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
        color: const Color(0xFF880E4F).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFF4081).withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.phonelink_erase_rounded,
            color: Color(0xFFFF4081),
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
                    color: Color(0xFFFF4081),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message ??
                      'This device has been remotely revoked by administration. Local session wiped.',
                  style: const TextStyle(
                    color: Colors.white70,
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
                Text(
                  'Developer Test Simulator',
                  style: TextStyle(
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showDebugMock) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _mockTokenController,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              labelText: 'Simulated Token or Email',
              labelStyle:
                  TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              isDense: true,
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: state.isAuthenticating
                      ? null
                      : () {
                          notifier.signInWithGoogle(
                            customIdToken: _mockTokenController.text.trim(),
                            deviceName: 'Developer Workstation',
                          );
                        },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.primary.withValues(alpha: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simulate Authorized Login',
                    style: TextStyle(fontSize: 11, color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: state.isAuthenticating
                      ? null
                      : () {
                          notifier.signInWithGoogle(
                            customIdToken:
                                'mock_id_token:unauthorized@unknown.com',
                            deviceName: 'Developer Workstation',
                          );
                        },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: const Color(0xFFCF6679).withValues(alpha: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simulate Unauthorized',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFCF6679),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

