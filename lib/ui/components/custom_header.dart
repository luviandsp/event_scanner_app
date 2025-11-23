import 'package:flutter/material.dart';

class CustomHeader extends StatefulWidget {
  const CustomHeader({super.key});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {

  @override
  Widget build(BuildContext context) {
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
              getGreeting(),
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),

        const Spacer(),

        // Profile Image
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
        ),
      ],
    );
  }
}

String getGreeting() {
  var hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 15) {
    return 'Good Afternoon';
  } else if (hour < 18) {
    return 'Good Evening';
  } else {
    return 'Good Night';
  }
}