import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hr_app/utils/Colors.dart';

Widget customBottomBar({int selected = 0, required Function(int) onTap}) {
  return Container(
    width: 390.w,
    height: 70.h,
    // margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 22.h),
    // padding: EdgeInsets.symmetric(horizontal: 26.5.w),
    decoration: BoxDecoration(
      //  borderRadius: BorderRadius.circular(18.r),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 17),
          blurRadius: 32,
          spreadRadius: 0,
          color: Colors.black.withOpacity(.1),
        ),
      ],
    ),
    child: Row(
      //spacing: 21.w,
      children: [
        GestureDetector(
          onTap: () {
            onTap(0);
          },
          child: Image.asset(
            "Asset/images/home.png",
            color: (selected == 0) ? AppColors.primaryColor : null,
            //  height: 40.h,
            width: 95.w,
          ),
        ),
        GestureDetector(
          onTap: () {
            onTap(1);
          },
          child: Image.asset(
            "Asset/images/Schedule.png",
            color: (selected == 1) ? AppColors.primaryColor : null,

            width: 95.w,
          ),
        ),
        GestureDetector(
          onTap: () {
            onTap(2);
          },
          child: Image.asset(
            "Asset/images/History.png",
            color: (selected == 2) ? AppColors.primaryColor : null,
            width: 95.w,
          ),
        ),
        GestureDetector(
          onTap: () {
            onTap(3);
          },
          child: Image.asset(
            "Asset/images/USer.png",
            color: (selected == 3) ? AppColors.primaryColor : null,
            width: 95.w,
          ),
        ),
      ],
    ),
  );
}
