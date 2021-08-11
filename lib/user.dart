import 'package:json_annotation/json_annotation.dart';
import 'profile.dart';
part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class UserProfile {
  int id;
  String name;
  int age;
  Profile profile;

  UserProfile(this.id, this.name, this.age, this.profile);

  factory UserProfile.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
