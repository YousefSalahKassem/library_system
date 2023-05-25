import 'package:library_system/src/category/models/category.dart';
import 'package:library_system/src/category/models/category_db_model.dart';

abstract class CategoryRepository {
  
  Future<List<CategoryDbModel>> getAllCategories();

  Future<void> removeCategory(String id);

  Future<CategoryDbModel?> getCategoryById(String id);

  Future<CategoryDbModel> addCategory(Category category);

  Future<CategoryDbModel?> getCategoryByName(String name);

}