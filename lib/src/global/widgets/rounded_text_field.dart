import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final double width;
  final bool center;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final EdgeInsets margin;

  final Color borderColor;
  final Color backgroundColor;
  final Color placeholderColor;
  final bool enableBoder;

  const RoundedTextField(
      {Key? key,
      required this.hintText,
      required this.width,
      this.center = true,
      this.obscureText = false,
      this.keyboardType,
      this.focusNode,
      this.onSubmitted,
      this.onChanged,
      this.controller,
      this.validator,
      this.margin = const EdgeInsets.symmetric(vertical: 8.0),
      this.borderColor = Colors.transparent,
      this.backgroundColor = const Color(0xFFE0E0E0),
      this.placeholderColor = AppColors.white,
      this.enableBoder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        // color: backgroundColor,
        // border: Border.all(color: borderColor),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        style: const TextStyle(color: AppColors.white, fontSize: 15),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: enableBoder ? Colors.white : ColorPalette.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: enableBoder ? Colors.white : ColorPalette.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: enableBoder ? Colors.white : ColorPalette.primary,
                width: 2.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: placeholderColor),
          filled: true,
          fillColor: ColorPalette.primary.withOpacity(0.5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        ),
      ),
    );
  }
}
