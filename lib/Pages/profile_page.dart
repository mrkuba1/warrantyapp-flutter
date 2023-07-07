import 'package:flutter/material.dart';
import 'package:warrantyapp/Pages/addproduct_page.dart';

class Product {
  final String id;
  final String name;
  final String type;
  final DateTime purchaseDate;
  final double amount;
  final String store;
  final double lenght_warranty;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.purchaseDate,
    required this.amount,
    required this.store,
    required this.lenght_warranty,
  });
}

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage(this.username);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductPage(),
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
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Type: ${product.type}\nStore: ${product.store}'),
            trailing: Text('Amount: \$${product.amount.toStringAsFixed(2)}'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
