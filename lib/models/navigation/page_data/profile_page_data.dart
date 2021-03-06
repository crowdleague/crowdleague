library profile_page_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'profile_page_data.g.dart';

abstract class ProfilePageData
    implements PageData, Built<ProfilePageData, ProfilePageDataBuilder> {
  ProfilePageData._();

  factory ProfilePageData() = _$ProfilePageData._;

  Object toJson() =>
      serializers.serializeWith(ProfilePageData.serializer, this);

  static ProfilePageData fromJson(String jsonString) => serializers
      .deserializeWith(ProfilePageData.serializer, json.decode(jsonString));

  static Serializer<ProfilePageData> get serializer =>
      _$profilePageDataSerializer;
}
