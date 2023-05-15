// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:blurt/view/auth/register_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blurt/firebase_options.dart';
import 'package:blurt/view/auth/login.dart';
import 'package:blurt/view/auth/register.dart';
import 'package:blurt/view/main/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:blurt/main.dart';
import 'package:mockito/mockito.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  MockFirebaseAuth? mockFirebaseAuth = null;
  UserCredential userCredential;

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
  });

  testWidgets('Firebase initialized', (WidgetTester tester) async {
    expect(Firebase.apps.length, greaterThan(0));
  });

  testWidgets("Login Validation [Empty]", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MainAuth(
        page: Login(),
      ),
    ));

    await tester.enterText(find.byKey(LoginForm.emailFieldKey), '');
    await tester.enterText(find.byKey(LoginForm.passwordFieldKey), '');

    await tester.tap(find.byKey(LoginForm.loginBntKey));
    await tester.pump();

    expect(find.text('The password field was empty'), findsOneWidget);
    expect(find.text('The email field was empty'), findsOneWidget);
  });

  testWidgets("Login Validation [Filled]", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MainAuth(
        page: Login(),
      ),
    ));

    await tester.enterText(find.byKey(LoginForm.emailFieldKey), 'a');
    await tester.enterText(find.byKey(LoginForm.passwordFieldKey), 'a');

    await tester.tap(find.byKey(LoginForm.loginBntKey));
    await tester.pumpAndSettle();

    expect(find.text('The password field was empty'), findsNothing);
    expect(find.text('The email field was empty'), findsNothing);
  });

  // testWidgets("Register Validation [Empty]", (tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: MainAuth(
  //       page: Register(),
  //     ),
  //   ));

  //   // await tester.enterText(find.byKey(LoginForm.emailFieldKey), '');
  //   // await tester.enterText(find.byKey(LoginForm.passwordFieldKey), '');

  //   await tester.tap(find.byKey(RegisterForm.registerBntKey));
  //   await tester.pumpAndSettle();

  //   expect(find.text('The email field was empty'), findsOneWidget);
  //   expect(find.text('The password field was empty'), findsOneWidget);
  //   expect(
  //       find.text('The password confirmation field was empty'), findsOneWidget);
  // });

  // testWidgets("Register Validation [Mismatching Pass]", (tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: MainAuth(
  //       page: Register(),
  //     ),
  //   ));

  //   await tester.enterText(
  //       find.byKey(RegisterForm.passwordConfirmFieldKey), 'test1');
  //   await tester.enterText(find.byKey(RegisterForm.passwordFieldKey), 'test');

  //   await tester.tap(find.byKey(RegisterForm.registerBntKey));
  //   await tester.pumpAndSettle();

  //   expect(find.text('Passwords do not match'), findsOneWidget);
  // });

  // testWidgets("Register Validation [Invalid Email]", (tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: MainAuth(
  //       page: Register(),
  //     ),
  //   ));

  //   await tester.enterText(find.byKey(RegisterForm.emailFieldKey), 'test');

  //   await tester.tap(find.byKey(RegisterForm.registerBntKey));
  //   await tester.pumpAndSettle();

  //   expect(find.text('Please enter a valid email address'), findsOneWidget);
  // });

  // testWidgets("Register Validation [Filled]", (tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: MainAuth(
  //       page: Register(),
  //     ),
  //   ));

  //   await tester.enterText(
  //       find.byKey(RegisterForm.emailFieldKey), 'email@email.com');
  //   await tester.enterText(
  //       find.byKey(RegisterForm.passwordConfirmFieldKey), 'test1');
  //   await tester.enterText(find.byKey(RegisterForm.passwordFieldKey), 'test1');

  //   await tester.tap(find.byKey(RegisterForm.registerBntKey));
  //   await tester.pumpAndSettle();

  //   expect(find.text('The email field was empty'), findsNothing);
  //   expect(find.text('The password field was empty'), findsNothing);
  //   expect(find.text('Passwords do not match'), findsNothing);
  // });

  // testWidgets("Information Validation [Empty]", (tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: MainAuth(
  //       page: RegisterInfo(),
  //     ),
  //   ));

  //   // await tester.enterText(
  //   //     find.byKey(RegisterForm.emailFieldKey), 'email@email.com');
  //   // await tester.enterText(
  //   //     find.byKey(RegisterForm.passwordConfirmFieldKey), 'test1');
  //   // await tester.enterText(find.byKey(RegisterForm.passwordFieldKey), 'test1');

  //   await tester.tap(find.byKey(RegisterPersonalForm.addInfoBnt));
  //   await tester.pumpAndSettle();

  //   expect(find.text('please enter a username'), findsNothing);
  //   expect(find.text('please enter your first name'), findsNothing);
  //   expect(find.text('please enter your last name'), findsNothing);
  //   expect(find.text('please enter your phone number'), findsNothing);
  //   expect(find.text('Please enter a date'), findsNothing);
  // });
  // Test form validation fails (information)
  // Test form validation passes (information)

  //
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}
