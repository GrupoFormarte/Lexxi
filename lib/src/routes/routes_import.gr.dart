// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:lexxi/domain/item_dynamic/model/item.dart' as _i14;
import 'package:lexxi/domain/student/model/student.dart' as _i15;
import 'package:lexxi/src/pages/auth/login/login.dart' as _i4;
import 'package:lexxi/src/pages/auth/signup/signup.dart' as _i9;
import 'package:lexxi/src/pages/home/home.dart' as _i2;
import 'package:lexxi/src/pages/profile/profile.dart' as _i5;
import 'package:lexxi/src/pages/profile/sub_page/config.dart' as _i1;
import 'package:lexxi/src/pages/quiz/quiz.dart' as _i6;
import 'package:lexxi/src/pages/result_view/result_view.dart' as _i7;
import 'package:lexxi/src/pages/selected_programs/loads_questions.dart'
    as _i3;
import 'package:lexxi/src/pages/selected_programs/selected_program.dart'
    as _i8;
import 'package:lexxi/src/pages/simulacrum/simulacrum.dart' as _i10;
import 'package:lexxi/src/pages/splash/splash.dart' as _i11;

abstract class $AppRouter extends _i12.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    ConfigScreenRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ConfigScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.Home(),
      );
    },
    LoadsQuestionsRoute.name: (routeData) {
      final args = routeData.argsAs<LoadsQuestionsRouteArgs>(
          orElse: () => const LoadsQuestionsRouteArgs());
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.LoadsQuestions(
          key: args.key,
          grado: args.grado,
          preguntas: args.preguntas,
          typeExam: args.typeExam,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.Login(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.Profile(),
      );
    },
    QuizRoute.name: (routeData) {
      final args = routeData.argsAs<QuizRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.Quiz(
          key: args.key,
          grado: args.grado,
          asignatura: args.asignatura,
          preguntasIds: args.preguntasIds,
          student: args.student,
          needTime: args.needTime,
          level: args.level,
          typeExam: args.typeExam,
          idGrado: args.idGrado,
          nPreguntas: args.nPreguntas,
        ),
      );
    },
    ResultViewRoute.name: (routeData) {
      final args = routeData.argsAs<ResultViewRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.ResultView(
          key: args.key,
          isSimulacro: args.isSimulacro,
          grado: args.grado,
          typeExam: args.typeExam,
          idGrado: args.idGrado,
          timePassed: args.timePassed,
          nPreguntas: args.nPreguntas,
        ),
      );
    },
    SelectionProgramRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SelectionProgram(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SignUp(),
      );
    },
    SimulacrumRoute.name: (routeData) {
      final args = routeData.argsAs<SimulacrumRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.Simulacrum(
          key: args.key,
          grado: args.grado,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.Splash(),
      );
    },
  };
}

/// generated route for
/// [_i1.ConfigScreen]
class ConfigScreenRoute extends _i12.PageRouteInfo<void> {
  const ConfigScreenRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ConfigScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfigScreenRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i2.Home]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i3.LoadsQuestions]
class LoadsQuestionsRoute extends _i12.PageRouteInfo<LoadsQuestionsRouteArgs> {
  LoadsQuestionsRoute({
    _i13.Key? key,
    _i14.Item? grado,
    int? preguntas,
    String? typeExam,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          LoadsQuestionsRoute.name,
          args: LoadsQuestionsRouteArgs(
            key: key,
            grado: grado,
            preguntas: preguntas,
            typeExam: typeExam,
          ),
          initialChildren: children,
        );

  static const String name = 'LoadsQuestionsRoute';

  static const _i12.PageInfo<LoadsQuestionsRouteArgs> page =
      _i12.PageInfo<LoadsQuestionsRouteArgs>(name);
}

class LoadsQuestionsRouteArgs {
  const LoadsQuestionsRouteArgs({
    this.key,
    this.grado,
    this.preguntas,
    this.typeExam,
  });

  final _i13.Key? key;

  final _i14.Item? grado;

  final int? preguntas;

  final String? typeExam;

