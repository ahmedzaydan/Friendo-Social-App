import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,

    // control scaffold
    scaffoldBackgroundColor: Colors.white,

    // control appBar
    appBarTheme: AppBarTheme(
      // control status bar
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: lightThemeColor,
        statusBarIconBrightness: Brightness.light,
      ),

      elevation: 0,
      backgroundColor: lightThemeColor,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),

      // control title
      titleSpacing: 20,
      titleTextStyle: TextStyle(
        color: lightThemeColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    // control floating action button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightThemePrimaryColor,
    ),

    // control body
    primaryColor: lightThemePrimaryColor,
    primarySwatch: lightThemePrimaryColor,

    // control text theme
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18,
        fontFamily: "Jannah",
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.3,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontFamily: "Jannah",
        fontWeight: FontWeight.w100,
        color: Colors.black,
      ),
    ),

    // control bottom navbar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      selectedItemColor: lightThemePrimaryColor,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.black,
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    // control scaffold
    scaffoldBackgroundColor: darkThemeColor,

    // control appBar
    appBarTheme: AppBarTheme(
      // control status bar
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: darkThemeColor,
        statusBarIconBrightness: Brightness.light,
      ),

      elevation: 0,
      backgroundColor: darkThemeColor,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),

      // control title
      titleSpacing: 20,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    // control floating action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkThemeColor,
    ),

    // control body
    primaryColor: darkThemeColor,
    primarySwatch: Colors.pink,

    // control text theme
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    )),

    // control bottom navbar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 20,
      selectedItemColor: lightThemePrimaryColor,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      backgroundColor: darkThemeColor,
    ),
  );
}
