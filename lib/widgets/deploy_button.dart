import 'package:flutter/material.dart';

class DeployButton extends StatelessWidget {
  final Function()? onTap;

  const DeployButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 2),
              spreadRadius: 2,
            )
          ],
        ),
        width: MediaQuery.of(context).size.width / 5,
        height: 50,
        alignment: Alignment.center,
        child: const Text(
          "DEPLOY",
          style: TextStyle(
            color: Color.fromARGB(255, 85, 83, 217),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
