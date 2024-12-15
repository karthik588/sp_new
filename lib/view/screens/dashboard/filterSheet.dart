import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/widgets/buttons.dart';
import 'package:swinpay/view/widgets/shapes.dart';

class FilterSheet {
  FilterSheet._privateConstructor();

  static final FilterSheet _instance = FilterSheet._privateConstructor();

  factory FilterSheet() {
    return _instance;
  }

  void show(
          {required RxList<String> selectedFilterVal,
          required Function onTapApply}) =>
      Get.bottomSheet(
          elevation: 0,
          isScrollControlled: false,
          backgroundColor: AppColors.card,
          _body(selectedFilterVal: selectedFilterVal, onTapApply: onTapApply),
          shape: Shapes().cardRoundedBorder(
            tl: 30,
            tr: 30,
          ));

  // RxList<String> selectedFilterVal = <String>[].obs;

  RxList<FilterModel> filterData = <FilterModel>[
    FilterModel(displayText: AppString().successful, value: '1'),
    FilterModel(displayText: AppString().failed, value: '2'),
    FilterModel(displayText: AppString().pending, value: '0')
  ].obs;

  void _init({required RxList<String> selectedFilterVal}) {
    //to clear old selected data
    for (var filter in filterData) {
      filter.isSelected = false;
    }
    if (selectedFilterVal.isEmpty) {
      filterData.first.isSelected = true;
    } else {
      for (var filter in filterData) {
        filter.isSelected = selectedFilterVal.contains(filter.value);
      }
    }
  }

  Widget _body(
      {required RxList<String> selectedFilterVal,
      required Function onTapApply}) {
    _init(selectedFilterVal: selectedFilterVal);
    AppUtil.printData('i am selected filter ${selectedFilterVal.toString()}');
    return Stack(
      children: [
        Container(
          height: 380,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text('Filter',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Obx(() => Flexible(
                      child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filterData.length,
                    itemBuilder: (context, index) => CheckboxListTile(
                      side: BorderSide(
                        color: AppColors.primary,
                        //your desire colour here
                        width: 1.5,
                      ),
                      activeColor: AppColors.primary,
                      checkColor: AppColors.onPrimary,
                      title: Text(filterData[index].displayText ?? '',
                          style: TextStyle(
                              color: AppColors.onBg.withOpacity(0.8),
                              fontWeight: FontWeight.w300)),
                      value: filterData[index].isSelected,
                      onChanged: (value) {
                        filterData[index].isSelected = value;
                        filterData.refresh();
                      },
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 0),
                  ))),
              Row(
                children: [
                  Expanded(
                      child: Buttons().outlinedBtn(
                          borderColor: Colors.yellow.shade200,
                          textColor: Colors.yellow.shade200,
                          radius: 10,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          buttonText: AppString().cancel,
                          onTap: () => _onTapCancel())),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Buttons().raisedButton(
                          radius: 10,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          buttonText: AppString().apply,
                          onTap: () => _onTapApply(
                              selectedFilterVal: selectedFilterVal,
                              onTapApply: onTapApply)))
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Positioned(
            top: 10,
            right: 8,
            child: Buttons().raisedButton(
                padding: const EdgeInsets.all(0),
                btnColor: AppColors.bg,
                textColor: AppColors.onBg,
                isCircleShape: true,
                icon: Icons.close,
                iconSize: 18,
                onTap: () => _onTapCancel()))
      ],
    );
  }

  void _onTapApply(
      {required RxList<String> selectedFilterVal,
      required Function onTapApply}) {
    if (_isSelected()) {
      Navigator.pop(Get.context!);
      selectedFilterVal.clear();
      for (var filter in filterData) {
        if (filter.isSelected!) {
          selectedFilterVal.add(filter.value!);
        }
      }
      onTapApply();
    }
  }

  void _onTapCancel() {
    if (_isSelected()) {
      Navigator.pop(Get.context!);
    }
  }

  bool _isSelected() {
    for (var filter in filterData) {
      if (filter.isSelected!) {
        return true;
      }
    }

    Get.showSnackbar(GetSnackBar(
      message: AppString().plzSelectThePaymentStatus,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      duration: const Duration(seconds: 2),
    ));

    return false;
  }

//   String? getSelectedStatusString({required RxList<String> selectedFilterVal}) {
//     dynamic selectedStatus;
//     selectedFilterVal.clear();
//     for (var filter in filterData) {
//       if (filter.isSelected!) {
//         if (selectedStatus != null) {
//           selectedStatus = selectedStatus + ',${filter.value}';
//         } else {
//           selectedStatus = filter.value;
//         }
//         selectedFilterVal.add(filter.value!);
//       }
//     }
//
//     return selectedStatus;
//   }
}

class FilterModel {
  String? displayText;
  String? value;
  bool? isSelected;

  FilterModel({this.displayText, this.value, this.isSelected}) {
    displayText = displayText ?? '';
    value = value ?? '';
    isSelected = isSelected ?? false;
  }
}
