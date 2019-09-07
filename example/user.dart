import 'package:codable/codable.dart';
import 'package:meta/meta.dart';

class User {
  final String email;
  final String name;

  const User({
    @required this.email,
    @required this.name,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'email': email,
        'name': name,
      };

  factory User.fromMap(Map map) => User(
        email: map['email'] as String,
        name: map['name'] as String,
      );
}

class UserDecoder implements Serializable<Map, User> {
  @override
  User from(Map input) => User.fromMap(input);
}
