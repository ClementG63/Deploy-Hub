import 'package:auto_route/auto_route.dart';
import 'package:front/controllers/user_controller.dart';
import 'package:front/route/app_router.gr.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    UserController? userController;
    final context = router.navigatorKey.currentContext;
    if (context != null) {
      userController = Provider.of<UserController>(context, listen: false);
    }

    if (userController != null && userController.isAuthenticated && userController.loggedUser != null) {
      Logger().i("Authorized");
      resolver.next();
    } else {
      Logger().i("Unauthorized");
      router.pushAndPopUntil(AuthRoute(onSuccessRoute: resolver.route), predicate: (route) => false);
    }
  }
}
