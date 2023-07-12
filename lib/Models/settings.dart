import 'package:flutter/material.dart';

class UserSettings {
  Color color = Colors.orange;
  bool isDarkTheme = false;
  String language = 'PL';

  UserSettings({
    required this.color,
    required this.isDarkTheme,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'isDarkTheme': isDarkTheme,
      'language': language,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      color: json['color'],
      isDarkTheme: json['isDarkTheme'],
      language: json['language'],
    );
  }

  void setFabricSettings() {
    color = Colors.orange;
    isDarkTheme = false;
    language = 'PL';
  }

  void setColor(Color newcolor) {
    color = newcolor;
  }

  void setTheme(bool switchDark) {
    isDarkTheme = switchDark;
  }

  void setLanguage(String newlanguage) {
    language = newlanguage;
  }
}
