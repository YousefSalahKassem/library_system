import 'package:library_system/src/users/models/create_user_request.dart';
import 'package:library_system/src/users/models/user_dp_model.dart';

/// UserRepository
abstract class UserRepository {
  /// get all users
  Future<List<UserDbModel>> getAllUsers();

  /// get user by id
  Future<UserDbModel?> getUserById(String id);

  /// get user by email
  Future<UserDbModel?> getUserByEmail(String email);

  Future<List<UserDbModel>> getUserByName(String name);

  /// create user
  Future<UserDbModel> createUser(CreateUserReq userReq);

  /// update user
  /// [id] user id
  Future<UserDbModel> updateUser(String id, CreateUserReq userReq);

  /// delete user
  /// [id] user id
  Future<void> deleteUser(String id);

  Future<UserDbModel?> getUserProfile(String token);

  // ignore: public_member_api_docs
  Future<UserDbModel?> changePassword(
      String token, String oldPassword, String newPassword);
}
