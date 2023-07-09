import 'package:flutter/material.dart';
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

  Future<void> saveDataToSecureStorage(String name, String password) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'name', value: name);
    await storage.write(key: 'password', value: password);
  }

  Future<Map<String, String>?> readDataFromSecureStorage() async {
    const storage = FlutterSecureStorage();
    final name = await storage.read(key: 'name');
    final password = await storage.read(key: 'password');

    if (name != null && password != null) {
      return {'name': name, 'password': password};
    } else {
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
                saveDataToSecureStorage(name, password);
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
