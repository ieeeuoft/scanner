import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class SpreadsheetProvider extends InheritedWidget {
  final Spreadsheet spreadsheet;

  const SpreadsheetProvider(
      {super.key, required this.spreadsheet,
        required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(SpreadsheetProvider oldWidget) =>
      oldWidget.spreadsheet != spreadsheet;

  static Spreadsheet? of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<SpreadsheetProvider>();
    return provider?.spreadsheet;
  }
}
