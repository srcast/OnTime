import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_time/utils/colors.dart';
import 'package:on_time/utils/labels.dart';

class NumericKeyboard extends StatefulWidget {
  final String value;
  final Function(double value) onSetValue;

  const NumericKeyboard({
    super.key,
    required this.value,
    required this.onSetValue,
  });

  @override
  State<NumericKeyboard> createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  late String _value;
  String _valueStr = '';

  @override
  void initState() {
    super.initState();
    _value = widget.value == '0.0' ? '' : widget.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateValueStr();
  }

  void _onKeyTap(String key) {
    setState(() {
      if (key == '.') {
        if (!_value.contains('.')) _value += '.';
      } else {
        _value += key;
      }

      _updateValueStr();
    });
  }

  void _onClear() {
    setState(() {
      _value = '';
      _updateValueStr();
    });
  }

  void _updateValueStr() {
    if (_value == '') {
      _valueStr = _value;
    } else {
      _valueStr = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(),
      ).format(double.tryParse(_value));
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSubmit() {
    var parsedVal = double.tryParse(_value);
    widget.onSetValue(parsedVal ?? 0);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'C'];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, // ⬅️ Altera aqui para a cor que quiseres
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _valueStr,
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
                  backgroundColor: AppColors.backgroundLightGray,
                  foregroundColor: AppColors.defaultText,
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
                  child: const Text(Labels.cancel),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _onSubmit(), //widget.onCancel,
                  child: const Text(Labels.ok),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
