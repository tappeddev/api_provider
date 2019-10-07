import 'package:codable/codable.dart';
import 'package:meta/meta.dart';

class User {
  final String email;
  final String name;

  const User({
    @required this.email,
    @required this.name,
  });
}

class UserEncoder implements Deserializable<Map, User> {
  @override
  Map to(User input) => <String, dynamic>{
        'email': input.email,
        'name': input.name,
      };
}

class UserDecoder implements Serializable<Map, User> {
  @override
  User from(Map input) => User(
        email: input['email'] as String,
        name: input['name'] as String,
      );
}
