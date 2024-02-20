import 'package:flutter/material.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

class LandingPageTwo extends StatelessWidget {
  const LandingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Landing Page Two",
        style: TaskFlowStyles.medium,
      ),
    );
  }
}