  @override
  String toString() {
    return 'LoadsQuestionsRouteArgs{key: $key, grado: $grado, preguntas: $preguntas, typeExam: $typeExam}';
  }
}

/// generated route for
/// [_i4.Login]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i5.Profile]
class ProfileRoute extends _i12.PageRouteInfo<void> {
  const ProfileRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i6.Quiz]
class QuizRoute extends _i12.PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    _i13.Key? key,
    String? grado,
    String? asignatura,
    required List<String> preguntasIds,
    _i15.Student? student,
    bool? needTime,
    required String level,
    String? typeExam,
    String? idGrado,
    int? nPreguntas,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          QuizRoute.name,
          args: QuizRouteArgs(
            key: key,
            grado: grado,
            asignatura: asignatura,
            preguntasIds: preguntasIds,
            student: student,
            needTime: needTime,
            level: level,
            typeExam: typeExam,
            idGrado: idGrado,
            nPreguntas: nPreguntas,
          ),
          initialChildren: children,
        );

  static const String name = 'QuizRoute';

  static const _i12.PageInfo<QuizRouteArgs> page =
      _i12.PageInfo<QuizRouteArgs>(name);
}

class QuizRouteArgs {
  const QuizRouteArgs({
    this.key,
    this.grado,
    this.asignatura,
    required this.preguntasIds,
    this.student,
    this.needTime,
    required this.level,
    this.typeExam,
    this.idGrado,
    this.nPreguntas,
  });

  final _i13.Key? key;

  final String? grado;

  final String? asignatura;

  final List<String> preguntasIds;

  final _i15.Student? student;

  final bool? needTime;

  final String level;

  final String? typeExam;

  final String? idGrado;

  final int? nPreguntas;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, grado: $grado, asignatura: $asignatura, preguntasIds: $preguntasIds, student: $student, needTime: $needTime, level: $level, typeExam: $typeExam, idGrado: $idGrado, nPreguntas: $nPreguntas}';
  }
}

/// generated route for
/// [_i7.ResultView]
class ResultViewRoute extends _i12.PageRouteInfo<ResultViewRouteArgs> {
  ResultViewRoute({
    _i13.Key? key,
    bool isSimulacro = false,
    required String? grado,
    String? typeExam,
    String? idGrado,
    int timePassed = 0,
    int? nPreguntas,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          ResultViewRoute.name,
          args: ResultViewRouteArgs(
            key: key,
            isSimulacro: isSimulacro,
            grado: grado,
            typeExam: typeExam,
            idGrado: idGrado,
            timePassed: timePassed,
            nPreguntas: nPreguntas,
          ),
          initialChildren: children,
        );

  static const String name = 'ResultViewRoute';

  static const _i12.PageInfo<ResultViewRouteArgs> page =
      _i12.PageInfo<ResultViewRouteArgs>(name);
}

class ResultViewRouteArgs {
  const ResultViewRouteArgs({
    this.key,
    this.isSimulacro = false,
    required this.grado,
    this.typeExam,
    this.idGrado,
    this.timePassed = 0,
    this.nPreguntas,
  });

  final _i13.Key? key;

  final bool isSimulacro;

  final String? grado;

  final String? typeExam;

  final String? idGrado;

  final int timePassed;

  final int? nPreguntas;

  @override
  String toString() {
    return 'ResultViewRouteArgs{key: $key, isSimulacro: $isSimulacro, grado: $grado, typeExam: $typeExam, idGrado: $idGrado, timePassed: $timePassed, nPreguntas: $nPreguntas}';
  }
}

/// generated route for
/// [_i8.SelectionProgram]
class SelectionProgramRoute extends _i12.PageRouteInfo<void> {
  const SelectionProgramRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SelectionProgramRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectionProgramRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SignUp]
class SignUpRoute extends _i12.PageRouteInfo<void> {
  const SignUpRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i10.Simulacrum]
class SimulacrumRoute extends _i12.PageRouteInfo<SimulacrumRouteArgs> {
  SimulacrumRoute({
    _i13.Key? key,
    required String grado,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          SimulacrumRoute.name,
          args: SimulacrumRouteArgs(
            key: key,
            grado: grado,
          ),
          initialChildren: children,
        );

  static const String name = 'SimulacrumRoute';

  static const _i12.PageInfo<SimulacrumRouteArgs> page =
      _i12.PageInfo<SimulacrumRouteArgs>(name);
}

class SimulacrumRouteArgs {
  const SimulacrumRouteArgs({
    this.key,
    required this.grado,
  });

  final _i13.Key? key;

  final String grado;

  @override
  String toString() {
    return 'SimulacrumRouteArgs{key: $key, grado: $grado}';
  }
}

/// generated route for
/// [_i11.Splash]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}
