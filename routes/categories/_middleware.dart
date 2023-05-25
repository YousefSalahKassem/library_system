import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/src/category/repository/category_repository_impl.dart';
import 'package:library_system/src/category/service/categpry_service_impl.dart';


Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(repoProvider()).use(serviceProvider());
}
Middleware repoProvider() {
  return provider<CategoryRepositoryImpl>(
    (_) => CategoryRepositoryImpl(),
  );
}

Middleware serviceProvider() {
  return provider<CategoryServiceImpl>(
    (_) => CategoryServiceImpl(),
  );
}
