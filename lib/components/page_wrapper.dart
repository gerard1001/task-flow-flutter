import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_flow_flutter/api/user_api.dart';
import 'package:task_flow_flutter/config/routes/app_router.gr.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

class PageWrapper extends StatefulWidget {
  final Widget child;
  final bool showAppBar;
  final bool showBottomNavBar;

  const PageWrapper({
    super.key,
    required this.child,
    this.showAppBar = false,
    this.showBottomNavBar = true,
  });

  @override
  State<PageWrapper> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  // Future.delayed(Duration.zero, () {
  //   final router = GoRouter.of(context);
  //   router.addMiddleware((context, state, next) {
  //     print('PageWrapper: ${state.location}');
  //     next();
  //   });
  // });

  bool isLoggedIn = false;
  String currentPath = '';

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  Future<void> checkIsLoggedIn() async {
    final validUser = await UserApi.getUserByToken();
    if (validUser!.statusCode == 200) {
      setState(() {
        isLoggedIn = true;
        currentPath = context.router.currentPath;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: TaskFlowColors.teal,
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 40.0,
                  color: TaskFlowColors.secondaryLight,
                ),
                onPressed: () {
                  context.router.back();
                },
              ),
            )
          : null,
      bottomNavigationBar: isLoggedIn && widget.showBottomNavBar
          ? BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: 0,
              onTap: (value) {
                switch (value) {
                  case 0:
                    AutoRouter.of(context).push(const TaskDisplayRoute());
                    break;
                  case 1:
                    AutoRouter.of(context).push(const SignInRoute());
                    break;
                  case 2:
                    AutoRouter.of(context).push(const SignInRoute());
                    break;
                  case 3:
                    AutoRouter.of(context).push(const SignInRoute());
                    break;
                  default:
                }
              },
              items: [
                BottomNavigationBarItem(
                  activeIcon: currentPath == '/task-display-route'
                      ? Icon(
                          Icons.task_rounded,
                          color: TaskFlowColors.brown,
                          size: 28.0,
                        )
                      : null,
                  icon: Icon(
                    Icons.task_outlined,
                    color: TaskFlowColors.primaryDark,
                    size: 28.0,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: TaskFlowColors.primaryDark,
                    size: 28.0,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.people_alt_outlined,
                    color: TaskFlowColors.primaryDark,
                    size: 28.0,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: TaskFlowColors.primaryDark,
                    size: 28.0,
                  ),
                  label: '',
                ),
              ],
            )
          : null,
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Flexible(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
