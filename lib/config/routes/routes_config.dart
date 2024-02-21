import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow_flutter/pages/get_started_page.dart';
import 'package:task_flow_flutter/pages/landing_page.dart';
import 'package:task_flow_flutter/pages/sign_up_page.dart';
import 'package:task_flow_flutter/pages/trials.dart';

Page<dynamic> Function(BuildContext, GoRouterState) customPageBuilder(
    Widget screen) {
  return (BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: screen,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
          child: SlideTransition(
            position: Tween(
              begin: Offset.zero,
              end: const Offset(0.5, 0.0),
            )
                .chain(CurveTween(curve: Curves.easeInOut))
                .animate(secondaryAnimation),
            child: child,
          ),
        );
      },
    );
  };
}

final routesConfig = GoRouter(
  initialLocation: LandingPage.routeName,
  routes: [
    GoRoute(
      path: LandingPage.routeName,
      pageBuilder: customPageBuilder(const LandingPage()),
    ),
    GoRoute(
      path: GetStartedPage.routeName,
      pageBuilder: customPageBuilder(const GetStartedPage()),
    ),
    GoRoute(
      path: SignUpPage.routeName,
      pageBuilder: customPageBuilder(const SignUpPage()),
    ),
    GoRoute(
        path: TrialPage.routeName,
        pageBuilder: customPageBuilder(const TrialPage())),
  ],
);
