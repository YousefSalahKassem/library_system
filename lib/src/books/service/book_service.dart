import 'package:library_system/src/books/models/book.dart';
import 'package:library_system/src/books/models/book_db_model.dart';

abstract class BookService {
  Future<BookDbModel> addBook(Book book);

  Future<void> deleteBook(String id);

  Future<BookDbModel?> getBookById(String id);

  Future<BookDbModel> updateBook(String id, Book book);

  Future<List<BookDbModel>> getAllBooks();

  Future<List<BookDbModel>> searchByName(String name);

  Future<List<BookDbModel>> searchByCategory(String name);

  Future<List<BookDbModel>> searchByAuthor(String name);

}
