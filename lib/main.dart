import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_flow_flutter/config/routes/app_router.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = AppRouter();
    return MaterialApp.router(
      title: 'Task Flow',
      debugShowCheckedModeBanner: false,
      theme: TaskFlowTheme.themeData,
      routerConfig: appRouter.config(),
    );
  }
}
