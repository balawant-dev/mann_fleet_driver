
import 'package:flutter/material.dart';

class AppTheme {

  /// Main Brand Color
  static const Color primaryColor =  Color(0xFF03045E);

  /// Light Theme
  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    primaryColor: primaryColor,

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    /// Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    /// Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),

    /// Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    /// Input Field Theme
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    /// Date Picker Theme
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: primaryColor,
      headerForegroundColor: Colors.white,
      todayForegroundColor: MaterialStatePropertyAll(primaryColor),
    ),

    /// Time Picker Theme
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteColor: primaryColor,
      hourMinuteTextColor: Colors.white,
      dialHandColor: primaryColor,
      dialBackgroundColor: Color(0xFFEDEDED),
    ),

    /// Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(primaryColor),
    ),

    /// Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(primaryColor),
      trackColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
    ),

    /// Floating Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),

    /// Tab Bar Theme
    tabBarTheme:  TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: primaryColor,
    ),

  );
}

// import 'package:flutter/material.dart';
//
// class AppTheme {
//
//   /// Main Brand Color
//   static const Color primaryColor = Color(0xFF050660);
//
//   /// Light Theme
//   static ThemeData lightTheme = ThemeData(
//
//     useMaterial3: true,
//
//     primaryColor: primaryColor,
//
//     scaffoldBackgroundColor: Colors.white,
//
//     appBarTheme: const AppBarTheme(
//       backgroundColor: primaryColor,
//       foregroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//     ),
//
//     /// Button Theme
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     ),
//
//     /// Text Button
//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: primaryColor,
//       ),
//     ),
//
//     /// Outlined Button
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         foregroundColor: primaryColor,
//         side: const BorderSide(color: primaryColor),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     ),
//
//     /// Input Field Theme
//     inputDecorationTheme: InputDecorationTheme(
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: primaryColor, width: 2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//
//     /// Date Picker Theme
//     datePickerTheme: const DatePickerThemeData(
//       backgroundColor: Colors.white,
//       headerBackgroundColor: primaryColor,
//       headerForegroundColor: Colors.white,
//       todayForegroundColor: MaterialStatePropertyAll(primaryColor),
//     ),
//
//     /// Time Picker Theme
//     timePickerTheme: const TimePickerThemeData(
//       backgroundColor: Colors.white,
//       hourMinuteColor: primaryColor,
//       hourMinuteTextColor: Colors.white,
//       dialHandColor: primaryColor,
//       dialBackgroundColor: Color(0xFFEDEDED),
//     ),
//
//     /// Checkbox Theme
//     checkboxTheme: CheckboxThemeData(
//       fillColor: MaterialStateProperty.all(primaryColor),
//     ),
//
//     /// Switch Theme
//     switchTheme: SwitchThemeData(
//       thumbColor: MaterialStateProperty.all(primaryColor),
//       trackColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
//     ),
//
//     /// Floating Button
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: primaryColor,
//     ),
//
//     /// Tab Bar Theme
//     tabBarTheme:  TabBarTheme(
//       labelColor: primaryColor,
//       unselectedLabelColor: Colors.grey,
//       indicatorColor: primaryColor,
//     ),
//
//   );
// }

