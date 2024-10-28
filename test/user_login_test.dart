import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/responses/user_login.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('LoginScreen', () {
    late TextEditingController emailController;
    late TextEditingController passwordController;
    late UserProvider mockUserProvider;

    setUp(() {
      emailController = TextEditingController();
      passwordController = TextEditingController();
      mockUserProvider = UserProvider();
    });

    testWidgets('renders LoginScreen and input fields', (WidgetTester tester) async {
      // Build the LoginScreen widget with a mock UserProvider
      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>(
          create: (_) => mockUserProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      // Verify if the email and password input fields are present
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);

      // Verify if the login button is present
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('shows loading indicator while logging in', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>(
          create: (_) => mockUserProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      // Tap the login button to trigger loginUser
      await tester.tap(find.text('Log In'));
      await tester.pump(); // Trigger the state change

      // Verify that CircularProgressIndicator is shown during login
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('navigates to KoiListPage after successful login', (WidgetTester tester) async {
      mockUserProvider.user = {} as UserLoginResponse?; // Simulate a successful login

      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>(
          create: (_) => mockUserProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      // Tap the login button
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle(); // Wait for the navigation to finish

      // Verify that we navigated to KoiListPage
      expect(find.text('KoiListPage'), findsOneWidget); // Assuming there's a title or text in KoiListPage
    });

    testWidgets('shows error message on failed login', (WidgetTester tester) async {
      mockUserProvider.user = null; // Simulate a failed login

      await tester.pumpWidget(
        ChangeNotifierProvider<UserProvider>(
          create: (_) => mockUserProvider,
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      // Tap the login button
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle(); // Wait for error message

      // Verify the error message is shown
      expect(find.text('Invalid email or password, Please try again!'), findsOneWidget);
    });
  });
}
