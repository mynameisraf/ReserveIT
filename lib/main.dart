import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'main_page.dart';
import 'users_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (_) {
    // If [DEFAULT] app was already initialized natively or via hot restart, proceed safely
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReserveIT',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1730),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Color(0xFF0D1730),
          secondary: Color(0xFF2E5AAC),
          surface: Color(0xFF152244),
          onSurface: Colors.white,
        ),
      ),
      home: const MainPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/users': (context) => const UsersPage(),
      },
    );
  }
}
