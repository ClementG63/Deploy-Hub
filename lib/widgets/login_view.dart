import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/controllers/user_controller.dart';
import 'package:front/route/app_router.gr.dart';
import 'package:front/widgets/connect_button.dart';
import 'package:front/widgets/custom_input.dart';
import 'package:front/widgets/purple_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginView extends StatefulWidget {
  final PageController pageViewController;
  final RouteMatch<dynamic>? onSuccessRoute;

  const LoginView({
    Key? key,
    required this.pageViewController,
    required this.onSuccessRoute,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  late UserController _userController;

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    _userController = Provider.of<UserController>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildLoginHeader(),
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildGitLogin(),
                  _buildDivider(),
                  _buildFieldsStayAndConnected(context),
                  _buildCreateAccount(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildFieldsStayAndConnected(BuildContext context) {
    return Column(
      children: [
        _buildLoginForm(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ResponsiveRowColumn(
            rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
            layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            children: [
              ResponsiveRowColumnItem(child: _buildStayConnected()),
              ResponsiveRowColumnItem(child: _buildForgotPassword()),
            ],
          ),
        ),
        _buildConnectButton()
      ],
    );
  }

  Widget _buildLoginHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Se connecter",
            style: TextStyle(
              color: mainDarkColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Déployer vos projets et surveillez les !",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w100,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGitLogin() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          ConnectButton(
            title: "Sign in with Gitlab",
            assetImage: "gitlab.png",
            onTap: () {},
          ),
          const SizedBox(height: 10),
          ConnectButton(
            title: "Sign in with GitHub",
            assetImage: "github.png",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Text(
                "Ou via mail",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w100,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInput(
            controller: _mailController,
            regex: mailRegex,
            header: 'Adresse mail',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Merci d'insérer une adresse mail";
              }
              return null;
            },
            hintText: "exemple@gmail.com",
            isTextObscure: false,
            showValidatorStatus: true,
          ),
          const SizedBox(height: 15),
          CustomInput(
            controller: _passwordController,
            regex: passwordRegex,
            header: 'Mot de passe',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Merci d'insérer un mot de passe";
              }
              return null;
            },
            hintText: "Mot de passe",
            showValidatorStatus: false,
            isTextObscure: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStayConnected() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() => _isChecked = value!);
          },
          activeColor: mainDarkColor,
        ),
        const Text(
          "Se souvenir de moi",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return InkWell(
      onTap: () {},
      child: const Text(
        "Mot de passe oublié",
        style: TextStyle(color: mainDarkColor, fontSize: 13),
      ),
    );
  }

  Widget _buildConnectButton() {
    return PurpleButton(
      enabled: true,
      btnTitle: "Se connecter",
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          _userController.login(
            mail: _mailController.text,
            password: _passwordController.text,
            stayConnected: _isChecked,
            onSuccess: () {
              nextPage();
            },
            onFail: (String cause) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Impossible de se connecter: $cause"),
                ),
              );
            },
          );
        }
      },
    );
  }

  nextPage() {
    AutoRouter.of(context).replace(widget.onSuccessRoute?.toPageRouteInfo() ?? const HomeRoute());
  }

  Widget _buildCreateAccount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: ResponsiveRowColumn(
          rowMainAxisAlignment: MainAxisAlignment.center,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          children: [
            ResponsiveRowColumnItem(
              child: AutoSizeText(
                "Vous n'avez pas de compte ?",
                maxLines: 1,
                maxFontSize: 15,
                minFontSize: 5,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w100,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            const ResponsiveRowColumnItem(child: SizedBox(width: 5)),
            ResponsiveRowColumnItem(
              child: InkWell(
                onTap: () {
                  widget.pageViewController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
                child: const AutoSizeText(
                  "Se créer un compte",
                  overflow: TextOverflow.ellipsis,
                  maxFontSize: 15,
                  minFontSize: 5,
                  maxLines: 1,
                  style: TextStyle(
                    color: mainDarkColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
