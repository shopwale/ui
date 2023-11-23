import 'package:flutter/material.dart';
import 'package:local_genie_vendor/app_properties.dart';

class InputWithOutIcon extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool reverseColor;
  final bool readOnly;
  final TextInputType keyboardType;
  final String errorText;

  const InputWithOutIcon({
    super.key,
    required this.controller,
    this.label = "",
    this.hint = "",
    this.reverseColor = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.errorText = "",
  });

  @override
  _InputWithOutIcon createState() => _InputWithOutIcon();
}

class _InputWithOutIcon extends State<InputWithOutIcon> {
  final bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: widget.reverseColor == true ? yellow : Colors.green,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      obscureText: _passwordVisible,
      readOnly: widget.readOnly,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        errorText: widget.errorText == "" ? null : widget.errorText,
        errorMaxLines: 3,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.reverseColor == true ? Colors.green : Colors.white,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.reverseColor == true ? yellow : Colors.white,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.reverseColor == true ? yellow : Colors.green,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        labelStyle: TextStyle(
          color: widget.reverseColor == true ? yellow : Colors.white,
        ),
        labelText: widget.label,
        floatingLabelStyle: TextStyle(
          color: widget.reverseColor == true ? yellow : Colors.green,
        ),
        hintText: widget.hint ?? widget.label,
        hintStyle: TextStyle(
          color: widget.reverseColor == true ? Colors.green : Colors.white,
        ),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: widget.reverseColor == true ? Colors.green : yellow,
      ),
    );
  }
}
