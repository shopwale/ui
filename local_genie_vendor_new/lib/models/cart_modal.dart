class Cart {
  String id;
  ShortProductCart product;
  int quantity;
  String color;
  String size;
  bool similar;

  Cart({
    required this.product,
    this.id = "",
    this.color = "",
    this.size = "",
    this.quantity = 0,
    this.similar = false,
  });

  Cart.fromJson(Map<String, dynamic> json)
      : this(
          product: ShortProductCart.fromJson(json['product']),
          id: json['_id'] ?? "",
          color:
              json['color'] != "" && json['color'] != null ? json['color'] : "",
          size: json['size'] ?? "",
          quantity: json['quantity'] ?? 0,
          similar: json['similar'] ?? false,
        );

  get(String field) {
    return (toJson())[field];
  }

  Cart set(String field, dynamic value) => Cart(
        product: field == "product" ? value : product,
        id: field == "id" ? value : id,
        color: field == "color" ? value : color,
        size: field == "size" ? value : size,
        quantity: field == "quantity" ? value : quantity,
        similar: field == "similar" ? value : similar,
      );

  Map<String, dynamic> toJson() => {
        'product': product,
        '_id': id,
        'color': color,
        'size': size,
        'quantity': quantity,
        'similar': similar,
      };

  @override
  String toString() {
    return 'Cart(id: $id product: $product quantity: $quantity size: $size color: $color similar: $similar)';
  }

  @override
  bool operator ==(covariant Cart other) {
    return identical(this, other);
  }

  @override
  int get hashCode => id.hashCode ^ product.hashCode;
}

class ShortProductCart {
  String id;
  String name;
  String mainImage;
  double price;
  double discount;
  String discountType;
  String offerTillDate;
  bool canCancelOrder;

  List<String>? sizes;
  List<String>? colors;

  ShortProductCart(
      {required this.id,
      required this.name,
      required this.price,
      this.discountType = "",
      this.discount = 0,
      this.colors,
      this.sizes,
      this.mainImage = "",
      this.offerTillDate = "",
      this.canCancelOrder = true}) {
    colors ??= [];
    sizes ??= [];
  }

  ShortProductCart.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'],
          price: double.parse(json['price'].toString()),
          discount: double.parse(json['discount'].toString()),
          discountType: json['discount_type'] ?? "",
          id: json['_id'] ?? json['id'],
          mainImage: json['main_image'] ?? "images/default_product.png",
          colors: json['colors'] != null ? json['colors'].cast<String>() : [],
          sizes: json['sizes'] != null ? json['sizes'].cast<String>() : [],
          offerTillDate: json['offer_till_date'] ?? "",
          canCancelOrder: json['can_cancel_order'] ?? false,
        );

  Map<String, dynamic> toJson() => {
        'name': name,
        '_id': id,
        'price': price,
        'discount': discount,
        'discountType': discountType,
        'mainImage': mainImage,
        'colors': colors,
        'sizes': sizes,
        'offerTillDate': offerTillDate,
        'canCancelOrder': canCancelOrder,
      };

  get(String field) {
    return (toJson())[field];
  }

  @override
  String toString() {
    return 'ShortProductCart(id: $id name: $name price: $price discount: $discount discountType: $discountType mainImage: $mainImage colors: $colors sizes: $sizes offerTillDate: $offerTillDate canCancelOrder: $canCancelOrder)';
  }
}
