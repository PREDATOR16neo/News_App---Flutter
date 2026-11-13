import 'package:material_ui/material_ui.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      surface: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class AppSpacing {
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
}

class AppDimensions {
  static const double articleImageHeight = 180;
}
