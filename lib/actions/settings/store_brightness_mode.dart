library store_brightness_mode;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/settings/brightness_mode.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'store_brightness_mode.g.dart';

abstract class StoreBrightnessMode extends Object
    with ReduxAction
    implements Built<StoreBrightnessMode, StoreBrightnessModeBuilder> {
  BrightnessMode get mode;

  StoreBrightnessMode._();

  factory StoreBrightnessMode({@required BrightnessMode mode}) =
      _$StoreBrightnessMode._;

  factory StoreBrightnessMode.by(
          [void Function(StoreBrightnessModeBuilder) updates]) =
      _$StoreBrightnessMode;

  Object toJson() =>
      serializers.serializeWith(StoreBrightnessMode.serializer, this);

  static StoreBrightnessMode fromJson(String jsonString) => serializers
      .deserializeWith(StoreBrightnessMode.serializer, json.decode(jsonString));

  static Serializer<StoreBrightnessMode> get serializer =>
      _$storeBrightnessModeSerializer;

  @override
  String toString() => 'STORE_BRIGHTNESS_MODE';
}
