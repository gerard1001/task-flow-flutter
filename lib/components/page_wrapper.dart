import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
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
      bottomNavigationBar: widget.showBottomNavBar
          ? BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.content_paste,
                    color: TaskFlowColors.primaryDark,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: TaskFlowColors.primaryDark,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.people_alt_outlined,
                    color: TaskFlowColors.primaryDark,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: TaskFlowColors.primaryDark,
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
