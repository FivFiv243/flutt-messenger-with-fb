import 'package:flutter/material.dart';

ThemeData LightThemeMod =  ThemeData(
  useMaterial3: true,
  primaryTextTheme: const TextTheme(bodySmall: TextStyle(fontFamily: 'Open Sans', fontSize: 16, color:Colors.black)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(147, 0, 0, 0),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color:Colors.black87,
      ),
      bodyLarge: TextStyle(
        color:Colors.white70,
      ),
      bodySmall: TextStyle(
        //Text 3
      ),
    ),
    dialogBackgroundColor: Color.fromRGBO(12, 12, 12, 0.536), // I'm using this color for bordering TextFild
    iconTheme: IconThemeData(color: Color.fromARGB(174, 0, 0, 0)),
  scaffoldBackgroundColor: Color.fromRGBO(189, 212, 205, 1),
  colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 52, 175, 156)),
  dividerColor: Colors.grey,
   appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 52, 175, 156),
   ),
  indicatorColor: Color.fromRGBO(32, 58, 50, 0.635), // your message 
  secondaryHeaderColor:Color.fromRGBO(22, 36, 29, 0.612), // opposit message
);

ThemeData DarkThemeModes = ThemeData(
  adaptations: [],
  useMaterial3: true,
  primaryTextTheme: const TextTheme(bodySmall: TextStyle(fontFamily: 'Open Sans', fontSize: 16, color:Colors.white)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(147, 0, 0, 0),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color:Colors.white70,
      ),
      bodyLarge: TextStyle(
        color:Colors.black87,
      ),
      bodySmall: TextStyle(
        //Text 3
      ),
    ),
     dialogBackgroundColor: Color.fromRGBO(12, 12, 12, 0.536), // I'm using this color for bordering TextFild
    iconTheme: IconThemeData(color: Colors.white54),
  scaffoldBackgroundColor: Color.fromRGBO(25, 29, 28, 0.878),
  colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 1, 19, 17)),
  dividerColor: Colors.grey,
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 1, 19, 17),
  ),
  indicatorColor: Color.fromRGBO(32, 58, 50, 0.635), // your message 
  secondaryHeaderColor:Color.fromRGBO(22, 36, 29, 0.612), // opposit message
);
