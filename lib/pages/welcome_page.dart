import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/route/app_router.gr.dart';
import 'package:front/widgets/custom_app_bar.dart';
import 'package:front/widgets/deploy_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WelcomePage> {
  final _textEditingController = TextEditingController();
  final regExp = RegExp("^git@gitlab.[a-zA-Z0-9-_]{1,}.?[a-zA-Z]*:[a-zA-Z0-9-_]+/[a-zA-Z0-9-_]+.git");
  bool? isUrlValid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(reverse: false),
      backgroundColor: mainDarkColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _buildInputText(context),
            ),
            const SizedBox(height: 20),
            _buildDeployButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildDeployButton(BuildContext context) {
    if (isUrlValid != null && isUrlValid!) {
      return DeployButton(
        onTap: () {
          context.router.push(ParamRoute(projectUrl: _textEditingController.text));
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTitle() {
    return AnimatedTextKit(
      repeatForever: true,
      animatedTexts: [
        TypewriterAnimatedText(
          "DeployHub",
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
          speed: const Duration(milliseconds: 150),
        )
      ],
    );
  }

  Row _buildInputText(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              "assets/git.png",
              width: 15,
              color: Colors.black.withOpacity(0.4),
            ),
            const SizedBox(width: 15),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "git@gitlab.com:{votre_pseudo_git}/{nom_du_repertoire}.git",
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        isUrlValid = regExp.hasMatch(value);
                      } else {
                        isUrlValid = null;
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        _buildVerifyCheck(),
      ],
    );
  }

  Widget _buildVerifyCheck() {
    return isUrlValid != null
        ? isUrlValid!
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : const Icon(
                Icons.close,
                color: Colors.red,
              )
        : const SizedBox.shrink();
  }
}
