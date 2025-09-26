import 'package:flutter/material.dart';
import 'package:lexxi/infrastructure/auth/data_sources/local_data_source/localstorage_shared.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:lexxi/utils/loogers_custom.dart';
import 'package:sizer/sizer.dart';

class SelectedNumberQuestion extends StatefulWidget {
  final int numberSelected;

  final List<int> numbers;
  const SelectedNumberQuestion(
      {super.key, this.numberSelected = 10, this.numbers = const [10, 20, 30]});

  @override
  State<SelectedNumberQuestion> createState() => _SelectedNumberQuestionState();
}

class _SelectedNumberQuestionState extends State<SelectedNumberQuestion> {
  final ValueNotifier<int?> _valueNotifierNumber = ValueNotifier(null);
  final LocalstorageShared _localstorageShared = LocalstorageShared();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    final numb =
        await _localstorageShared.readFromSharedPref('numbesQuestion', int);

    _valueNotifierNumber.value = numb ?? widget.numberSelected;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: ValueListenableBuilder(
          valueListenable: _valueNotifierNumber,
          builder: (context, value, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.numbers.map((e) => btnSelected(e)).toList(),
            );
          }),
    );
  }

  Widget btnSelected(int number) {
    return GestureDetector(
      onTap: () async {
        _valueNotifierNumber.value = number;
        final numb =
            await _localstorageShared.readFromSharedPref('numbesQuestion', int);
        if (numb == null) {
          await _localstorageShared.addToSharedPref(
              key: 'numbesQuestion', value: number);
          return;
        }
        await _localstorageShared.updateDataInSharedPref(
            key: 'numbesQuestion', value: number);
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          // margin: const EdgeInsets.all(8),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: _valueNotifierNumber.value == number
                ? Border.all(
                    width: 1.0,
                    color: const Color(0xFF05F7F0).withOpacity(0.75),
                  )
                : null,
          ),
          child: Text(
            '$number',
            style: context.textTheme.titleLarge!
                .copyWith(color: blackToWhite(context)),
          )),
    );
  }
}
