import 'package:flutter/material.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

class LandingPageOne extends StatelessWidget {
  const LandingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "TASK FLOW",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: TaskFlowColors.teal,
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Image.asset(
              'assets/images/intro.png',
              width: 250,
              height: 250,
            ),
          ),
          Text(
            "Welcome to Task Flow",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: TaskFlowColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
