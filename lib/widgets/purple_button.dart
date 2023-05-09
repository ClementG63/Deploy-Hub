import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';

class PurpleButton extends StatelessWidget {
  final String btnTitle;
  final Function() onTap;
  final bool enabled;

  const PurpleButton({
    Key? key,
    required this.btnTitle,
    required this.onTap,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? mainDarkColor : Colors.black12,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: AutoSizeText(
          btnTitle,
          maxFontSize: 15,
          minFontSize: 5,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
