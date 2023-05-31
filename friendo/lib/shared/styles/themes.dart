import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'color.dart';

ThemeData lightTheme() {
  return ThemeData(
    // control scaffold
    scaffoldBackgroundColor: Colors.white,

    // control appBar
    appBarTheme: const AppBarTheme(
      // control status bar
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),

      elevation: 0,
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),

      // control title
      titleSpacing: 20,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    // control floating action button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightThemeColor,
    ),

    // control body
    primaryColor: lightThemeColor,
    primarySwatch: lightThemeColor,

    // control text theme
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    )),

    // control bottom navbar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 20,
      selectedItemColor: lightThemeColor,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.black,
    ),
  );
}

ThemeData darkTheme() {
  var darkThemeColor = HexColor(dimDark);
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
      selectedItemColor: lightThemeColor,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      backgroundColor: darkThemeColor,
    ),
  );
}
