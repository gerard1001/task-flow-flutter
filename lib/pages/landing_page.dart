import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
import 'package:task_flow_flutter/components/intro_pages/landing_page_one.dart';
import 'package:task_flow_flutter/components/intro_pages/landing_page_three.dart';
import 'package:task_flow_flutter/components/intro_pages/landing_page_two.dart';
import 'package:task_flow_flutter/pages/get_started_page.dart';

class LandingPage extends StatefulWidget {
  static const String routeName = '/';

  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (int page) {
              if (page == 2) {
                setState(() {
                  onLastPage = true;
                });
              } else {
                setState(() {
                  onLastPage = false;
                });
              }
            },
            children: const [
              LandingPageOne(),
              LandingPageTwo(),
              LandingPageThree(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          controller.jumpToPage(0);
                        },
                        child: const Text(
                          'Back',
                          style: TaskFlowStyles.small,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          context.go(GetStartedPage.routeName);
                        },
                        child: const Text(
                          'Skip',
                          style: TaskFlowStyles.small,
                        ),
                      ),
                SmoothPageIndicator(controller: controller, count: 3),
                !onLastPage
                    ? GestureDetector(
                        onTap: () {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text(
                          'Next',
                          style: TaskFlowStyles.small,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          context.go(GetStartedPage.routeName);
                        },
                        child: const Text(
                          'Done',
                          style: TaskFlowStyles.small,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
