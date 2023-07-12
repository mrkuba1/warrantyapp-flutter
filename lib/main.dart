import 'package:flutter/material.dart';
import 'package:warrantyapp/Models/settings.dart';
import 'package:warrantyapp/Pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static UserSettings usersettings = UserSettings(
    color: Colors.orange,
    language: 'PL',
    isDarkTheme: false,
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(usersettings),
      theme: ThemeData(
        brightness: Brightness.dark,
        drawerTheme: const DrawerThemeData(),
        listTileTheme: ListTileThemeData(
          iconColor: usersettings.color,
          selectedColor: usersettings.color,
        ),
        expansionTileTheme: ExpansionTileThemeData(
            iconColor: usersettings.color, textColor: usersettings.color),
        primaryColor: usersettings.color,
        iconTheme: IconThemeData(color: usersettings.color),
        appBarTheme: AppBarTheme(backgroundColor: usersettings.color),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: usersettings.color),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: usersettings.color),
          ),
          labelStyle: TextStyle(
            color: usersettings.color,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return usersettings.color.withOpacity(0.5);
                } else {
                  return usersettings.color;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
