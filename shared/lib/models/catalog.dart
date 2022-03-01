class CatalogItem {
  final String? name;
  final int id;
  final Unit unitOfMeasure;
  final int? categoryId;
  final String? categoryName;
  final int? subCategoryId;
  final String? subCategoryName;
  final double price;
  final List<String> tags;
  final Uri? iconUrl;

  CatalogItem({
    this.name,
    required this.id,
    this.unitOfMeasure = Unit.pieces,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.price = 0,
    this.tags = const [],
    this.iconUrl,
  });

  CatalogItem.fromJson(Map<String, dynamic> json)
      : this(
          id: json['itemId'],
          name: json['itemName'],
          categoryId: json['categoryId'],
          categoryName: json['categoryName'],
          subCategoryId: json['subCategoryId'],
          subCategoryName: json['subCategoryName'],
          price: (json['price'] as int).toDouble(),
          unitOfMeasure: asUnit(json['unitOfMeasure']),
          tags: json['tags'] ?? [],
          iconUrl: json['itemIconURL'] == null
              ? null
              : Uri.parse(json['itemIconURL']),
        );
}

enum Unit {
  kg,
  pieces,
}

extension UnitExtension on Unit {
  String asString() {
    switch (this) {
      case Unit.kg:
        return 'kg';
        break;
      case Unit.pieces:
        return 'pc';
        break;
      default:
        throw UnsupportedError('Unsupported unit.');
    }
  }

  double get incrementValue {
    switch (this) {
      case Unit.kg:
        return 0.25;
        break;
      case Unit.pieces:
        return 1;
        break;
      default:
        throw UnsupportedError('Unsupported unit.');
    }
  }
}

Unit asUnit(String value) {
  return Unit.values
      .firstWhere((e) => e.toString() == 'Unit.${value.toLowerCase()}');
}
