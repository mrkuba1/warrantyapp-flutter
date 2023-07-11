import 'package:flutter/material.dart';
import 'package:warrantyapp/Models/settings.dart';
import 'package:warrantyapp/Pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static UserSettings usersettings = UserSettings(
    color: Colors.orange,
    language: 'EN',
    darkTheme: false,
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(usersettings),
    );
  }
}
