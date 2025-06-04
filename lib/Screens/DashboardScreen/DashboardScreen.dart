import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/Home/HomeView.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/Payroll/PayrollView.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/Scheludes/ScheduleView.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/profile/ProfileView.dart';
import 'package:hr_app/Screens/DashboardScreen/Service/Controller.dart';
import 'package:hr_app/utils/Colors.dart';
import 'package:hr_app/utils/CustomBottombar.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  HomeController hctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (__) {
        return Scaffold(
          appBar:
              hctrl.selectedMenu != 0
                  ? AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        __.selectedMenu = 0;
                        __.update();
                      },
                    ),
                    title: Text(
                      __.selectedMenu == 3
                          ? 'Profile'
                          : (__.selectedMenu == 2)
                          ? "Payroll"
                          : "Schedule",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    centerTitle: true,
                    actions: [Icon(CupertinoIcons.bell), SizedBox(width: 20.w)],
                  )
                  : null,
          bottomNavigationBar: customBottomBar(
            selected: hctrl.selectedMenu,
            onTap: (value) {
              hctrl.selectedMenu = value;
              hctrl.update();
            },
          ),
          body: SafeArea(
            child:
                __.inLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                    : Column(
                      children: [
                        if (hctrl.selectedMenu == 0)
                          Expanded(child: Homeview()),
                        if (hctrl.selectedMenu == 1)
                          Expanded(child: SheduleView()),
                        if (hctrl.selectedMenu == 3)
                          Expanded(child: ProfileScreen()),
                        if (hctrl.selectedMenu == 2)
                          Expanded(child: WorkSummaryScreen()),
                      ],
                    ),
          ),
        );
      },
    );
  }
}
