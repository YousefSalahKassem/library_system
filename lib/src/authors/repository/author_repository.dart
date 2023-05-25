import 'package:library_system/src/authors/models/author.dart';
import 'package:library_system/src/authors/models/author_db_model.dart';

// ignore: public_member_api_docs
abstract class AuthorRepository {
  Future<List<AuthorDbModel>> getAllAuthors();

  Future<void> removeAuthor(String id);

  Future<AuthorDbModel?> getAuthorById(String id);

  Future<AuthorDbModel?> getAuthorByName(String name);

  Future<AuthorDbModel> addAuthor(Author author);
}
