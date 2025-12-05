import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_scanner_app/ui/pages/profile_pages/profile_page.dart';

class CustomHeader extends ConsumerWidget {
  const CustomHeader({super.key});

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 15) return 'Good Afternoon';
    if (hour < 18) return 'Good Evening';
    return 'Good Night';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider);

    return Row(
      children: [
        // Logo Image
        Image.asset('assets/icons/logo.png', width: 50, height: 50),

        const SizedBox(width: 15),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Name!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getGreeting(),
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),

        const Spacer(),

        // Profile Image & Tap to Profile Page
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
          ),
        ),
      ],
    );
  }
}