import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterProfilePage extends StatefulWidget {
  const RegisterProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterProfilePageState createState() => _RegisterProfilePageState();
}

class _RegisterProfilePageState extends State<RegisterProfilePage> {
  String name = '';
  String password = '';
  Color color = Colors.red;
  Color selectedColor = Colors.red;
  Future<void> saveDataToSecureStorage(
      String name, String password, Color selectedColor) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'name', value: name);
    await storage.write(key: 'password', value: password);
    await storage.write(key: 'color', value: selectedColor.value.toString());
  }

  Future<Map<String, String>?> readDataFromSecureStorage() async {
    const storage = FlutterSecureStorage();
    final name = await storage.read(key: 'name');
    final password = await storage.read(key: 'password');
    final colorValue = await storage.read(key: 'color');

    if (name != null && password != null && colorValue != null) {
      setState(() {
        selectedColor = Color(int.parse(colorValue));
      });
      return {'name': name, 'password': password};
    } else {
      return null;
    }
  }

  Widget buildColorPicker() => ColorPicker(
        pickerColor: color,
        onColorChanged: (color) => setState(() => this.color = color),
      );

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Pick your Color'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildColorPicker(),
              TextButton(
                child: const Text('Select'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          )));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Name'),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text('password'),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Set your own color'),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: () => pickColor(context),
                  child: const Text('Pick Color')),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  saveDataToSecureStorage(name, password, color);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Sukces'),
                        content: const Text('Konto zostało utworzone.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedColor = color;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Create Profile'),
              ),
            ]),
          ),
        ));
  }
}
