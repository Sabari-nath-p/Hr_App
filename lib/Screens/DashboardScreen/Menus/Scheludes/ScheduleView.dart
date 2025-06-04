import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/Home/components/scheduleCard.dart';
import 'package:hr_app/Screens/DashboardScreen/Service/Controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SheduleView extends StatelessWidget {
  SheduleView({super.key});
  HomeController hctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SmartRefresher(
        controller: hctrl.refreshCtrl1,
        onRefresh: () {
          hctrl.jobList.clear();
          hctrl.fetchShedules();
        },
        child: SingleChildScrollView(
          child: Column(
            spacing: 5.h,
            children: [
              SizedBox(height: 10.h),
              for (var data in hctrl.jobList) scheduleCard(job: data),
            ],
          ),
        ),
      ),
    );
  }
}
