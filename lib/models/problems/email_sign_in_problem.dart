library email_sign_in_problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'email_sign_in_problem.g.dart';

abstract class EmailSignInProblem
    implements
        ProblemBase,
        Built<EmailSignInProblem, EmailSignInProblemBuilder> {
  EmailSignInProblem._();

  factory EmailSignInProblem(
      {String message,
      String trace,
      BuiltMap<String, Object> info}) = _$EmailSignInProblem._;

  factory EmailSignInProblem.by(
          [void Function(EmailSignInProblemBuilder) updates]) =
      _$EmailSignInProblem;

  Object toJson() =>
      serializers.serializeWith(EmailSignInProblem.serializer, this);

  static EmailSignInProblem fromJson(String jsonString) => serializers
      .deserializeWith(EmailSignInProblem.serializer, json.decode(jsonString));

  static Serializer<EmailSignInProblem> get serializer =>
      _$emailSignInProblemSerializer;
}
