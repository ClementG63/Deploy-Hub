import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DeleteBtn extends StatefulWidget {
  final Function() onTap;

  const DeleteBtn({Key? key, required this.onTap}) : super(key: key);

  @override
  State<DeleteBtn> createState() => _DeleteBtnState();
}

class _DeleteBtnState extends State<DeleteBtn> {
  bool confirmDeleteState = false;

  @override
  Widget build(BuildContext context) {
    return confirmDeleteState
        ? InkWell(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: const AutoSizeText(
                "Confirmer la suppression",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        : TextButton(
            onPressed: () {
              setState(() => confirmDeleteState = true);
              Future.delayed(
                const Duration(seconds: 5),
                () {
                  setState(() => confirmDeleteState = false);
                },
              );
            },
            child: const AutoSizeText(
              "❌Supprimer ce projet",
              style: TextStyle(color: Colors.black54),
            ),
          );
  }
}
