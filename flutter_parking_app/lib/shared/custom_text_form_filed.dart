import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final Function(String validation) validation;
  final void Function(String validation) onSaved;
  final Widget icon;
  final Widget sufixIcon;
  final String hintText;
  final double height;
  final TextInputAction textInputAction;
  final bool autofocus;
  final bool obscureText;
  final bool isEnabled;
  final Widget label;
  final String init;

  CustomTextFormField(
      {Key key,
      this.textEditingController,
      this.keyboardType,
      this.validation,
      this.onSaved,
      this.icon,
      this.sufixIcon,
      this.hintText,
      this.height: 40.0,
      this.textInputAction,
      this.autofocus,
      this.obscureText = false,
      this.isEnabled = true,
      this.label,
      this.init})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: autofocus,
        initialValue: init,
        enabled: isEnabled,
        controller: textEditingController,
        keyboardType: keyboardType,
        validator: (value) => validation(value),
        onSaved: (value) {
          textEditingController.text = value;
        },
        textInputAction: textInputAction,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: sufixIcon,
          label: label,
          prefixIcon: icon,
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }
}
