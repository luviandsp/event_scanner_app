import 'package:event_scanner_app/ui/pages/auth_pages/login_page_staff.dart';
import 'package:event_scanner_app/ui/pages/detail_ticket/ticket_detil.dart';
import 'package:event_scanner_app/ui/pages/main_page.dart';
import 'package:event_scanner_app/ui/pages/scanner_pages/scanner_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mmkv/mmkv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final rootDir = await MMKV.initialize();
  Logger().i('MMKV initialized at: $rootDir');

  runApp(const ProviderScope(child: MyApp()));
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
        '/login': (context) => const LoginPageStaff(),
        '/': (context) => const MainPage(),
        '/detail-ticket': (context) => const TechTalkScreen(),
        // '/myqr-page': (context) => const MyQRPage(participant: participant),
        '/scan-ticket': (context) => const ScannerQrPage(),
        // '/scan-result' : (context) => const ScanResultPage(scannedCode: scannedCode),
      },
    );
  }
}
