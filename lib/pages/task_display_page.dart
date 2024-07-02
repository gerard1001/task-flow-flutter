import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/api/task_api.dart';
import 'package:task_flow_flutter/api/user_api.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/components/task_tile.dart';
import 'package:task_flow_flutter/config/routes/app_router.gr.dart';
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
  var tasks = [];
  final userBox = Hive.box('user');

  @override
  void initState() {
    super.initState();
    getLoggedInUser();
    fetchTasks();
  }

  Future<void> getLoggedInUser() async {
    try {
      final response = await UserApi.getUserByToken();
      if (response != null && response.statusCode == 200) {
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

  Future<void> fetchTasks() async {
    final response = await TaskApi.getTasks();
    if (response != null && response.statusCode == 200) {
      log.i(response.data);
      setState(() {
        tasks = response.data;
      });
    } else {
      log.e(response);
    }
  }

  void returnToLogin() {
    AutoRouter.of(context).push(const SignInRoute());
    log.w(tasks);
  }

  void logout() {
    userBox.delete('token');
    returnToLogin();
  }

  DateTime dateTime = DateTime.now();

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2080),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(dateTime),
      );

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    setState(() => dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ));
  }

  Future openBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Padding(
              // padding: EdgeInsets.only(
              //   bottom: MediaQuery.of(context).viewInsets.bottom,
              // ),
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                child: createTaskForm(closeBottomSheet, pickDateTime, dateTime),
              ),
            );
          },
        );
      },
    );
  }

  void closeBottomSheet() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    DecorationImage decorationImage = DecorationImage(
      image: NetworkImage('${user['picture']}'),
      fit: BoxFit.cover,
    );

    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return PageWrapper(
      child: Container(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 30.0,
          right: 16.0,
          bottom: 16.0,
        ),
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
                  onSelected: (value) {
                    logout();
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        padding: const EdgeInsets.only(right: 50, left: 20),
                        value: 'Update',
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(children: [
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //   ),
                //   child: Text(
                //     '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                //     style: TextStyle(
                //       color: TaskFlowColors.primaryDark,
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   onPressed: () async {
                //     final date = await pickDate();
                //     if (date == null) return;

                //     setState(() {
                //       dateTime = date;
                //     });
                //     setState(() {
                //       dateTime = DateTime(
                //         date.year,
                //         date.month,
                //         date.day,
                //         dateTime.hour,
                //         dateTime.minute,
                //       );
                //     });
                //   },
                // ),
                // const SizedBox(width: 10),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //   ),
                //   child: Text(
                //     '$hours:$minutes',
                //     style: TextStyle(
                //       color: TaskFlowColors.primaryDark,
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   onPressed: () async {
                //     final time = await pickTime();

                //     if (time == null) return;

                //     setState(() {
                //       dateTime = DateTime(
                //         dateTime.year,
                //         dateTime.month,
                //         dateTime.day,
                //         time.hour,
                //         time.minute,
                //       );
                //     });
                //   },
                // ),
                // const SizedBox(width: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: pickDateTime,
                  child: Text(
                    '${dateTime.year}/${dateTime.month}/${dateTime.day} | $hours:$minutes',
                    style: TextStyle(
                      color: TaskFlowColors.primaryDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // ]),
                GestureDetector(
                  onTap: () {
                    openBottomSheet();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: TaskFlowColors.transparentBrown,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: TaskFlowColors.primaryLight,
                            size: 24,
                          ),
                          Text(
                            'Task',
                            style: TextStyle(
                              color: TaskFlowColors.primaryLight,
                              fontSize: 18,
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                    title: tasks[index]['title'],
                    startDate: tasks[index]['startDate'],
                    endDate: tasks[index]['endDate'],
                    categoryName: tasks[index]['category']['name'],
                    progress: tasks[index]['progess'],
                    userImages: tasks[index]['users'],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget createTaskForm(closeBottomSheet, pickDateTime, dateTime) {
  final hours = dateTime.hour.toString().padLeft(2, '0');
  final minutes = dateTime.minute.toString().padLeft(2, '0');
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TaskFlowColors.secondaryDark,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(
              'Add New Task',
              style: TextStyle(
                color: TaskFlowColors.primaryDark,
                fontSize: 20,
              ),
            ),
            GestureDetector(
              onTap: () => closeBottomSheet(),
              child: Icon(
                Icons.close,
                color: TaskFlowColors.primaryDark,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        /* Expanded here does a great trick here, SingleChildScrollView functions because of it */
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Task title can't be empty";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      hintText: 'Task title',
                      labelStyle: TextStyle(
                        // fontSize: 18,
                        color: TaskFlowColors.secondaryDark,
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: pickDateTime,
                    child: Text(
                      '${dateTime.year}/${dateTime.month}/${dateTime.day} | $hours:$minutes',
                      style: TextStyle(
                        color: TaskFlowColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Task Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        maxLines: 4,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Type your task description',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: () {}, child: const Text('Submit'))
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
