import 'package:library_system/src/category/models/category_db_model.dart';
import 'package:library_system/src/category/models/category.dart';
import 'package:library_system/src/category/repository/category_repository_impl.dart';
import 'package:library_system/src/category/service/category_service.dart';

// ignore: public_member_api_docs
class CategoryServiceImpl extends CategoryService {
  
  // ignore: public_member_api_docs
  CategoryServiceImpl();

  final CategoryRepositoryImpl _categoryRepository = CategoryRepositoryImpl();

  @override
  Future<CategoryDbModel> addCategory(Category category) {
    try {
      return _categoryRepository.addCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryDbModel>> getAllCategories() {
    try {
      return _categoryRepository.getAllCategories();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CategoryDbModel?> getCategoryById(String id) {
    try {
      return _categoryRepository.getCategoryById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeCategory(String id) {
    try {
      return _categoryRepository.removeCategory(id);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<CategoryDbModel?> getCategoryByName(String name) {
    try {
      return _categoryRepository.getCategoryByName(name);
    } catch (e) {
      rethrow;
    }
  }

}
