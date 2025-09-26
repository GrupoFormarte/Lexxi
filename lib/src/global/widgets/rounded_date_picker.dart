import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:intl/intl.dart';

class RoundedDatePicker extends StatefulWidget {
  final String hintText;
  final double width;
  final bool center;
  final Function(DateTime)? onDateSelected;
  final FormFieldValidator<String>? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool isReadOnly;

  const RoundedDatePicker({
    Key? key,
    required this.hintText,
    required this.width,
    required this.validator,
    this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.center = true,
    this.isReadOnly = true,
  }) : super(key: key);

  @override
  _RoundedDatePickerState createState() => _RoundedDatePickerState();
}

class _RoundedDatePickerState extends State<RoundedDatePicker> {
  DateTime? selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    if (selectedDate != null) {
      _controller.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = selectedDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate!,
      lastDate: widget.lastDate!,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.blueDark,
            colorScheme: ColorScheme.light(
              primary: AppColors.blueDark,
              onPrimary: Colors.white,
              surface: Colors.grey[200]!,
              onSurface: AppColors.blueDark,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isReadOnly
          ? () => _selectDate(context)
          : null, // Solo abre el selector si es de solo lectura
      child: AbsorbPointer(
        absorbing: widget.isReadOnly,
        child: Container(
          width: widget.width,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.grey[200],
          ),
          child: TextFormField(
            controller: _controller,
            readOnly: widget.isReadOnly,
            validator: widget.validator,
            style: const TextStyle(color: AppColors.white, fontSize: 15),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: Colors.red),
              ),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: AppColors.white),
              fillColor: ColorPalette.primary,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              // suffixIcon:
              //     const Icon(Icons.calendar_today, color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
