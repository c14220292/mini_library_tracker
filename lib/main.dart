import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'login_page.dart';
import 'book_list_page.dart';
import 'add_book_page.dart';
import 'get_started_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDzFxLCmRU4VuK6wvZGn1M-rFiLMCeXITs",
      authDomain: "c14220292-minilibrarytracker.firebaseapp.com",
      projectId: "c14220292-minilibrarytracker",
      storageBucket: "c14220292-minilibrarytracker.appspot.com",
      messagingSenderId: "852330332273",
      appId: "1:852330332273:web:167e7805e01f6b4e255bd0",
    ),
  );

  await Hive.initFlutter();
  final box = await Hive.openBox('session');
  final bool isFirstTime = box.get('firstTime', defaultValue: true);
  final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

  runApp(MyApp(
    isFirstTime: isFirstTime,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;

  const MyApp({super.key, required this.isFirstTime, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Library Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isFirstTime ? '/getstarted' : '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/getstarted': (context) => const GetStartedPage(),
        '/login': (context) => const LoginPage(),
        '/add': (context) => const AddBookPage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const BookListPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
