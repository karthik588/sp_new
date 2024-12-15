import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../functions/dashboard_function.dart';
import '../../../global/app_string.dart';
import '../../widgets/loadingPrompt.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    DashboardFunction().fetchAllNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          title: Text(AppString().notification),
        ),
        body: SafeArea(
          bottom: true,
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DashboardFunction().isNotificationLoading.value
                  ? Center(
                      child: LoadingPrompt().customProgressBar(
                          isLoading:
                              DashboardFunction().isNotificationLoading.value),
                    )
                  : Column(children: [
                      _notifications(),
                      const SizedBox(
                        height: 15,
                      )
                    ]),
            ),
          ),
        ));
  }

  Widget _notifications() {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          top: 20,
        ),
        decoration: Shapes()
            .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
        child: _list(),
      ),
    );
  }

  Widget _list() {
    return DashboardFunction().allNotificationList.isEmpty
        ? const Center(child: Text('No Data Found'))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: DashboardFunction().allNotificationList.length,
            itemBuilder: (context, index) {
              return ListTile(
                  minVerticalPadding: 0,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          DashboardFunction()
                                  .allNotificationList[index]
                                  .title ??
                              "-",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: AppColors.onBg,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          DashboardFunction().allNotificationList[index].date !=
                                  null
                              ? timeago.format(
                                  DashboardFunction()
                                      .allNotificationList[index]
                                      .date!,
                                  locale: 'en',
                                  allowFromNow: true)
                              : '-',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.right,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                color: AppColors.onBg.withOpacity(0.9),
                              ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        DashboardFunction()
                                .allNotificationList[index]
                                .description ??
                            '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: AppColors.onBg.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: AppColors.onBg.withOpacity(0.2),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  dense: false);
            },
          );
  }
}
