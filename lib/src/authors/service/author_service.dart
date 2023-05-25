import 'package:library_system/src/authors/models/author.dart';
import 'package:library_system/src/authors/models/author_db_model.dart';
import 'package:library_system/src/category/models/category.dart';
import 'package:library_system/src/category/models/category_db_model.dart';

abstract class AuthorService {
  Future<List<AuthorDbModel>> getAllAuthors();

  Future<void> removeAuthor(String id);

  Future<AuthorDbModel?> getAuthorById(String id);

  Future<AuthorDbModel?> getAuthorByName(String name);

  Future<AuthorDbModel> addAuthor(Author author);
}
