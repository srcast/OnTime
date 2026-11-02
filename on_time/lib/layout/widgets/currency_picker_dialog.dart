import 'package:country_currency_pickers/countries.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:on_time/helpers/generic_helper.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/utils/labels.dart';

class CurrencyPickerDialog extends StatefulWidget {
  const CurrencyPickerDialog({super.key, required this.selectedCurrencyCode});

  final String selectedCurrencyCode;

  // returns the currency code picked, null if closed
  static Future<String?> show(
    BuildContext context, {
    required String selectedCurrencyCode,
  }) {
    return showDialog<String>(
      context: context,
      builder:
          (_) =>
              CurrencyPickerDialog(selectedCurrencyCode: selectedCurrencyCode),
    );
  }

  @override
  State<CurrencyPickerDialog> createState() => _CurrencyPickerDialogState();
}

class _Currency {
  const _Currency(this.code, this.name, this.countries);

  final String code;
  final String name;
  final List<String> countries;

  bool matches(String query) =>
      code.toLowerCase().contains(query) ||
      name.toLowerCase().contains(query) ||
      countries.any((c) => c.toLowerCase().contains(query));
}

class _CurrencyPickerDialogState extends State<CurrencyPickerDialog> {
  late final List<_Currency> _currencies = _buildCurrencies();
  String _query = '';

  // one entry per currency (countryList has one per country -> EUR repeated)
  static List<_Currency> _buildCurrencies() {
    final byCode = <String, _Currency>{};

    for (final country in countryList) {
      final code = country.currencyCode;
      if (code.isNullOrEmpty) continue;

      final current = byCode[code!];
      byCode[code] = _Currency(
        code,
        current?.name ?? country.currencyName ?? code,
        [...?current?.countries, if (country.name != null) country.name!],
      );
    }

    return byCode.values.toList()..sort((a, b) => a.code.compareTo(b.code));
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _currencies.where((c) => c.matches(_query.toLowerCase())).toList();

    return AlertDialog(
      title: Text(Labels.currency.tr()),
      contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: Labels.currencySearch.tr(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  filtered.isEmpty
                      ? Center(child: Text(Labels.currencyNotFound.tr()))
                      : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final currency = filtered[index];
                          final selected =
                              currency.code == widget.selectedCurrencyCode;

                          return ListTile(
                            title: Text(
                              '${currency.code} - ${currency.name}',
                              style: TextStyle(
                                color: context.colors.defaultText,
                                fontWeight:
                                    selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            trailing:
                                selected
                                    ? Icon(
                                      Icons.check,
                                      color: context.colors.focusColor,
                                    )
                                    : null,
                            onTap: () => Navigator.pop(context, currency.code),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Labels.cancel.tr()),
        ),
      ],
    );
  }
}
