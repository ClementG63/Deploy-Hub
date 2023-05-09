// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../pages/about_page.dart' as _i6;
import '../pages/auth_page.dart' as _i3;
import '../pages/home_page.dart' as _i2;
import '../pages/not_found_page.dart' as _i5;
import '../pages/param_page.dart' as _i4;
import '../pages/welcome_page.dart' as _i1;
import 'auth_guard.dart' as _i9;

class AppRouter extends _i7.RootStackRouter {
  AppRouter({
    _i8.GlobalKey<_i8.NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final _i9.AuthGuard authGuard;

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    WelcomeRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.WelcomePage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    AuthRoute.name: (routeData) {
      final args =
          routeData.argsAs<AuthRouteArgs>(orElse: () => const AuthRouteArgs());
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.AuthPage(
          key: args.key,
          onSuccessRoute: args.onSuccessRoute,
        ),
      );
    },
    ParamRoute.name: (routeData) {
      final args = routeData.argsAs<ParamRouteArgs>();
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.ParamPage(
          key: args.key,
          projectUrl: args.projectUrl,
        ),
      );
    },
    NotFoundRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.NotFoundPage(),
      );
    },
    AboutRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.AboutPage(),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          WelcomeRoute.name,
          path: '/',
        ),
        _i7.RouteConfig(
          HomeRoute.name,
          path: '/home-page',
          guards: [authGuard],
        ),
        _i7.RouteConfig(
          AuthRoute.name,
          path: '/auth-page',
        ),
        _i7.RouteConfig(
          ParamRoute.name,
          path: '/param-page',
          guards: [authGuard],
        ),
        _i7.RouteConfig(
          NotFoundRoute.name,
          path: '/not-found',
        ),
        _i7.RouteConfig(
          AboutRoute.name,
          path: '/about-page',
        ),
        _i7.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/not-found',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.WelcomePage]
class WelcomeRoute extends _i7.PageRouteInfo<void> {
  const WelcomeRoute()
      : super(
          WelcomeRoute.name,
          path: '/',
        );

  static const String name = 'WelcomeRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.AuthPage]
class AuthRoute extends _i7.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i8.Key? key,
    _i7.RouteMatch<dynamic>? onSuccessRoute,
  }) : super(
          AuthRoute.name,
          path: '/auth-page',
          args: AuthRouteArgs(
            key: key,
            onSuccessRoute: onSuccessRoute,
          ),
        );

  static const String name = 'AuthRoute';
}

class AuthRouteArgs {
  const AuthRouteArgs({
    this.key,
    this.onSuccessRoute,
  });

  final _i8.Key? key;

  final _i7.RouteMatch<dynamic>? onSuccessRoute;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, onSuccessRoute: $onSuccessRoute}';
  }
}

/// generated route for
/// [_i4.ParamPage]
class ParamRoute extends _i7.PageRouteInfo<ParamRouteArgs> {
  ParamRoute({
    _i8.Key? key,
    required String projectUrl,
  }) : super(
          ParamRoute.name,
          path: '/param-page',
          args: ParamRouteArgs(
            key: key,
            projectUrl: projectUrl,
          ),
        );

  static const String name = 'ParamRoute';
}

class ParamRouteArgs {
  const ParamRouteArgs({
    this.key,
    required this.projectUrl,
  });

  final _i8.Key? key;

  final String projectUrl;

  @override
  String toString() {
    return 'ParamRouteArgs{key: $key, projectUrl: $projectUrl}';
  }
}

/// generated route for
/// [_i5.NotFoundPage]
class NotFoundRoute extends _i7.PageRouteInfo<void> {
  const NotFoundRoute()
      : super(
          NotFoundRoute.name,
          path: '/not-found',
        );

  static const String name = 'NotFoundRoute';
}

/// generated route for
/// [_i6.AboutPage]
class AboutRoute extends _i7.PageRouteInfo<void> {
  const AboutRoute()
      : super(
          AboutRoute.name,
          path: '/about-page',
        );

  static const String name = 'AboutRoute';
}
