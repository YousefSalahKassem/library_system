// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:library_system/src/users/models/user_dp_model.dart';

class LoginResponse extends Equatable {
  final UserDbModel user;
  final String refreshToken;
  const LoginResponse({
    required this.user,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [user, refreshToken];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'refreshToken': refreshToken,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      user: UserDbModel.fromMap(
        (map['user'] ?? Map<String, dynamic>.from({})) as Map<String, dynamic>,
      ),
      refreshToken: (map['refreshToken'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}