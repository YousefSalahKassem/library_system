import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/src/books/repository/book_repository_impl.dart';
import 'package:library_system/src/books/service/book_service_impl.dart';


Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(repoProvider()).use(serviceProvider());
}
Middleware repoProvider() {
  return provider<BookRepositoryImpl>(
    (_) => BookRepositoryImpl(),
  );
}

Middleware serviceProvider() {
  return provider<BookServiceImpl>(
    (_) => BookServiceImpl(),
  );
}
