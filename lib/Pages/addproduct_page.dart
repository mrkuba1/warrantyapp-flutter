import 'package:flutter/material.dart';

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

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController storeController = TextEditingController();
  final TextEditingController warrantyLengthController =
      TextEditingController();
  bool kontrola = false;

  @override
  void initState() {
    super.initState();
    warrantyLengthController.text = '2';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextField(
                controller: purchaseDateController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    final formattedDate =
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                    purchaseDateController.text = formattedDate;
                  }
                }),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: storeController,
              decoration: const InputDecoration(labelText: 'Store'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: warrantyLengthController,
                    enabled: kontrola,
                    decoration:
                        const InputDecoration(labelText: 'Warranty Length'),
                  ),
                ),
                Switch(
                  value: kontrola,
                  onChanged: (bool value) {
                    setState(() {
                      kontrola = value;
                      if (value) {
                        warrantyLengthController.text = '';
                      } else {
                        warrantyLengthController.text = '2';
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String type = typeController.text;
                DateTime purchaseDate =
                    DateTime.parse(purchaseDateController.text);
                double amount = double.parse(amountController.text);
                String store = storeController.text;
                double length_warranty = kontrola
                    ? double.tryParse(warrantyLengthController.text) ?? 0
                    : 2;

                Product newProduct = Product(
                  id: DateTime.now().toString(),
                  name: name,
                  type: type,
                  purchaseDate: purchaseDate,
                  amount: amount,
                  store: store,
                  lenght_warranty: length_warranty,
                );

                // Return the new product to the profile page
                Navigator.pop(context, newProduct);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
