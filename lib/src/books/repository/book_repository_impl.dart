import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/authors/models/author.dart';
import 'package:library_system/src/authors/models/author_db_model.dart';
import 'package:library_system/src/books/models/book_db_model.dart';
import 'package:library_system/src/books/models/book.dart';
import 'package:library_system/src/books/repository/book_repository.dart';
import 'package:mongo_dart/mongo_dart.dart';

// ignore: public_member_api_docs
class BookRepositoryImpl implements BookRepository {
  /// UserRepositoryImpl
  BookRepositoryImpl();

  final MongoClient _mongoClient = MongoClient();

  @override
  Future<BookDbModel> addBook(Book book) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('books');

      final results = await collection.insertOne(
        book.toMap(),
      );

      return BookDbModel.fromMap(results.document!);
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<void> deleteBook(String id) {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('books');
      return collection.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<List<BookDbModel>> getAllBooks() {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('books');
      return collection.find().map(BookDbModel.fromMap).toList();
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<List<BookDbModel>> searchByAuthor(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('books');
      final results = await collection
          .find(
            where.eq(
              'author',
              name,
            ),
          )
          .toList();
      return results.map(BookDbModel.fromMap).toList();
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<List<BookDbModel>> searchByCategory(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('books');
      final results = await collection
          .find(
            where.eq(
              'category',
              name,
            ),
          )
          .toList();
      return results.map(BookDbModel.fromMap).toList();
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<List<BookDbModel>> searchByName(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('books');
      final results = await collection
          .find(
            where.eq(
              'headline',
              name,
            ),
          )
          .toList();
      return results.map(BookDbModel.fromMap).toList();
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<BookDbModel> updateBook(String id, Book book) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('books');

      final results = await collection.updateOne(
        where.eq('_id', ObjectId.fromHexString(id)),
        book.toJson(),
      );

      if (results.nModified == 1) {
        final updatedBook = await collection
            .findOne(where.eq('_id', ObjectId.fromHexString(id)));
        if (updatedBook != null) {
          return BookDbModel.fromMap(updatedBook);
        } else {
          throw Exception('Failed to retrieve updated book');
        }
      } else {
        throw Exception('Failed to update book');
      }
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<BookDbModel?> getBookById(String id) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('books');
      final results = await collection.findOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
      );
      if (results != null) {
        return BookDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception('Database not connected');
    }
  }
}
