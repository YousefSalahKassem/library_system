// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Author extends Equatable{
  const Author({
    required this.name,
  });




  final String name;

  static const empty = Author(
    name: '',
  );

   @override
  List<Object?> get props => [name];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      name: (map['name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Author.fromJson(String source) =>
      Author.fromMap(json.decode(source) as Map<String, dynamic>);
}