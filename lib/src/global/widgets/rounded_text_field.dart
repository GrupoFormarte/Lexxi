import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class RoundedTextField extends StatefulWidget {
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
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        // color: backgroundColor,
        // border: Border.all(color: borderColor),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        obscureText: _isObscured,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        style: const TextStyle(color: AppColors.white, fontSize: 15),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: widget.enableBoder ? Colors.white : ColorPalette.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: widget.enableBoder ? Colors.white : ColorPalette.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: widget.enableBoder ? Colors.white : ColorPalette.primary,
                width: 2.0),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.placeholderColor),
          filled: true,
          fillColor: ColorPalette.primary.withOpacity(0.5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
