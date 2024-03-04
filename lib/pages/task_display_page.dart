import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';

@RoutePage()
class TaskDisplayPage extends StatefulWidget {
  const TaskDisplayPage({super.key});

  @override
  State<TaskDisplayPage> createState() => _TaskDisplayPageState();
}

class _TaskDisplayPageState extends State<TaskDisplayPage> {
  void returnToLogin() {}

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        showAppBar: true,
        showBottomNavBar: true,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // returnToLogin();
                },
                child: Container(
                  color: Colors.blue,
                  child: const Text('Task Display Page'),
                ),
              ),
            ],
          ),
        ));
  }
}
