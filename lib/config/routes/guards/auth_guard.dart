import 'package:auto_route/auto_route.dart';
import 'package:task_flow_flutter/api/user_api.dart';
import 'package:task_flow_flutter/config/routes/app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isLoggedIn = await UserApi.getUserByToken();
    // log.w(isLoggedIn!.statusCode);
    if (isLoggedIn!.statusCode == 200) {
      resolver.next(true);
    } else {
      router.push(const SignInRoute());
    }
  }
}
