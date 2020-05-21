library update_profile_page;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'update_profile_page.g.dart';

abstract class UpdateProfilePage extends Object
    with ReduxAction
    implements Built<UpdateProfilePage, UpdateProfilePageBuilder> {
  @nullable
  bool get pickingProfilePic;

  UpdateProfilePage._();

  factory UpdateProfilePage([void Function(UpdateProfilePageBuilder) updates]) =
      _$UpdateProfilePage;

  Object toJson() =>
      serializers.serializeWith(UpdateProfilePage.serializer, this);

  static UpdateProfilePage fromJson(String jsonString) => serializers
      .deserializeWith(UpdateProfilePage.serializer, json.decode(jsonString));

  static Serializer<UpdateProfilePage> get serializer =>
      _$updateProfilePageSerializer;

  @override
  String toString() => 'UPDATE_PROFILE_PAGE';
}
