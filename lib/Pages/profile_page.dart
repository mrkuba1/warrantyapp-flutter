import 'package:flutter/material.dart';
import 'package:warrantyapp/Pages/addproduct_page.dart';
import 'package:warrantyapp/product_class.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage(this.username, {super.key});

  @override
  // ignore: library_private_types_in_public_api
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
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
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
            child: Card(
              child: ExpansionTile(
                title: Text(product.name),
                subtitle: Text(
                    'Type: ${product.type}\nAmount: ${product.currency} ${product.amount.toStringAsFixed(2)}'),
                trailing: const Icon(Icons.more_vert),
                children: [
                  ListTile(
                    title: Text(
                        'Purchase Date: ${product.purchaseDate.year}-${product.purchaseDate.month.toString().padLeft(2, '0')}-${product.purchaseDate.day.toString().padLeft(2, '0')}'),
                    subtitle: Text(
                        'Store: ${product.store}\nWarranty Length: ${product.lengthWarranty}'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
