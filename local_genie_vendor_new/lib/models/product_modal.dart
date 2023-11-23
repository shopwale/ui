import 'package:flutter/foundation.dart';

class Product {
  String name;
  double price;
  String id;
  String mainImage;
  bool? favourite;
  double discount;
  String? discountType;
  bool canCancelOrder;
  String? sku;
  String offerTillDate;
  int deliveryInDays;
  List<String>? description;
  List<String>? tags;
  List<String>? images;
  List<String>? sizes;
  List<String>? colors;
  List<dynamic>? similar;

  // OrderStatusM? orderStatus;

  Product(
      {required this.name,
      required this.price,
      required this.id,
      // required this.orderStatus,
      this.images,
      this.deliveryInDays = 0,
      this.offerTillDate = "",
      this.mainImage = "",
      this.description,
      this.sizes,
      this.colors,
      this.sku = "",
      this.favourite = false,
      this.tags,
      this.canCancelOrder = true,
      this.discount = 0,
      this.discountType = "",
      this.similar}) {
    description ??= [];
    similar ??= [];
    colors ??= [];
    sizes ??= [];
    tags ??= [];
    images ??= [];
  }

  Product.fromJson(Map<String, dynamic> json)
      : this(
          id: json['_id'] ?? "",
          name: json['name'],
          price: double.parse((json['price'] ?? 0).toString()),
          discount: double.parse((json['discount'] ?? 0).toString()),
          discountType: json['discount_type'] ?? "",
          description: (json['description'] != null)
              ? json['description'].cast<String>()
              : [],
          images: [
            (json['main_image'] ?? "images/default_product.png"),
            ...((json['images'] != null) ? json['images'].cast<String>() : [])
          ],
          mainImage: json['main_image'] ?? "images/default_product.png",
          tags: json['tags'] != null ? json['tags'].cast<String>() : [],
          sizes: json['sizes'] != null ? json['sizes'].cast<String>() : [],
          colors: json['colors'] != null ? json['colors'].cast<String>() : [],
          deliveryInDays: json['delivery_in_days'] ?? 0,
          sku: json['sku'] ?? "",
          canCancelOrder: json['can_cancel_order'] ?? false,
          offerTillDate:
              json['offer_till_date'] ?? DateTime.now().toLocal().toString(),
          // similar: [],
          similar: (json['similar'] != null)
              ? json['similar'].map((a) => ProductSimilar.fromJson(a)).toList()
              : [],
        );

  @override
  String toString() {
    return 'Product(id: $id  images: $images mainImage: $mainImage price: $price favorite: $favourite dicount: $discount dicountType: $discountType sku: $sku tags: $tags deliveryInDays: $deliveryInDays offerTillDate: $offerTillDate canCancelOrder: $canCancelOrder similar: $similar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other);
  }

  @override
  int get hashCode => id.hashCode;
}

class ProductSimilar {
  String id;
  String mainImage;
  ProductSimilar({
    required this.id,
    this.mainImage = "",
  });

  ProductSimilar.fromJson(Map<String, dynamic> json)
      : this(
          id: json['_id'] ?? "",
          mainImage: json['main_image'] ?? "images/default_product.png",
        );
}

class ProductDetailsArgumentsI {
  final String id;
  final bool similar;

  ProductDetailsArgumentsI({this.id = "", this.similar = false});

  ProductDetailsArgumentsI.fromJson(Map<String, dynamic> json)
      : this(similar: json['similar'] ?? false, id: json['id'] ?? "");
  @override
  String toString() {
    return 'ProductDetailsArgumentsI(id: $id similar: $similar)';
  }
}

class ShortProduct {
  String id;
  String name;
  String mainImage;

  ShortProduct({required this.id, required this.name, this.mainImage = ""});

  ShortProduct.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'],
          id: json['_id'] ?? json['id'],
          mainImage: json['main_image'] ?? json['mainImage'] ?? "",
        );
}

class ProductPagination {
  final List<Product>? products;
  final int page;
  final int limit;
  final String errorMessage;
  ProductPagination({
    this.page = 0,
    this.limit = 20,
    this.products,
    this.errorMessage = "",
  });

  ProductPagination.initial()
      : products = [],
        page = 1,
        limit = 20,
        errorMessage = '';

  bool get refreshError =>
      errorMessage != '' && (products?.length ?? 0) <= limit;

  ProductPagination copyWith({
    List<Product>? products,
    int? page,
    String? errorMessage,
  }) {
    return ProductPagination(
      products: products ?? this.products,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'ProductPagination(products: $products, page: $page, errorMessage: $errorMessage)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProductPagination &&
        listEquals(o.products, products) &&
        o.page == page &&
        o.limit == limit &&
        o.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      products.hashCode ^
      limit.hashCode ^
      page.hashCode ^
      errorMessage.hashCode;
}
