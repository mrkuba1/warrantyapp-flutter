import 'package:flutter/material.dart';

class UserSettings {
  Color color = Colors.orange;
  bool darkTheme = false;
  String language = 'EN';

  UserSettings({
    required this.color,
    required this.darkTheme,
    required this.language,
  });

  void setFabricSettings() {
    color = Colors.orange;
    darkTheme = false;
    language = 'EN';
  }

  void setColor(Color newcolor) {
    color = newcolor;
  }

  void setTheme(bool switchDark) {
    darkTheme = switchDark;
  }

  void setLanguage(String newlanguage) {
    language = newlanguage;
  }
}
