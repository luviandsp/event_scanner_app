import 'package:event_scanner_app/ui/pages/auth_pages/login_page.dart';
import 'package:event_scanner_app/ui/pages/detail_ticket/ticket_detil.dart';
import 'package:event_scanner_app/ui/pages/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Scanner App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        // '/': (context) => const MainPage(),
        '/': (context) => const TechTalkScreen(),
      },
    );
  }
}
