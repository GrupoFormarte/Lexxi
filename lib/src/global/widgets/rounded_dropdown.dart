import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class RoundedDropdown<T> extends StatefulWidget {
  final String hintText;
  final double width;
  final bool isExpanded;
  final bool enableBoder;
  final List<T> items;
  final String Function(T) itemAsString;
  final Function(T?)? onChanged;
  final T? initialValue;
  final bool center;
  final EdgeInsets margin;
  final double horizontal;
  final FormFieldValidator<T>? validator;

  const RoundedDropdown(
      {Key? key,
      required this.hintText,
      required this.width,
      required this.items,
      required this.itemAsString,
      this.onChanged,
      this.initialValue,
      this.isExpanded = true,
      this.center = true,
      this.margin = const EdgeInsets.all(8),
      this.validator,
      this.enableBoder = true,
      this.horizontal = 16})
      : super(key: key);

  @override
  _RoundedDropdownState<T> createState() => _RoundedDropdownState<T>();
}

class _RoundedDropdownState<T> extends State<RoundedDropdown<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: widget.margin,
      padding: EdgeInsets.symmetric(horizontal: widget.horizontal),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: ColorPalette.primary,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<T>(
            isExpanded: widget.isExpanded,
            value: selectedValue,
            validator: widget.validator,
            hint: Text(
              widget.hintText,
              style: const TextStyle(color: AppColors.white, fontSize: 15),
              textAlign: TextAlign.start,
            ),
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
            decoration: InputDecoration(
              fillColor: ColorPalette.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                    color: widget.enableBoder
                        ? Colors.white
                        : ColorPalette.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                    color: widget.enableBoder
                        ? Colors.white
                        : ColorPalette.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(
                    color: widget.enableBoder
                        ? Colors.white
                        : ColorPalette.primary,
                    width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            items: widget.items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  widget.itemAsString(item),
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }).toList(),
            onChanged: (T? newValue) {
              setState(() {
                selectedValue = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            dropdownColor: ColorPalette.primary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
