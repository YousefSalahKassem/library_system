import 'package:library_system/src/authors/models/author.dart';
import 'package:library_system/src/authors/models/author_db_model.dart';
import 'package:library_system/src/authors/repository/author_repository_impl.dart';
import 'package:library_system/src/authors/service/author_service.dart';


// ignore: public_member_api_docs
class AuthorServiceImpl extends AuthorService {
  // ignore: public_member_api_docs
  AuthorServiceImpl();

  final AuthorRepositoryImpl _authorRepository = AuthorRepositoryImpl();

  @override
  Future<AuthorDbModel> addAuthor(Author author) {
    try {
      return _authorRepository.addAuthor(author);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AuthorDbModel>> getAllAuthors() {
    try {
      return _authorRepository.getAllAuthors();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthorDbModel?> getAuthorById(String id) {
    try {
      return _authorRepository.getAuthorById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthorDbModel?> getAuthorByName(String name) {
    try {
      return _authorRepository.getAuthorByName(name);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeAuthor(String id) {
    try {
      return _authorRepository.removeAuthor(id);
    } catch (e) {
      rethrow;
    }
  }
}
