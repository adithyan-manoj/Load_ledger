import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_components.dart';

class SplashLoadingScreen extends StatelessWidget {
  final String message;
  const SplashLoadingScreen({super.key, this.message = 'Synchronizing...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FintechCard(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.border),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.security_rounded,
                          size: 24,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  message.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    letterSpacing: 1.5,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'ENCRYPTED · LOCAL-FIRST · RECOVERY',
                  style: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
