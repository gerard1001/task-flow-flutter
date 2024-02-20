import 'package:flutter/material.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

class LandingPageOne extends StatelessWidget {
  const LandingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Landing Page One",
        style: TaskFlowStyles.large,
      ),
    );
  }
}
