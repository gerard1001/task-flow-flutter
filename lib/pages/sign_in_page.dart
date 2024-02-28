import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
import 'package:task_flow_flutter/pages/get_started_page.dart';
import 'package:task_flow_flutter/pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/sign-in';
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var log = Logger(
    printer: PrettyPrinter(),
  );

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void submitFx() {
    if (_formKey.currentState!.validate()) {
      log.t({
        'email': emailController.text,
        'password': passwordController.text,
      });
    }
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value) || value.isEmpty
        ? 'Enter a valid email address'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      popRouteName: GetStartedPage.routeName,
      showBottomNavBar: false,
      child: Container(
        padding:
            const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 20),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset('assets/images/logo.png',
                    height: 80, width: 80),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Welcome To TaskFlow',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TaskFlowColors.primaryDark,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Wrap(
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            context.go(SignUpPage.routeName);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: TaskFlowColors.teal,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: TaskFlowColors.secondaryDark,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return "Password can't be empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: TaskFlowColors.secondaryDark,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          submitFx();
                        },
                        color: TaskFlowColors.teal,
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, top: 13, bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('SUBMIT',
                            style: TextStyle(
                              color: TaskFlowColors.primaryLight,
                              fontSize: 18,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // ),
      ),
    );
  }
}
