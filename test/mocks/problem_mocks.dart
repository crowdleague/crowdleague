import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/models/app/problem.dart';

final mockProblem = Problem((a) => a
  ..message = 'message'
  ..type = ProblemType.signOut
  ..state.replace(AppState.init())
  ..trace = StackTrace.current.toString());
