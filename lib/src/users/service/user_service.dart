import '../models/create_user_request.dart';
import '../models/login_request.dart';
import '../models/login_responce.dart';
import '../models/user_dp_model.dart';

/// UserService
abstract class UserService {
  /// get all users
  Future<List<UserDbModel>> getAllUsers();

  /// get user by id
  Future<UserDbModel?> getUserById(String id);

  Future<List<UserDbModel>> getUserByName(String name);

  // ignore: public_member_api_docs
  Future<UserDbModel?> getUserProfile(String token);

  /// get user by email
  Future<LoginResponse> loginUser(LoginReq request);

  /// create user
  Future<UserDbModel> registerUser(CreateUserReq userReq);

  /// update user
  /// [id] user id
  Future<UserDbModel> updateUser(String id, CreateUserReq userReq);

  /// delete user
  /// [id] user id
  Future<void> deleteUser(String id);

  Future<UserDbModel?> changePassword(
      String token, String oldPassword, String newPassword);
}
