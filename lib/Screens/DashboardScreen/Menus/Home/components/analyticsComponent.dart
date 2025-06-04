import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hr_app/Screens/DashboardScreen/Service/Controller.dart';

class homeAnalyticsHeader extends StatelessWidget {
  homeAnalyticsHeader({super.key});

  HomeController hctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _homeAnalyticsCard(
          title: "Open \nJobs",
          body: "${hctrl.jobList.length - hctrl.completed}",
          color1: Color(0xffFF6000),
          color2: Color(0xffFFEFE7),
        ),

        _homeAnalyticsCard(
          title: "Completed \nJob",
          body: "${hctrl.completed}",
          color1: Color(0xffE6B92B),
          color2: Color(0xffFFFAEA),
        ),
      ],
    );
  }
}

Widget _homeAnalyticsCard({
  required String title,
  required String body,
  required Color color1,
  required Color color2,
}) {
  return Container(
    height: 130.h,
    width: 165.w,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
    decoration: BoxDecoration(
      border: Border.all(color: color1),
      borderRadius: BorderRadius.circular(12.r),
      color: color2,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4.h),
        Text(
          body,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xffFF6000),
          ),
        ),
      ],
    ),
  );
}
