import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RegisterProfilePage extends StatefulWidget {
  @override
  _RegisterProfilePageState createState() => _RegisterProfilePageState();
}

class _RegisterProfilePageState extends State<RegisterProfilePage> {
  String name = '';
  String password = '';

  Future<void> saveDataToFile(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/profile_data.txt');
    await file.writeAsString(data);
  }

  Future<List<String>?> readDataFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/profile_data.txt');
      final contents = await file.readAsString();
      final lines = contents.split('\n');
      return lines;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ElevatedButton(
              onPressed: () {
                final data = 'Login: $name\nPassword: $password';
                saveDataToFile(data);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sukces'),
                      content: const Text('Konto zostało utworzone.'),
                      actions: [
                        TextButton(
                          onPressed: () {
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
          ],
        ),
      ),
    );
  }
}
