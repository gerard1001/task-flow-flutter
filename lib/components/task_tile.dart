import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
import 'package:task_flow_flutter/utils/stacked_widget.dart';

class TaskTile extends StatelessWidget {
  final log = Logger(
    printer: PrettyPrinter(),
  );

  final String title;
  final String startDate;
  final String endDate;
  final String categoryName;
  final String progress;
  final List userImages;

  TaskTile({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.categoryName,
    required this.progress,
    required this.userImages,
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

  void showUsers() {
    log.w(userImages.map((e) => e['picture']).toList());
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
                  CircularPercentIndicator(
                    radius: 23.0,
                    lineWidth: 4.0,
                    percent: 0.75,
                    center: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 0),
                      child: Text(
                        '75%',
                        style: TextStyle(
                          fontSize: 16,
                          color: TaskFlowColors.primaryDark,
                        ),
                      ),
                    ),
                    backgroundColor: TaskFlowColors.lightTeal,
                    progressColor: TaskFlowColors.teal,
                    animateFromLastPercent: true,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TaskFlowColors.lightGrey),
                    child: GestureDetector(
                      onTap: showUsers,
                      child: Icon(
                        Icons.more_vert,
                        color: TaskFlowColors.primaryDark,
                        size: 20,
                      ),
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
                          'To',
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
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: buildStackedImages(),
                ),
                Row(
                  children: [
                    Text(
                      'Progress: ',
                      style: TextStyle(
                        fontSize: 16,
                        color: TaskFlowColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 2,
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        color: TaskFlowColors.transparentBrown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        progress,
                        style: TextStyle(
                          fontSize: 14,
                          color: TaskFlowColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStackedImages({
    TextDirection direction = TextDirection.LTR,
  }) {
    const double size = 40;
    const double xShift = 10;
    final urlImages = userImages.map((image) => image['picture']).toList();

    final items = urlImages.map((urlImage) => buildImage(urlImage)).toList();

    return StackedWidgets(
      direction: direction,
      items: items,
      size: size,
      xShift: xShift,
    );
  }

  Widget buildImage(String urlImage) {
    const double borderSize = 2;

    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(borderSize),
        color: TaskFlowColors.primaryLight,
        child: ClipOval(
          child: Image.network(
            urlImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
