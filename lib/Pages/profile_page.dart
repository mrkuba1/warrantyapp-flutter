import 'package:flutter/material.dart';
import 'package:warrantyapp/Models/settings.dart';
import 'package:warrantyapp/Pages/addproduct_page.dart';
import 'package:warrantyapp/Pages/editproduct_page.dart';
import 'package:warrantyapp/Models/product.dart';
import 'package:warrantyapp/Pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  final UserSettings userSettings;

  const ProfilePage(this.userSettings, {super.key});

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
    if (widget.userSettings.language == 'EN') {
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
    } else if (widget.userSettings.language == 'PL') {
      titleText = 'Przedmioty';
      nameText = 'WarrantyApp';
      homeText = 'Strona Główna';
      settingsText = 'Ustawienia';
      aboutText = 'O mas';
      typeText = 'Typ';
      amountText = 'Wartość';
      purchaseDateText = 'Data zakupu';
      storeText = 'Sklep';
      expirationDateText = 'Data wygaśnięcia';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('WarrantyApp'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(widget.userSettings),
                  ),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(aboutText),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
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
              builder: (context) => const AddProductPage(),
            ),
          ).then((newProduct) {
            if (newProduct != null) {
              setState(() {
                products.add(newProduct);
              });
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
          Color textColor = difference > 30 ? Colors.black : Colors.red;
          return Dismissible(
            key: Key(product.id),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              setState(() {
                products.removeAt(index);
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
                  title: Text(product.name, style: TextStyle(color: textColor)),
                  subtitle: Text(
                      '$typeText: ${product.type}\n$amountText: ${product.currency} ${product.amount.toStringAsFixed(2)}'),
                  trailing: const Icon(Icons.more_vert),
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
        builder: (context) => EditProductPage(product: product),
      ),
    ).then((updatedProduct) {
      if (updatedProduct != null) {
        setState(() {
          int productIndex = products.indexOf(product);
          if (productIndex != -1) {
            products[productIndex] = updatedProduct;
          }
        });
      }
    });
  }
}
