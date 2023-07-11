import 'package:flutter/material.dart';
import 'package:warrantyapp/Models/product.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController purchaseDateController;
  late TextEditingController amountController;
  late String selectedCurrency;
  late TextEditingController storeController;
  late TextEditingController warrantyLengthController;
  late bool kontrola;
  final List<String> currencyOptions = ['USD', 'EUR', 'GBP', 'PLN'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    typeController = TextEditingController(text: widget.product.type);
    purchaseDateController = TextEditingController(
        text:
            '${widget.product.purchaseDate.year}-${widget.product.purchaseDate.month.toString().padLeft(2, '0')}-${widget.product.purchaseDate.day.toString().padLeft(2, '0')}');
    amountController =
        TextEditingController(text: widget.product.amount.toString());
    selectedCurrency = widget.product.currency;
    storeController = TextEditingController(text: widget.product.store);
    warrantyLengthController =
        TextEditingController(text: widget.product.lengthWarranty.toString());
    kontrola = widget.product.lengthWarranty != 2;

    _loadProductData(); // Load product data before editing
  }

  Future<void> _loadProductData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/products.json');
    List<Product> products = await _loadProductsFromFile(file);

    int index = products.indexWhere((p) => p.id == widget.product.id);
    if (index != -1) {
      Product selectedProduct = products[index];
      setState(() {
        nameController.text = selectedProduct.name;
        typeController.text = selectedProduct.type;
        purchaseDateController.text =
            '${selectedProduct.purchaseDate.year}-${selectedProduct.purchaseDate.month.toString().padLeft(2, '0')}-${selectedProduct.purchaseDate.day.toString().padLeft(2, '0')}';
        amountController.text = selectedProduct.amount.toString();
        selectedCurrency = selectedProduct.currency;
        storeController.text = selectedProduct.store;
        warrantyLengthController.text =
            selectedProduct.lengthWarranty.toString();
        kontrola = selectedProduct.lengthWarranty != 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
              },
            ),
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

                Product updatedProduct = Product(
                  id: widget.product.id,
                  name: name,
                  type: type,
                  purchaseDate: purchaseDate,
                  amount: amount,
                  currency: selectedCurrency,
                  store: store,
                  lengthWarranty: lengthWarranty,
                );

                _saveProductToFile(
                    updatedProduct); // Save the updated product to file
                Navigator.pop(context, updatedProduct);
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
    int index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
    }

    final List<Map<String, dynamic>> productList =
        products.map((p) => p.toJson()).toList();

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
