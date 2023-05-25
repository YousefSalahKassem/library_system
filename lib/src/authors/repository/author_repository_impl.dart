import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/authors/models/author.dart';
import 'package:library_system/src/authors/models/author_db_model.dart';
import 'package:library_system/src/authors/repository/author_repository.dart';
import 'package:mongo_dart/mongo_dart.dart';

// ignore: public_member_api_docs
class AuthorRepositoryImpl implements AuthorRepository {
  /// UserRepositoryImpl
  AuthorRepositoryImpl();

  final MongoClient _mongoClient = MongoClient();

  @override
  Future<AuthorDbModel> addAuthor(Author author) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('author');

      final results = await collection.insertOne(
        author.toMap(),
      );

      return AuthorDbModel.fromMap(results.document!);
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<List<AuthorDbModel>> getAllAuthors() {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('author');
      return collection.find().map(AuthorDbModel.fromMap).toList();
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<AuthorDbModel?> getAuthorById(String id) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('author');
      final results = await collection.findOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
      );
      if (results != null) {
        return AuthorDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<AuthorDbModel?> getAuthorByName(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('author');
      final results = await collection.findOne(
        where.eq(
          'name',
          name,
        ),
      );
      if (results != null) {
        return AuthorDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<void> removeAuthor(String id) {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('author');
      return collection.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
    } else {
      throw Exception('Database not connected');
    }
  }
}
