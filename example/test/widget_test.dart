import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';

void main() {
  testWidgets('Dropdown closes and updates label on item selection in menuMode', (WidgetTester tester) async {
    // Set a larger surface size to ensure the dropdown menu items are within viewport bounds
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(800, 1000));

    final listToSearch = [
      {'name': 'Amir', 'class': 12},
      {'name': 'Raza', 'class': 11},
    ];

    String? selectedClass;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              CustomSearchableDropDown(
                menuMode: true,
                hideSearch: false,
                items: listToSearch,
                label: 'Select Name',
                dropDownMenuItems: listToSearch.map((item) => item['name']).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedClass = value['class'].toString();
                  } else {
                    selectedClass = null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );

    // Verify initial label is shown
    expect(find.text('Select Name'), findsOneWidget);

    // Tap to open the menu
    await tester.tap(find.text('Select Name'));
    await tester.pumpAndSettle();

    // Verify search bar is visible (meaning menu is open)
    expect(find.text('Search Here...'), findsOneWidget);

    // Tap on the first item "Amir" to select it
    await tester.tap(find.text('Amir'));
    await tester.pumpAndSettle();

    // Verify that the menu is closed (search bar is gone)
    expect(find.text('Search Here...'), findsNothing);

    // Verify that the label is updated to "Amir"
    expect(find.text('Amir'), findsOneWidget);
    expect(selectedClass, '12');
  });
}
