import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
import 'package:task_flow_flutter/pages/sign_up_page.dart';

class GetStartedPage extends StatelessWidget {
  static const String routeName = '/get-started';

  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.asset('assets/images/logo.png',
                  height: 250, width: 250),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Get Started',
                style: TaskFlowStyles.largeBold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Where productivity meets simplicity! I\'m Gerard, a seasoned full stack web developer with a passion for creating efficient solutions.',
                textAlign: TextAlign.center,
                style: TaskFlowStyles.small,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                onPressed: () {},
                color: TaskFlowColors.brown,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 17, bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text('LOGIN',
                    style: TextStyle(
                      color: TaskFlowColors.primaryLight,
                      fontSize: 24,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                onPressed: () {
                  context.go(SignUpPage.routeName);
                },
                minWidth: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 15, bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: TaskFlowColors.primaryDark, width: 2),
                ),
                child: const Text('SIGN UP', style: TaskFlowStyles.medium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
