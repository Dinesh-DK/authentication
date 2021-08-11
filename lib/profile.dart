import 'package:json_annotation/json_annotation.dart';
part 'profile.g.dart';

@JsonSerializable()
class Profile {
  String role, designation;
  Profile(this.role, this.designation);
  
  factory Profile.fromJson(Map<String, dynamic> data) => _$ProfileFromJson(data);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
