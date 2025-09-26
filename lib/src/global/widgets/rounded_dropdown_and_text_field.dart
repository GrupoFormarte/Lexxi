import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/widgets/rounded_dropdown.dart';
import 'package:lexxi/src/global/widgets/rounded_text_field.dart';

// Asegúrate de importar RoundedDropdown y RoundedTextField
// import 'rounded_dropdown.dart';
// import 'rounded_text_field.dart';

class RoundedDropdownAndTextField<T> extends StatefulWidget {
  final String dropdownHint;
  final String textFieldHint;
  final double totalWidth;
  final List<T> dropdownItems;
  final String Function(T) dropdownItemAsString;
  final Function(T?)? onDropdownChanged;
  final Function(String)? onTextChanged;
  final Function(String)? onTextSubmitted;
  final T? initialDropdownValue;
  final bool dropdownIsExpanded;
  final bool textFieldObscure;
  final TextInputType? textFieldKeyboardType;
  final FocusNode? textFieldFocusNode;
  final bool centerText;
  final TextEditingController textFieldController;
  final FormFieldValidator<String>? validator;

  const RoundedDropdownAndTextField({
    Key? key,
    required this.dropdownHint,
    required this.textFieldHint,
    required this.totalWidth,
    required this.dropdownItems,
    required this.dropdownItemAsString,
    this.onDropdownChanged,
    this.onTextChanged,
    this.onTextSubmitted,
    this.initialDropdownValue,
    this.dropdownIsExpanded = true,
    this.textFieldObscure = false,
    this.textFieldKeyboardType,
    this.textFieldFocusNode,
    this.centerText = true,
    required this.textFieldController,
    this.validator,
  }) : super(key: key);

  @override
  _RoundedDropdownAndTextFieldState<T> createState() =>
      _RoundedDropdownAndTextFieldState<T>();
}

class _RoundedDropdownAndTextFieldState<T>
    extends State<RoundedDropdownAndTextField<T>> {
  @override
  Widget build(BuildContext context) {
    // Calcular el ancho de cada componente basado en el total
    double dropdownWidth = widget.totalWidth * 0.3; // 40% para el dropdown
    double textFieldWidth = widget.totalWidth * 0.7; // 60% para el textfield
    const margin = EdgeInsets.all(0);
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: ColorPalette.white),
        // color: ColorPalette.white,
      ),
      width: widget.totalWidth,
      child: Row(
        children: [
          // Dropdown
          RoundedDropdown<T>(
            hintText: widget.dropdownHint,
            width: dropdownWidth,
            margin: margin,
            items: widget.dropdownItems,
            itemAsString: widget.dropdownItemAsString,
            onChanged: widget.onDropdownChanged,
            initialValue: widget.initialDropdownValue,
            isExpanded: widget.dropdownIsExpanded,
            center: widget.centerText,
            horizontal: 0,
            enableBoder: false,
          ),
          // Divider entre Dropdown y TextField (opcional)
          Container(
            color: Colors.white,
            height: 40,
            width: 1,
          ),
          // TextField
          RoundedTextField(
              margin: margin,
              controller: widget.textFieldController,
              hintText: widget.textFieldHint,
              width: textFieldWidth - 10, // Ajuste por el padding del dropdown
              onChanged: widget.onTextChanged,
              onSubmitted: widget.onTextSubmitted,
              center: widget.centerText,
              obscureText: widget.textFieldObscure,
              keyboardType: widget.textFieldKeyboardType,
              focusNode: widget.textFieldFocusNode,
              enableBoder: false),
        ],
      ),
    );
  }
}
