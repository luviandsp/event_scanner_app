import 'package:flutter/material.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Statistic Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}