import 'package:flutter/material.dart';
import 'package:event_scanner_app/ui/components/setting_item.dart';
import 'package:event_scanner_app/ui/pages/main_page.dart';
import '../../utils/custom_colors.dart';
import '../auth_pages/login_page_staff.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkGreen,
      body: Stack(
        children: [
          // (Foto & Info)
          Container(
            padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
            width: double.infinity,
            color: CustomColors.darkGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context
                      , MaterialPageRoute(builder: (_) => const MainPage()),
                    );
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 20),

                // PROFILE PHOTO
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5"),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Staff@gmail.com",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Name Staff",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // Base White
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.darkGreen,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ----- Setting Items -----
                    SettingItem(
                      icon: Icons.person,
                      title: "My Account",
                      onTap: () {},
                    ),
                    SettingItem(
                      icon: Icons.lock,
                      title: "Security",
                      onTap: () {},
                    ),
                    SettingItem(
                      icon: Icons.calendar_month,
                      title: "Calendar",
                      onTap: () {},
                    ),
                    SettingItem(
                      icon: Icons.notifications,
                      title: "Notification",
                      onTap: () {},
                    ),
                    SettingItem(
                      icon: Icons.storage,
                      title: "Data",
                      onTap: () {},
                    ),
                    SettingItem(
                      icon: Icons.info,
                      title: "About",
                      onTap: () {},
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Activity",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.darkGreen,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Go to Login Page
                    SettingItem(
                      icon: Icons.logout,
                      title: "Log Out",
                      onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                        MaterialPageRoute(builder: (_) => const LoginPageStaff()),
                          (route) => false,
                        );
                      },
                )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
