import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/controllers/dockerfile_controller.dart';
import 'package:front/controllers/instance_controller.dart';
import 'package:front/controllers/project_controller.dart';
import 'package:front/controllers/user_controller.dart';
import 'package:front/model/entities/user.dart';
import 'package:front/route/app_router.gr.dart';
import 'package:front/route/auth_guard.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  Logger().i("First init");
  setPathUrlStrategy();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserController()),
      ChangeNotifierProvider(create: (context) => ProjectController()),
      ChangeNotifierProvider(create: (context) => InstanceController()),
      ChangeNotifierProvider(create: (context) => DockerfileController()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final appRouter = AppRouter(authGuard: AuthGuard());

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((sharedPreferences) {
      final userController = Provider.of<UserController>(context, listen: false);
      final logCheckResult = sharedPreferences.getBool(isLoggedSPKey);

      if (logCheckResult != null &&
          logCheckResult &&
          userController.loggedUser != null &&
          !userController.isAuthenticated) {
        final user = sharedPreferences.getString(userSPKey);
        if (user != null) {
          userController.loggedUser ??= User.fromJson(jsonDecode(user));
          Logger().i("User is now ${userController.loggedUser}");
        } else {
          sharedPreferences.remove(isLoggedSPKey);
        }
      }
    });

    return MaterialApp.router(
      builder: (context, child) {
        return ResponsiveWrapper.builder(
          child,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(450, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
        );
      },
      routeInformationParser: appRouter.defaultRouteParser(),
      title: 'DeployHub',
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(),
    );
  }
}
