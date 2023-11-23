class OrderStatusM {
  String name;
  int id;

  OrderStatusM({
    required this.name,
    this.id = 0,
  });

  OrderStatusM.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'],
          id: json['id'] ?? 0,
        );
  @override
  String toString() {
    return 'OrderStatus(id: $id name: $name)';
  }
}
