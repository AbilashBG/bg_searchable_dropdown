import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bg_searchable_dropdown/bg_searchable_dropdown.dart';

void main() {
  testWidgets('BGSearchableDropDown displays and selects an item',
          (WidgetTester tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BGSearchableDropDown(
                items: ['Apple', 'Banana', 'Cherry'],
                hint: 'Select a fruit',
                clearOptionText: 'Clear Selection',
                onChanged: (value) {
                  selectedValue = value;
                },
              ),
            ),
          ),
        );

        // Verify hint is displayed
        expect(find.text('Select a fruit'), findsOneWidget);

        // Tap the dropdown to open it
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();

        // Verify items are displayed
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Cherry'), findsOneWidget);

        // Tap an item to select it
        await tester.tap(find.text('Banana'));
        await tester.pumpAndSettle();

        // Verify selection
        expect(selectedValue, 'Banana');
        expect(find.text('Banana'), findsOneWidget);
      });
}
