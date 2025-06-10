import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:hr_app/Screens/DashboardScreen/Models/scheduleModel.dart';
import 'package:hr_app/Screens/DashboardScreen/Service/Controller.dart';
import 'package:hr_app/Screens/TimeLogDetailScreen/TimeLogDetailScreen.dart';
import 'package:hr_app/Screens/checkInScreen/checkinScreen.dart';
import 'package:intl/intl.dart';

class scheduleCard extends StatelessWidget {
  SheduleModel job;
  scheduleCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    List status = statusColor(job);
    return FadeInUp(
      child: InkWell(
        onTap: () {
          if (job.isFinished != true)
            Get.to(
              () => TimeClockScreen(job: job),
              transition: Transition.rightToLeft,
            );
          else {
            Get.to(
              () => TimeLogDetailsScreen(logId: job.scheduleLogs!.first.id!),
              transition: Transition.rightToLeft,
            );
          }
        },
        splashColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Job# - ${job.id}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff222831),
                    ),
                  ),
                  Spacer(),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: status[1]),
                      borderRadius: BorderRadius.circular(12.r),
                      color: status[3],
                    ),
                    child: Text(
                      status[0],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: status[2],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                DateFormat(
                  "dd MMM yyyy, EEE",
                ).format(DateTime.parse(job.startDate!).toLocal()),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff222831),
                ),
              ),
              SizedBox(height: 6.h),

              Row(
                children: [
                  CircleAvatar(
                    radius: 10.w,
                    backgroundColor: Color(0xffFFCEB0),
                    child: Icon(
                      Icons.login,
                      color: Color(0xffFF6000),
                      size: 10.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    job.startTime!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff222831),
                    ),
                  ),

                  SizedBox(width: 16.w),
                  CircleAvatar(
                    radius: 10.w,
                    backgroundColor: Color(0xffFEC8C3),
                    child: Icon(
                      Icons.login,
                      color: Color(0xffFC4C3C),
                      size: 10.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    job.endTime!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff222831),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Clock-in",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff222831),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        (job.scheduleLogs!.isEmpty ||
                                job.scheduleLogs!.first.clockInAt == null)
                            ? "--"
                            : DateFormat("hh:mm a").format(
                              DateTime.parse(
                                job.scheduleLogs!.first.clockInAt!,
                              ).toLocal(),
                            ),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff222831),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 100.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Clock-Out",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff222831),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        (job.scheduleLogs!.isEmpty ||
                                job.scheduleLogs!.first.clockOutAt == null)
                            ? "--"
                            : DateFormat("hh:mm a").format(
                              DateTime.parse(
                                job.scheduleLogs!.first.clockOutAt!,
                              ).toLocal(),
                            ),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff222831),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
