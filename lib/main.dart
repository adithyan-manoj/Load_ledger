import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/branch_details_screen.dart';
import 'screens/customer_profile_screen.dart';
import 'screens/monthly_drafts_screen.dart';
import 'screens/pdf_preview_screen.dart';
import 'screens/security/app_lock_screen.dart';
import 'core/security/security_providers.dart';
import 'core/auth/auth_models.dart';
import 'core/auth/auth_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

/// Helper that bridges Riverpod AuthNotifier changes into a ChangeNotifier for GoRouter
class _AuthRouterListenable extends ChangeNotifier {
  _AuthRouterListenable(Ref ref) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      notifyListeners();
    });
  }
}

/// Provider managing application routing with reactive authentication guards.
final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthRouterListenable(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isLoggingIn = state.matchedLocation == '/login';

      // Allow initial session verification to complete without early redirection
      if (authState.status == AuthStatus.initial) {
        return null;
      }

      // If user is unauthenticated or revoked, guard protected routes
      if (!authState.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      // If already authenticated and trying to access /login, redirect to root
      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeDashboardScreen(),
      ),
      GoRoute(
        path: '/branch/:id',
        builder: (context, state) => BranchDetailsScreen(
          branchId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/customer/:id',
        builder: (context, state) => CustomerProfileScreen(
          customerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/branch/:id/drafts',
        builder: (context, state) => MonthlyDraftsScreen(
          branchId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/branch/:id/preview/:month/:year',
        builder: (context, state) => PdfPreviewScreen(
          branchId: state.pathParameters['id']!,
          month: int.parse(state.pathParameters['month']!),
          year: int.parse(state.pathParameters['year']!),
        ),
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = ref.watch(appLockProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Loan Recovery System',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [
            ?child,
            if (isLocked) const AppLockScreen(),
          ],
        );
      },
    );
  }
}
