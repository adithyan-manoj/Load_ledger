import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/main.dart';
import 'package:loan_recovery/screens/security/app_lock_screen.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets('App smoke test: boots and renders AppLockScreen overlay on launch',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();

    // The security lock screen should be displayed over the app on cold boot
    expect(find.byType(AppLockScreen), findsOneWidget);
    expect(find.text('SECURITY LOCK'), findsOneWidget);
  });
}
