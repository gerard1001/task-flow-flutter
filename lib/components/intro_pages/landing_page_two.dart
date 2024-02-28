import 'package:flutter/material.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

class LandingPageTwo extends StatelessWidget {
  const LandingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Image.asset(
              'assets/images/intro1.png',
              width: 250,
              height: 250,
            ),
          ),
          Text(
            'Manage your tasks with ease',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: TaskFlowColors.primaryDark,
            ),
          ),
          Text(
            'The best way to manage your tasks',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: TaskFlowColors.secondaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
