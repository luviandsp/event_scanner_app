import 'package:flutter/material.dart';
import 'package:event_scanner_app/ui/pages/auth_pages/login_page_panitia.dart';
import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:event_scanner_app/ui/components/auth_input_field.dart';
import 'package:event_scanner_app/ui/components/auth_primary_button.dart';
import 'package:event_scanner_app/ui/components/auth_roleselector.dart';
import 'package:event_scanner_app/ui/pages/main_page.dart';

class LoginPageStaff extends StatefulWidget {
  const LoginPageStaff({super.key});

  @override
  State<LoginPageStaff> createState() => _LoginPageStaffState();
}

class _LoginPageStaffState extends State<LoginPageStaff> {
  String selectedRole = "Staff";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showEmailError = false;
  bool showPasswordError = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LOGO
              Image.asset(
                "assets/icons/logo.png", 
                width: 150,
              ),
              const SizedBox(height: 10),

              const Text(
                "Welcome to Scanner",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.darkGreen,
                  ),
              ),

              const SizedBox(height: 5),

              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.darkGreen,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Who are you?",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.darkGreen,
                ),
              ),

              const SizedBox(height: 10),

              // Role Selector
              RoleSelector(
                selectedRole: selectedRole,
                onChanged: (role) {
                   setState(() => selectedRole = role);

                if (role == "Panitia") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPagePanitia()),
                    );
                  }
                },
              ),

              const SizedBox(height: 25),

              // Email
              const Text(
                "Email Address",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.darkGreen,
                ),
              ),
              InputField(
                controller: emailController,
                hintText: "staff@gmail.com",
              ),
              if (showEmailError)
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Email is not Registered!",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 15),

              // Password
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.darkGreen,
                ),
              ),
              InputField(
                controller: passwordController,
                hintText: "********",
                obscureText: true,
              ),
              if (showPasswordError)
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Wrong Password!",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 15),

              // Remember me
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() => rememberMe = value!);
                    },
                  ),
                  const Text("Remember me"),
                ],
              ),

              const SizedBox(height: 10),

              // Login button
              PrimaryButton(
                text: "Login",
                onPressed: () {
                  setState(() {
                    showEmailError = emailController.text != "staff@gmail.com";
                    showPasswordError =
                        passwordController.text != "password123";
                  }
                );
                if (!showEmailError && !showPasswordError) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainPage()),
                  );
                }
               }),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.darkGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
