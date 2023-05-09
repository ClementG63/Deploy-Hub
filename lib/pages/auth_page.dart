import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/widgets/custom_app_bar.dart';
import 'package:front/widgets/login_view.dart';
import 'package:front/widgets/register_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AuthPage extends StatefulWidget {
  final RouteMatch<dynamic>? onSuccessRoute;

  const AuthPage({Key? key, this.onSuccessRoute}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(reverse: false),
      backgroundColor: mainDarkColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 1.2,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageViewController,
                      children: [
                        LoginView(pageViewController: _pageViewController, onSuccessRoute: widget.onSuccessRoute),
                        RegisterView(pageViewController: _pageViewController),
                      ],
                    ),
                  ),
                  _buildRightPanelAnimation(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanelAnimation() {
    if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      return const SizedBox.shrink();
    } else {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: mainDarkColor,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              WaveWidget(
                config: CustomConfig(
                  durations: [6000, 10000],
                  heightPercentages: [0.45, 0.05],
                  colors: [Colors.white, Colors.white.withOpacity(0.1)],
                ),
                size: const Size(double.infinity, double.infinity),
                waveAmplitude: 10,
                waveFrequency: 1,
              ),
              const Text(
                "DeployHub",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
