import 'package:flutter/material.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/sign-up';

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: TaskFlowColors.secondaryDark,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: TaskFlowColors.secondaryDark,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: TaskFlowColors.secondaryDark,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: TaskFlowColors.teal,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                color: TaskFlowColors.secondaryLight,
                icon: const Icon(
                  Icons.arrow_forward_outlined,
                  size: 45,
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
