import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/category/models/category.dart';
import 'package:library_system/src/category/models/category_db_model.dart';
import 'package:library_system/src/category/repository/category_repository.dart';
import 'package:mongo_dart/mongo_dart.dart';

// ignore: public_member_api_docs
class CategoryRepositoryImpl implements CategoryRepository {
  /// UserRepositoryImpl
  CategoryRepositoryImpl();

  final MongoClient _mongoClient = MongoClient();

  @override
  Future<CategoryDbModel> addCategory(Category category) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('category');

      final results = await collection.insertOne(
        category.toMap(),
      );
      print(category.toMap());
      print(results.document);
      return CategoryDbModel.fromMap(results.document!);
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<List<CategoryDbModel>> getAllCategories() {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('category');
      return collection.find().map(CategoryDbModel.fromMap).toList();
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<CategoryDbModel?> getCategoryById(String id) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('category');
      final results = await collection.findOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
      );
      if (results != null) {
        return CategoryDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<void> removeCategory(String id) {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('category');
      return collection.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
    } else {
      throw Exception('Database not connected');
    }
  }
  
  @override
  Future<CategoryDbModel?> getCategoryByName(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('category');
      final results = await collection.findOne(
        where.eq(
          'title',
          name,
        ),
      );
      if (results != null) {
        return CategoryDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception('Database not connected');
    }
  }
}
