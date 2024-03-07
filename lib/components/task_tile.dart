import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';

class TaskTile extends StatelessWidget {
  final log = Logger(
    printer: PrettyPrinter(),
  );

  final String title;
  final String startDate;
  final String endDate;
  final String categoryName;

  TaskTile({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.categoryName,
  });

  String formatDateString(String inputDate) {
    final DateTime parsedDate = DateTime.parse(inputDate);

    final formattedDate = DateFormat('E, dd-MM-yyyy').format(parsedDate);

    return formattedDate;
  }

  String formatTimeString(String inputDate) {
    final DateTime parsedDate = DateTime.parse(inputDate);
    return DateFormat('HH:mm').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: TaskFlowColors.primaryLight,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: TaskFlowColors.primaryDark,
                      ),
                    ),
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.percent,
                    color: TaskFlowColors.primaryDark,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TaskFlowColors.lightGrey),
                    child: Icon(
                      Icons.more_vert,
                      color: TaskFlowColors.primaryDark,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TaskFlowColors.secondaryDark,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: TextStyle(
                            fontSize: 18,
                            color: TaskFlowColors.secondaryDark,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              size: 16,
                              color: TaskFlowColors.primaryDark,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDateString(startDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  formatTimeString(startDate),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: TaskFlowColors.secondaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: TaskFlowColors.secondaryDark,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: TextStyle(
                            fontSize: 18,
                            color: TaskFlowColors.secondaryDark,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              size: 16,
                              color: TaskFlowColors.primaryDark,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDateString(endDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  formatTimeString(endDate),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: TaskFlowColors.secondaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
