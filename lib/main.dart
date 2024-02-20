import 'package:flutter/material.dart';
import 'package:task_flow_flutter/config/routes/routes_config.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Task Flow',
      debugShowCheckedModeBanner: false,
      theme: TaskFlowTheme.themeData,
      routerConfig: routesConfig,
    );
  }
}
