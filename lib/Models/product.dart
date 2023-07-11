class Product {
  final String id;
  final String name;
  final String type;
  final DateTime purchaseDate;
  final double amount;
  final String currency;
  final String store;
  final int lengthWarranty;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.purchaseDate,
    required this.amount,
    required this.currency,
    required this.store,
    required this.lengthWarranty,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'purchaseDate': purchaseDate.toIso8601String(),
      'amount': amount,
      'currency': currency,
      'store': store,
      'lengthWarranty': lengthWarranty,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      amount: json['amount'],
      currency: json['currency'],
      store: json['store'],
      lengthWarranty: json['lengthWarranty'],
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, type: $type, '
        'purchaseDate: $purchaseDate, amount: $amount$currency, '
        'store: $store)';
  }
}
