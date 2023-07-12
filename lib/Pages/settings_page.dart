import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:warrantyapp/Models/settings.dart';

class SettingsPage extends StatefulWidget {
  final UserSettings userSettings;
  const SettingsPage(this.userSettings, {super.key});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color selectedColor = Colors.blue;
  String selectedLanguage = 'EN';
  bool isDarkThemeEnabled = false;
  @override
  void initState() {
    super.initState();
    selectedColor = widget.userSettings.color;
    selectedLanguage = widget.userSettings.language;
    isDarkThemeEnabled = widget.userSettings.isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Color'),
            subtitle: Text('Selected color: ${selectedColor.toString()}'),
            onTap: () {
              _showColorPickerDialog();
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text('Selected language: $selectedLanguage'),
            onTap: () {
              _showLanguagePickerDialog();
            },
          ),
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: isDarkThemeEnabled,
            onChanged: (value) {
              setState(() {
                isDarkThemeEnabled = value;
                // Apply the selected theme
                _applyTheme();
              });
            },
          ),
          ListTile(
            title: const Text('Reset to Factory Settings'),
            onTap: () {
              _showResetConfirmationDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
                widget.userSettings.setColor(color);
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLanguagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    setState(() {
                      selectedLanguage = 'English';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Polish'),
                  onTap: () {
                    setState(() {
                      selectedLanguage = 'Polish';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _applyTheme() {
    ThemeData themeData =
        isDarkThemeEnabled ? ThemeData.dark() : ThemeData.light();

    // Apply the theme to the app
    // For example: MyApp.setThemeData(themeData);
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset to Factory Settings'),
          content: const Text(
              'Are you sure you want to reset all settings to factory defaults?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                _resetToFactorySettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetToFactorySettings() {
    setState(() {
      selectedColor = Colors.blue;
      selectedLanguage = 'English';
      isDarkThemeEnabled = false;
    });
    widget.userSettings.setFabricSettings();
    _applyTheme();
  }
}
