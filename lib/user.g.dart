// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserFromJson(Map<String, dynamic> json) {
  return UserProfile(
    json['id'] as int,
    json['name'] as String,
    json['age'] as int,
    json['profile'] == null
        ? null
        : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(UserProfile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'profile': instance.profile?.toJson(),
    };
