import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/src/users/repository/user_repository_impl.dart';
import 'package:library_system/src/users/service/user_service_impl.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(repoProvider()).use(serviceProvider());
}
Middleware repoProvider() {
  return provider<UserRepositoryImpl>(
    (_) => UserRepositoryImpl(),
  );
}

Middleware serviceProvider() {
  return provider<UserServiceImpl>(
    (_) => UserServiceImpl(),
  );
}