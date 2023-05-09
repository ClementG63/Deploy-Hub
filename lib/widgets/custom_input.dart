import 'package:flutter/material.dart';
import 'package:front/constants.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;

  final RegExp? regex;
  final String header, hintText;
  final bool isTextObscure, showValidatorStatus;
  final String? Function(String?)? validator;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.header,
    required this.hintText,
    required this.isTextObscure,
    required this.showValidatorStatus,
    required this.validator,
    this.regex,
  }) : super(key: key);

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool? _boolValidator;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.header,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w100,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextFormField(
            controller: widget.controller,
            style: const TextStyle(
              fontSize: 12,
            ),
            onChanged: (value) {
              if (widget.regex != null) {
                if (value.isNotEmpty) {
                  setState(() => _boolValidator = widget.regex!.hasMatch(value));
                } else {
                  setState(() => _boolValidator = null);
                }
              }
            },
            keyboardType: TextInputType.emailAddress,
            cursorColor: mainDarkColor,
            obscureText: widget.isTextObscure,
            validator: widget.validator,
            decoration: InputDecoration(
              suffixIcon: _boolValidator != null && widget.showValidatorStatus
                  ? _boolValidator!
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red)
                  : const SizedBox.shrink(),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 12,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: mainDarkColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
