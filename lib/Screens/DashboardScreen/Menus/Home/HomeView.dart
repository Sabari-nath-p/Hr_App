import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/Home/components/analyticsComponent.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/Home/components/scheduleCard.dart';
import 'package:hr_app/Screens/DashboardScreen/Service/Controller.dart';
import 'package:hr_app/utils/Colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Homeview extends StatelessWidget {
  Homeview({super.key});
  HomeController hctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primaryColor,
                child: Image.asset(
                  "Asset/images/logo.png",
                  width: 20.h,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${hctrl.user.name!.capitalize}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${hctrl.user.role!.replaceAll("_", " ").capitalize}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(CupertinoIcons.bell),
            ],
          ),
          Expanded(
            child: SmartRefresher(
              controller: hctrl.refreshCtrl,
              onRefresh: () {
                hctrl.jobList.clear();
                hctrl.fetchShedules();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    homeAnalyticsHeader(),
                    SizedBox(height: 10.h),
                    for (var data in hctrl.jobList) scheduleCard(job: data),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
