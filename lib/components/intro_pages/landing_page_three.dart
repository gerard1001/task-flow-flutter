import 'package:flutter/material.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

class LandingPageThree extends StatelessWidget {
  const LandingPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Landing Page Three",
        style: TaskFlowStyles.small,
      ),
    );
  }
}
