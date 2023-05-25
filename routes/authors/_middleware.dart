import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/src/authors/repository/author_repository_impl.dart';
import 'package:library_system/src/authors/service/author_service_impl.dart';


Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(repoProvider()).use(serviceProvider());
}
Middleware repoProvider() {
  return provider<AuthorRepositoryImpl>(
    (_) => AuthorRepositoryImpl(),
  );
}

Middleware serviceProvider() {
  return provider<AuthorServiceImpl>(
    (_) => AuthorServiceImpl(),
  );
}
