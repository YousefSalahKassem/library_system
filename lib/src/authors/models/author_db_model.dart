// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';

List<Map<String, dynamic>> authorModelListToMapList(List<AuthorDbModel> list) {
  return list.map((e) => e.toMap()).toList();
}

class AuthorDbModel extends Equatable {
  const AuthorDbModel({
    required this.id,
    required this.name,
  });
  factory AuthorDbModel.fromJson(String source) =>
      AuthorDbModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// fromMap
  factory AuthorDbModel.fromMap(Map<String, dynamic> map) {
    return AuthorDbModel(
      id: map['_id'] as ObjectId,
      name: (map['name'] ?? '') as String,
    );
  }

  final ObjectId id;
  final String name;

  String toJson() => json.encode(toMap());

  AuthorDbModel copyWith({
    ObjectId? id,
    String? name,
  }) {
    return AuthorDbModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toHexString(),
      'name': name,
    };
  }

  @override
  String toString() {
    return 'UserDbModel(id: $id, name: $name)';
  }

  @override
  List<Object?> get props => [id, name];
}
