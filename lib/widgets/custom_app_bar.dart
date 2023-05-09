import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/controllers/user_controller.dart';
import 'package:front/route/app_router.gr.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool reverse;

  const CustomAppBar({
    Key? key,
    required this.reverse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, sharedPref) {
        return AppBar(
          elevation: 0,
          backgroundColor: reverse ? Colors.white : mainDarkColor,
          title: InkWell(
            onTap: () {
              if (AutoRouter.of(context).current.path != "/") {
                AutoRouter.of(context).pushNamed("/");
              }
            },
            child: Text(
              "DeployHub",
              style: TextStyle(
                color: reverse ? mainDarkColor : Colors.white,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          leading: null,
          actions: [
            TextButton(
              onPressed: () {
                if (AutoRouter.of(context).current.path != "/") {
                  AutoRouter.of(context).pushNamed("/");
                }
              },
              child: Text(
                "Accueil",
                style: TextStyle(
                  color: reverse ? mainDarkColor : Colors.white,
                ),
              ),
            ),
            userController.isAuthenticated
                ? TextButton(
                    onPressed: () {
                      AutoRouter.of(context).popAndPush(const HomeRoute());
                    },
                    child: Text(
                      "Mes projets",
                      style: TextStyle(
                        color: reverse ? mainDarkColor : Colors.white,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            userController.isAuthenticated ? _buildLogoutBtn(context, userController) : _buildLoginBtn(context)
          ],
        );
      },
    );
  }

  TextButton _buildLoginBtn(BuildContext context) {
    return TextButton(
      onPressed: () => AutoRouter.of(context).pushNamed("/auth-page"),
      child: Text(
        "Se connecter",
        style: TextStyle(
          color: reverse ? mainDarkColor : Colors.white,
        ),
      ),
    );
  }

  TextButton _buildLogoutBtn(BuildContext context, UserController userController) {
    return TextButton(
      onPressed: () {
        userController.logout();
        AutoRouter.of(context).pushAndPopUntil(
          const WelcomeRoute(),
          predicate: (route) => false,
        );
      },
      child: Text(
        "Se déconnecter",
        style: TextStyle(
          color: reverse ? mainDarkColor : Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
