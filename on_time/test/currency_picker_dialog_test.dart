import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_time/layout/themes.dart';
import 'package:on_time/layout/widgets/currency_picker_dialog.dart';

void main() {
  testWidgets('Seletor de moeda: uma entrada por moeda e pesquisa por pais', (
    tester,
  ) async {
    String? picked;

    await tester.pumpWidget(
      MaterialApp(
        theme: lightTheme,
        home: Builder(
          builder:
              (context) => TextButton(
                onPressed: () async {
                  picked = await CurrencyPickerDialog.show(
                    context,
                    selectedCurrencyCode: 'USD',
                  );
                },
                child: const Text('open'),
              ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // EUR is the currency of many countries -> only once
    await tester.enterText(find.byType(TextField), 'eur');
    await tester.pumpAndSettle();
    expect(find.textContaining('EUR -'), findsOneWidget);

    // by country name, case insensitive
    await tester.enterText(find.byType(TextField), 'Portugal');
    await tester.pumpAndSettle();
    expect(find.textContaining('EUR -'), findsOneWidget);

    await tester.tap(find.textContaining('EUR -'));
    await tester.pumpAndSettle();
    expect(picked, 'EUR');
  });
}
