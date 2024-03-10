import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StackedWidgets extends StatelessWidget {
  final List<Widget> items;
  final TextDirection direction;
  final double size;
  final double xShift;

  const StackedWidgets({
    super.key,
    required this.items,
    this.direction = TextDirection.LTR,
    this.size = 100,
    this.xShift = 20,
  });

  @override
  Widget build(BuildContext context) {
    final allItems = items
        .asMap()
        .map((index, item) {
          final left = size - xShift;

          final value = Container(
            width: size,
            height: size,
            margin: EdgeInsets.only(left: left * index),
            child: item,
          );

          return MapEntry(index, value);
        })
        .values
        .toList();

    return Stack(
      children: direction == TextDirection.LTR
          ? allItems.reversed.toList()
          : allItems,
    );
  }
}
