import 'package:library_system/src/users/models/create_user_request.dart';
import 'package:library_system/src/users/models/login_request.dart';
import 'package:library_system/src/users/models/login_responce.dart';
import 'package:library_system/src/users/models/user_dp_model.dart';
import 'package:library_system/src/users/repository/user_repository_impl.dart';
import 'package:library_system/src/users/service/user_service.dart';
import 'package:library_system/utils/jwt_auth.dart';
import 'package:library_system/utils/password_utils.dart';

/// UserServiceImpl
class UserServiceImpl extends UserService {
  /// UserRepositoryImpl
  UserServiceImpl();

  final UserRepositoryImpl _userRepository = UserRepositoryImpl();

  @override
  Future<UserDbModel> registerUser(CreateUserReq userReq) async {
    try {
      final userReqClone = userReq.copyWith(
        password: PasswordUtils.encryptPassword(userReq.password),
      );
      // check if user already exists
      final user = await _userRepository.getUserByEmail(userReqClone.email);
      if (user != null) {
        throw Exception('User already exists');
      }
      return _userRepository.createUser(userReqClone);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResponse> loginUser(LoginReq request) async {
    try {
      // check if user already exists
      final user = await _userRepository.getUserByEmail(request.email);
      if (user == null) {
        throw Exception('User does not exists');
      }
      if (user.password != PasswordUtils.encryptPassword(request.password)) {
        throw Exception('Invalid email address or password');
      }
      // generate token
      final claims = <String, dynamic>{
        'id': user.id,
        'email': user.email,
        'name': user.name,
      };

      final refreshToken = JWTUtils.generateRefreshToken(claims);
      // return
      return LoginResponse(
        user: user,
        refreshToken: refreshToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String id) {
    try {
      return _userRepository.deleteUser(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDbModel?> getUserById(String id) {
    try {
      return _userRepository.getUserById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserDbModel>> getUserByName(String name) {
    try {
      return _userRepository.getUserByName(name);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDbModel?> getUserProfile(String token) {
    try {
      return _userRepository.getUserProfile(token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDbModel> updateUser(String id, CreateUserReq userReq) {
    try {
      return _userRepository.updateUser(id, userReq);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserDbModel>> getAllUsers() {
    try {
      return _userRepository.getAllUsers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDbModel?> changePassword(
      String token, String oldPassword, String newPassword) {
    try {
      return _userRepository.changePassword(token, oldPassword, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  
}
