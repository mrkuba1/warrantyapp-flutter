import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:warrantyapp/Models/product.dart';
import 'package:warrantyapp/Models/settings.dart';

class AddProductPage extends StatefulWidget {
  final UserSettings usersettings;

  const AddProductPage(this.usersettings, {Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCurrency = 'PLN';
  final TextEditingController storeController = TextEditingController();
  final TextEditingController warrantyLengthController =
      TextEditingController();
  bool kontrola = false;
  List<String> currencyOptions = ['USD', 'EUR', 'GBP', 'PLN'];

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
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextField(
                controller: purchaseDateController,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.calendar_today,
                      color: widget.usersettings.color,
                    ),
                    labelText: "Enter Date"),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: widget.usersettings.color,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (selectedDate != null) {
                    final formattedDate =
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                    purchaseDateController.text = formattedDate;
                  }
                }),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount ($selectedCurrency)',
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCurrency = newValue!;
                    });
                  },
                  items: currencyOptions.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                ),
              ],
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
                int lengthWarranty = kontrola
                    ? int.tryParse(warrantyLengthController.text) ?? 0
                    : 2;

                Product newProduct = Product(
                  id: DateTime.now().toString(),
                  name: name,
                  type: type,
                  purchaseDate: purchaseDate,
                  amount: amount,
                  currency: selectedCurrency,
                  store: store,
                  lengthWarranty: lengthWarranty,
                );
                _saveProductToFile(newProduct);
                Navigator.pop(context, newProduct);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProductToFile(Product product) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/products.json');

    List<Product> products = await _loadProductsFromFile(file);
    products.add(product);

    final List<Map<String, dynamic>> productList =
        products.map((Product p) => p.toJson()).toList();

    await file.writeAsString(jsonEncode(productList));
  }

  Future<List<Product>> _loadProductsFromFile(File file) async {
    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((dynamic json) => Product.fromJson(json)).toList();
    }
    return [];
  }
}
