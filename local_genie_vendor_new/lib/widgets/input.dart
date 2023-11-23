import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.errorText,
    this.obscureText,
    this.hint,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final IconData icon;
  final String label;
  final String? hint;
  final bool? obscureText;
  final String? errorText;
  final TextInputType keyboardType;

  @override
  _Input createState() => _Input();
}

class _Input extends State<Input> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.green,
      controller: widget.controller,
      obscureText: _passwordVisible,
      obscuringCharacter: "*",
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorText: widget.errorText == "" ? null : widget.errorText,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.0),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(25.0),
        ),
        hintText: widget.hint ?? widget.label,
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.white),
        floatingLabelStyle: const TextStyle(color: Colors.green),
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.green,
        ),
        suffixIcon: widget.obscureText != null
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(
                    () {
                      _passwordVisible = !_passwordVisible;
                    },
                  );
                },
              )
            : null,
      ),
      style: const TextStyle(fontSize: 16.0, color: Colors.green),
    );
  }
}
