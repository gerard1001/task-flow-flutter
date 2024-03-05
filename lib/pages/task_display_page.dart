import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/api/user_api.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

@RoutePage()
class TaskDisplayPage extends StatefulWidget {
  const TaskDisplayPage({super.key});

  @override
  State<TaskDisplayPage> createState() => _TaskDisplayPageState();
}

class _TaskDisplayPageState extends State<TaskDisplayPage> {
  var log = Logger(
    printer: PrettyPrinter(),
  );

  var user = {};
  final userBox = Hive.box('user');

  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    try {
      final response = await UserApi.getUserByToken();
      if (response != null && response.statusCode == 200) {
        log.i(response.data);
        setState(() {
          user = response.data;
        });
      } else {
        returnToLogin();
      }
    } catch (e) {
      log.e(e);
    }
  }

  void returnToLogin() {
    // AutoRouter.of(context).push(const SignInRoute());
    log.w(user);
  }

  @override
  Widget build(BuildContext context) {
    DecorationImage decorationImage = DecorationImage(
      image: NetworkImage('${user['picture']}'),
      fit: BoxFit.cover,
    );

    return PageWrapper(
        child: Container(
      padding: const EdgeInsets.only(
          left: 16.0, top: 30.0, right: 16.0, bottom: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
              ),
              Text(
                'Tasks',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TaskFlowColors.primaryDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              PopupMenuButton(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20).copyWith(
                    topRight: const Radius.circular(0),
                  ),
                ),
                elevation: 10,
                color: TaskFlowColors.primaryLight,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: TaskFlowColors.teal,
                      width: 2,
                    ),
                    image: decorationImage,
                  ),
                ),
                onSelected: (value) {},
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      padding: const EdgeInsets.only(right: 50, left: 20),
                      value: 'Chats',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 20,
                                color: TaskFlowColors.primaryDark,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Update',
                                style: TextStyle(
                                    color: TaskFlowColors.primaryDark,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          // const Divider()
                        ],
                      ),
                    ),
                    PopupMenuItem(
                        padding: const EdgeInsets.only(right: 50, left: 20),
                        value: 'Sign out',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 20,
                                  color: TaskFlowColors.primaryDark,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Sign out',
                                  style: TextStyle(
                                      color: TaskFlowColors.primaryDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            // const Divider()
                          ],
                        )),
                  ];
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              returnToLogin();
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
