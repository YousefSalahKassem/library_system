import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/users/models/create_user_request.dart';
import 'package:library_system/src/users/models/user_dp_model.dart';
import 'package:library_system/src/users/repository/user_repository.dart';
import 'package:library_system/utils/jwt_auth.dart';
import 'package:library_system/utils/password_utils.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// UserRepositoryImpl class
class UserRepositoryImpl implements UserRepository {
  /// UserRepositoryImpl
  UserRepositoryImpl();

  final MongoClient _mongoClient = MongoClient();

  @override
  Future<UserDbModel> createUser(CreateUserReq userReq) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      // generate token
      final claims = <String, dynamic>{
        'email': userReq.email,
        'name': userReq.name,
        'password': userReq.password,
      };
      final token = JWTUtils.generateToken(claims);
      final results = await collection.insertOne(
        userReq
            .copyWith(
              token: token,
            )
            .toMap(),
      );
      return UserDbModel.fromMap(results.document!);
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<void> deleteUser(String id) {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      return collection.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<UserDbModel?> getUserByEmail(String email) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      final results = await collection.findOne(where.eq('email', email));
      if (results != null) {
        final user = UserDbModel.fromMap(results);
        final claims = <String, dynamic>{
          'email': user.email,
          'name': user.name,
          'password': user.password,
        };
        final token = JWTUtils.generateToken(claims);
        final updatedUser = await updateUser(
            user.id.$oid,
            CreateUserReq(
                name: user.name,
                email: user.email,
                password: user.password,
                token: token));
        return updatedUser;
      } else {
        return null;
      }
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<UserDbModel?> getUserById(String id) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      final results = await collection.findOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
      );
      if (results != null) {
        return UserDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<UserDbModel> updateUser(String id, CreateUserReq userReq) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      final userReqMap = userReq.toMap()..remove('password');
      final results = await collection.updateOne(
        where.eq(
          '_id',
          ObjectId.fromHexString(id),
        ),
        {
          r'$set': userReqMap,
        },
      );
      if (results.isSuccess) {
        final updatedUser = await getUserById(id);
        return updatedUser!;
      } else {
        throw Exception(results.errmsg ?? 'an error occured in updating user');
      }
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<List<UserDbModel>> getAllUsers() {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      return collection.find().map(UserDbModel.fromMap).toList();
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<UserDbModel?> getUserProfile(String token) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      final results = await collection.findOne(where.eq('token', token));
      if (results != null) {
        return UserDbModel.fromMap(results);
      } else {
        return null;
      }
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<List<UserDbModel>> getUserByName(String name) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      final results = await collection.find(where.eq('name', name)).toList();
      return results.map(UserDbModel.fromMap).toList();
    } else {
      throw Exception('Database not connected');
    }
  }

  @override
  Future<UserDbModel?> changePassword(
      String token, String oldPassword, String newPassword) async {
    if (_mongoClient.db != null) {
      final collection = _mongoClient.db!.collection('users');
      final user = await collection.findOne(where.eq('token', token));

      if (user != null) {
        final userDbModel = UserDbModel.fromMap(user);

        if (userDbModel.password ==
            PasswordUtils.encryptPassword(oldPassword)) {
          final updatedUser = userDbModel.copyWith(
              password: PasswordUtils.encryptPassword(newPassword));
          final results = await collection.updateOne(
            where.eq('_id', updatedUser.id),
            {
              r'$set': updatedUser.toMap(),
            },
          );

          if (results.isSuccess) {
            return updatedUser;
          } else {
            throw Exception(
                results.errmsg ?? 'An error occurred while updating the user');
          }
        } else {

          throw Exception('Incorrect old password');
        }
      } else {
        throw Exception('User not found');
      }
    } else {
      throw Exception('Database not connected');
    }
  }
}
