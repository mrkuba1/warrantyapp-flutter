import 'package:flutter/material.dart';
import 'package:warrantyapp/product_class.dart';

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
                Navigator.pop(context, updatedProduct);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
