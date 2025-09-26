part of 'routes_import.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.adaptive(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
        // AutoRoute(page: SelectionProgramRoute.page, path: '/'),
        AutoRoute(page: SplashRoute.page, path: '/'),
        AutoRoute(page: LoginRoute.page, path: '/login'),
        AutoRoute(page: SignUpRoute.page, path: '/signUp'),
        AutoRoute(page: SelectionProgramRoute.page, path: '/all_programs'),
        AutoRoute(page: LoadsQuestionsRoute.page, path: '/load_questions'),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: SimulacrumRoute.page, path: '/simulacum'),
        AutoRoute(page: QuizRoute.page, path: '/quiz'),
        AutoRoute(page: ProfileRoute.page, path: '/profile'),
        AutoRoute(page: ResultViewRoute.page, path: '/result'),
        AutoRoute(
          page: ConfigScreenRoute.page,
          path: '/config',
        )
      ];
}
