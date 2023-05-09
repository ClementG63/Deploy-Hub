import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/widgets/custom_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(reverse: false),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "You are lost",
              style: GoogleFonts.rubikWetPaint(
                fontSize: 100,
                color: mainDarkColor
              )
            ),
            const Text(
              "404: Page not found",
              style: TextStyle(
                color: mainDarkColor,
                fontSize: 55,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
