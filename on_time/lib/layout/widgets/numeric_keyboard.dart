import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/utils/labels.dart';

class NumericKeyboard extends StatefulWidget {
  final String value;

  const NumericKeyboard({super.key, required this.value});

  static Future<double?> show(BuildContext context, {required String value}) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.tabBarBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 24,
            left: 16,
            right: 16,
          ),
          child: NumericKeyboard(value: value),
        );
      },
    );
  }

  @override
  State<NumericKeyboard> createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  late String _value;
  int decPoints = 0;
  bool insertPoint = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_value != '0.0') {
      var decimals = _value.split('.');

      decPoints = decimals.length > 1 ? decimals[1].length : 0;
    }
  }

  void _onKeyTap(String key) {
    setState(() {
      if (decPoints < 2) {
        if (key == '.') {
          if (!_value.contains('.')) {
            insertPoint = true;
          }
        } else {
          if (_value == '0.0') {
            _value = key;
          } else {
            if (insertPoint) {
              ++decPoints;
              _value += '.$key';
              insertPoint = false;
            } else {
              decPoints = decPoints > 0 ? ++decPoints : decPoints;
              _value += key;
            }
          }
        }
      }
    });
  }

  void _onClear() {
    setState(() {
      _value = '0.0';
      decPoints = 0;
      insertPoint = false;
    });
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSubmit() {
    var parsedVal = double.tryParse(_value);
    Navigator.pop(context, parsedVal ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'C'];

    return Container(
      decoration: BoxDecoration(
        color: context.colors.tabBarBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            GenericHelper.getCurrencyFormat(
              double.tryParse(_value) ?? 0,
              decDigits: decPoints,
            ),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            itemCount: keys.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 60,
            ),
            itemBuilder: (context, index) {
              final key = keys[index];

              return ElevatedButton(
                onPressed: () {
                  if (key == 'C') {
                    _onClear();
                  } else {
                    _onKeyTap(key);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.scaffoldBackground,
                  foregroundColor: context.colors.defaultText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(key, style: const TextStyle(fontSize: 24)),
              );
            },
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _onCancel(), //widget.onCancel,
                  child: Text(
                    Labels.cancel.tr(),
                    style: TextStyle(color: context.colors.actionsText),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _onSubmit(), //widget.onCancel,
                  child: Text(
                    Labels.ok.tr(),
                    style: TextStyle(color: context.colors.actionsText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
