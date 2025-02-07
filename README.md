# BGSearchableDropDown

A Flutter widget that provides a searchable dropdown list with customization options.

## Features
- Searchable dropdown with filtering functionality
- Customizable border, text style, and dropdown icon
- Clear selection option
- Overlay-based dropdown positioning

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  bg_searchable_dropdown:
    path: path_to_your_local_package  # Change this if publishing to pub.dev
```

## Usage

### **Basic Example**

```dart
import 'package:flutter/material.dart';
import 'package:bg_searchable_dropdown/bg_searchable_dropdown.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Searchable Dropdown Example")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BGSearchableDropDown(
              items: ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'],
              hint: 'Select a fruit',
              clearOptionText: 'Clear Selection',
              onChanged: (value) {
                print("Selected: $value");
              },
            ),
          ),
        ),
      ),
    );
  }
}
```

## Properties

| Property            | Type                 | Default Value       | Description |
|--------------------|--------------------|-------------------|-------------|
| `items`            | `List<String>`      | `[]`              | List of items to display in the dropdown |
| `hint`             | `String`            | `''`              | Placeholder text when no item is selected |
| `clearOptionText`  | `String`            | `'Clear'`         | Text for the clear selection button |
| `onChanged`        | `Function(String?)` | `required`        | Callback when an item is selected or cleared |
| `borderColor`      | `Color`             | `Colors.grey`     | Border color of the dropdown |
| `borderRadius`     | `double`            | `8.0`             | Border radius of the dropdown |
| `dropdownHeight`   | `double`            | `300.0`           | Height of the dropdown overlay |
| `dropdownIcon`     | `Icon`              | `Icons.arrow_drop_down` | Dropdown icon |
| `showClearButton`  | `bool`              | `true`            | Whether to show the clear selection button |
| `textStyle`        | `TextStyle`         | `TextStyle(fontSize: 16)` | Style for the dropdown text |
| `searchLabelText`  | `String?`           | `'Search...'`     | Label text for the search field |

## License
This package is open-source. Feel free to contribute or modify it as needed.

