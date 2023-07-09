import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:warrantyapp/Pages/profile_page.dart';
import 'package:warrantyapp/Pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  String password = '';

  final storage = const FlutterSecureStorage();

  Future<bool> authenticateUser(String name, String password) async {
    // Tutaj dodaj logikę weryfikacji poprawności danych logowania.
    // Możesz sprawdzić, czy podane dane są zgodne z tym, co jest przechowywane w bazie danych lub innym źródle danych.

    // Przykładowo, można odczytać przechowywane dane logowania z bezpiecznego składowiska i porównać z podanymi danymi.
    final storedName = await storage.read(key: 'name');
    final storedPassword = await storage.read(key: 'password');

    if (name == storedName && password == storedPassword) {
      return true; // Logowanie udane
    } else {
      return false; // Logowanie nieudane
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to the Warranty App',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nick',
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 1),
                    ElevatedButton(
                      onPressed: () async {
                        final isAuthenticated =
                            await authenticateUser(name, password);
                        if (isAuthenticated) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(name),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Authentication Failed'),
                                content: const Text(
                                    'Invalid credentials. Please try again.'),
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
                        }
                      },
                      child: const Text('Log'),
                    ),
                    const SizedBox(width: 13),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterProfilePage(),
                          ),
                        );
                      },
                      child: const Text('Create Profile'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
