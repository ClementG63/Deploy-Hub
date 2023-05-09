import 'package:auto_route/auto_route.dart';
import 'package:front/pages/about_page.dart';
import 'package:front/pages/home_page.dart';
import 'package:front/pages/not_found_page.dart';
import 'package:front/pages/param_page.dart';
import 'package:front/pages/welcome_page.dart';
import 'package:front/pages/auth_page.dart';
import 'package:front/route/auth_guard.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: WelcomePage, initial: true),
    AutoRoute(page: HomePage, guards: [AuthGuard]),
    AutoRoute(page: AuthPage),
    AutoRoute(page: ParamPage, guards: [AuthGuard]),
    AutoRoute(page: NotFoundPage, path: '/not-found'),
    AutoRoute(page: AboutPage),
    RedirectRoute(
      path: '*',
      redirectTo: '/not-found',
    ),
  ],
)
class $AppRouter {}