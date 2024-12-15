import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerUi {
  DatePickerUi._privateConstructor();

  static final DatePickerUi _instance = DatePickerUi._privateConstructor();

  factory DatePickerUi() {
    return _instance;
  }

  Future<DateTime?> datePicker({
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
    DateTime? currentDate,
    String? helpText,
  }) async {
    return await showDatePicker(
        context: Get.context!,
        // helpText: helpText,
        currentDate: currentDate,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ??
            DateTime.now().subtract(
              const Duration(days: 765),
            ),
        lastDate: lastDate ?? DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData(primarySwatch: Colors.blueGrey),
            child: child!,
          );
        });
  }

  Future<DateTimeRange?> dateRangePicker({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final picked = await showDateRangePicker(
        context: Get.context!,
        initialDateRange: DateTimeRange(
          start: fromDate ?? DateTime.now().add(const Duration(days: -30)),
          end: toDate ?? DateTime.now(),
        ),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData(primarySwatch: Colors.blueGrey),
            child: child!,
          );
        });

    // if (picked != null) {
    //   var dataTime = DateTime.now().add(Duration(days: -30));
    //   AppUtil.printData(
    //     'last: ${dataTime.day}-${dataTime.month}-${dataTime.year}',
    //   );
    //   AppUtil.printData('now: ${DateTime.now()}');
    //   AppUtil.printData('picked: ${picked.start} ${picked.end}');
    //
    //   dTime.add(picked.start);
    //   dTime.add(picked.end);
    // }

    return picked;
  }
}
