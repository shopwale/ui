import 'package:shared/models/lib/category.dart';

/// Service that fetches the list of provider categories.
abstract class CategoryService {
  Future<List<Category>> getAll();
}

class FakeCategoryService extends CategoryService {
  List<Category> _categories = [
    Category(id: 1, name: 'Grocery'),
    Category(id: 2, name: 'Saloon'),
    Category(id: 3, name: 'Meat'),
  ];

  @override
  Future<List<Category>> getAll() => Future.value(_categories);
}
