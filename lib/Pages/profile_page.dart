import 'package:flutter/material.dart';
import 'package:warrantyapp/Models/settings.dart';
import 'package:warrantyapp/Pages/about_page.dart';
import 'package:warrantyapp/Pages/addproduct_page.dart';
import 'package:warrantyapp/Pages/editproduct_page.dart';
import 'package:warrantyapp/Models/product.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:warrantyapp/Pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  final UserSettings usersettings;

  const ProfilePage(this.usersettings, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Product> products = [];
  String titleText = 'Items',
      nameText = 'WarrantyApp',
      homeText = 'Home',
      settingsText = 'Settings',
      aboutText = 'About',
      typeText = 'Type',
      amountText = 'Amount',
      purchaseDateText = 'Purchase Date',
      storeText = 'Store',
      expirationDateText = 'Expiration Date';

  @override
  void initState() {
    super.initState();
    if (widget.usersettings.language == 'EN') {
      titleText = 'Items';
      nameText = 'WarrantyApp';
      homeText = 'Home';
      settingsText = 'Settings';
      aboutText = 'About';
      typeText = 'Type';
      amountText = 'Amount';
      purchaseDateText = 'Purchase Date';
      storeText = 'Store';
      expirationDateText = 'Expiration Date';
    } else if (widget.usersettings.language == 'PL') {
      titleText = 'Przedmioty';
      nameText = 'WarrantyApp';
      homeText = 'Strona Główna';
      settingsText = 'Ustawienia';
      aboutText = 'O nas';
      typeText = 'Typ';
      amountText = 'Wartość';
      purchaseDateText = 'Data zakupu';
      storeText = 'Sklep';
      expirationDateText = 'Data wygaśnięcia';
    }

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/products.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      setState(() {
        products =
            jsonList.map((dynamic json) => Product.fromJson(json)).toList();
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigate to the home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(widget.usersettings),
        ),
      );
    } else if (index == 1) {
      // Navigate to the settings page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(widget.usersettings),
        ),
      );
    } else if (index == 2) {
      // Navigate to the about page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutPage()),
      );
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: widget.usersettings.color),
              child: const Text('WarrantyApp'),
            ),
            ListTile(
              title: Text(homeText),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(settingsText),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(aboutText),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                const AboutPage();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(widget.usersettings),
            ),
          ).then((newProduct) {
            if (newProduct != null) {
              setState(() {
                products.add(newProduct);
              });
              _saveProducts();
            }
          });
        },
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          var expirationDate = product.purchaseDate
              .add(Duration(days: product.lengthWarranty * 365));
          var difference = expirationDate.difference(DateTime.now()).inDays;
          Color textColor = difference > 30 ? Colors.white : Colors.red;
          return Dismissible(
            key: Key(product.id),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              setState(() {
                products.removeAt(index);
                _saveProducts();
              });
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(Icons.delete),
            ),
            child: GestureDetector(
              onLongPress: () {
                _editProduct(product);
              },
              child: Card(
                child: ExpansionTile(
                  title: Text(
                    product.name,
                    style: TextStyle(color: textColor),
                  ),
                  subtitle: Text(
                      '$typeText: ${product.type}\n$amountText: ${product.currency} ${product.amount.toStringAsFixed(2)}'),
                  trailing: const Icon(
                    Icons.more_vert,
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        '$purchaseDateText: ${product.purchaseDate.year}-${product.purchaseDate.month.toString().padLeft(2, '0')}-${product.purchaseDate.day.toString().padLeft(2, '0')}',
                      ),
                      subtitle: Text(
                        '$storeText: ${product.store}\n$expirationDateText: ${expirationDate.year}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _editProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(
          widget.usersettings,
          product: product,
        ),
      ),
    ).then((updatedProduct) {
      if (updatedProduct != null) {
        setState(() {
          int productIndex = products.indexOf(product);
          if (productIndex != -1) {
            products[productIndex] = updatedProduct;
          }
          _saveProducts();
        });
      }
    });
  }

  Future<void> _saveProducts() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/products.json');
    final List<Map<String, dynamic>> productList =
        products.map((p) => p.toJson()).toList();
    await file.writeAsString(jsonEncode(productList));
  }
}
