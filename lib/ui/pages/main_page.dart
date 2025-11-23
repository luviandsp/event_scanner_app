import 'package:event_scanner_app/ui/utils/custom_colors.dart';
import 'package:event_scanner_app/ui/components/custom_body.dart';
import 'package:event_scanner_app/ui/components/custom_header.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkGreen,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            child: CustomHeader(),
          ),
          CustomBody(),
        ],
      ),
    );
  }
}
