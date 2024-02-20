// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

abstract class TaskFlowColors {
  static Color primaryLight = const Color(0xFFF8F8F8);
  static Color secondaryLight = const Color(0xFFEAEAEA);
  static Color primaryDark = const Color(0xFF4C4C4C);
  static Color secondaryDark = const Color(0xFF777777);
  static Color grey = const Color(0xFFC4C4C4);
  static Color lightGrey = const Color(0xFFD9D9D9);
  static Color teal = const Color(0xFF00A399);
  static Color lightTeal = Color.fromARGB(100, 0, 163, 152);
  static Color brown = Color(0xFFCD9349);
  static Color transparentBrown = Color.fromARGB(122, 201, 113, 13);
}

abstract class TaskFlowStyles {
  static const TextStyle largeBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );
  static const TextStyle large = TextStyle(
    fontSize: 30,
  );
  static const TextStyle mediumBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );
  static const TextStyle medium = TextStyle(
    fontSize: 24,
  );
  static const TextStyle smallBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  static const TextStyle small = TextStyle(
    fontSize: 18,
  );
  static const smallFontSize = 18;
  static const mediumFontSize = 24;
  static const largeFontSize = 30;
}

abstract class TaskFlowTheme {
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    textTheme: const TextTheme(
      displayLarge: TaskFlowStyles.large,
      displayMedium: TaskFlowStyles.medium,
      displaySmall: TaskFlowStyles.small,
    ),
    fontFamily: 'InriaSans',
  );
}
