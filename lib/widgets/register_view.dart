import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/controllers/user_controller.dart';
import 'package:front/widgets/custom_input.dart';
import 'package:front/widgets/purple_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RegisterView extends StatefulWidget {
  final PageController pageViewController;

  const RegisterView({Key? key, required this.pageViewController}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();
  bool _isChecked = false;
  final _nicknameController = TextEditingController();
  final _registerMailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRegisterHeader(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildRegisterForm(),
                  const SizedBox(height: 10),
                  _buildAcceptTerms(),
                  _buildRegisterButton(
                    _nicknameController.text,
                    _registerMailController.text,
                    _passwordController.text,
                  ),
                ],
              ),
            ),
            _buildLoginAccount(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "S'inscrire",
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

  Form _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInput(
            controller: _nicknameController,
            header: "Pseudo",
            hintText: "Pseudo (3 à 12 caractères)",
            isTextObscure: false,
            showValidatorStatus: true,
            regex: nicknameRegex,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Merci d'insérer un pseudo";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomInput(
            controller: _firstNameController,
            header: "Prénom",
            hintText: "Prénom",
            isTextObscure: false,
            showValidatorStatus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Merci d'insérer un prénom";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomInput(
            controller: _lastNameController,
            header: "Nom",
            hintText: "Nom",
            isTextObscure: false,
            showValidatorStatus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Merci d'insérer un nom";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomInput(
            controller: _registerMailController,
            header: "Adresse mail",
            hintText: "example@gmail.com",
            isTextObscure: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Merci d'insérer une adresse mail";
              }
              return null;
            },
            showValidatorStatus: true,
            regex: mailRegex,
          ),
          const SizedBox(height: 15),
          CustomInput(
            controller: _passwordController,
            showValidatorStatus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Merci d'insérer un mot de passe";
              } else if (!passwordRegex.hasMatch(_passwordController.text)) {
                return "Merci de vérifier le mot de passe";
              }
              return null;
            },
            isTextObscure: true,
            hintText: "Min. 8 caractères",
            header: "Mot de passe",
            regex: passwordRegex,
          ),
          const SizedBox(height: 15),
          CustomInput(
            controller: _confirmPasswordController,
            showValidatorStatus: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Merci d'insérer un mot de passe";
              } else if (_confirmPasswordController.text != _passwordController.text) {
                return "Les mots de passe ne correspondent pas";
              }
              return null;
            },
            isTextObscure: true,
            hintText: "Min. 8 caractères",
            header: "Mot de passe",
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(String username, String mail, String password) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: PurpleButton(
        btnTitle: "S'inscrire",
        enabled: true,
        onTap: () async {
          if (_registerFormKey.currentState!.validate() && _isChecked) {
            Provider.of<UserController>(context, listen: false).register(
              username: _nicknameController.text,
              mail: _registerMailController.text,
              password: _passwordController.text,
              firstname: _firstNameController.text,
              lastname: _lastNameController.text,
              onSuccess: () => widget.pageViewController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              ),
              onFail: (String error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Impossible de créer le compte: $error"),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginAccount() {
    return ResponsiveRowColumn(
      columnMainAxisAlignment: MainAxisAlignment.center,
      layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? ResponsiveRowColumnType.COLUMN
          : ResponsiveRowColumnType.ROW,
      children: [
        ResponsiveRowColumnItem(
          child: Text(
            "Vous avez déjà un compte ?",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w100,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        const ResponsiveRowColumnItem(
          child: SizedBox(width: 10),
        ),
        ResponsiveRowColumnItem(
          child: InkWell(
            onTap: () {
              widget.pageViewController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
            },
            child: const Text(
              "Se connecter",
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: mainDarkColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAcceptTerms() {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          activeColor: mainDarkColor,
          onChanged: (value) {
            setState(() => _isChecked = value as bool);
          },
        ),
        const Text(
          "J'ai lu et j'accepte les CGU",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }
}
