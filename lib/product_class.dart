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

  @override
  String toString() {
    return 'Product(id: $id, name: $name, type: $type, '
        'purchaseDate: $purchaseDate, amount: $amount$currency, '
        'store: $store)';
  }
}
