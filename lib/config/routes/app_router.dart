import 'package:auto_route/auto_route.dart';
import 'package:task_flow_flutter/config/routes/guards/auth_guard.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LandingRoute.page, initial: true),
        AutoRoute(page: GetStartedRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: TaskDisplayRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: TrialRoute.page),
      ];
}
