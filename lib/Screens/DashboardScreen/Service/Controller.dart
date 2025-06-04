import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hr_app/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:hr_app/Screens/DashboardScreen/Models/UserModel.dart';
import 'package:hr_app/Screens/DashboardScreen/Models/scheduleModel.dart';
import 'package:hr_app/utils/CustomAlerts.dart';
import 'package:hr_app/utils/apiHandler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  bool inLoading = false;
  bool loading = false;
  int selectedMenu = 0;
  RefreshController refreshCtrl = RefreshController();
  int completed = 0;
  RefreshController refreshCtrl1 = RefreshController();
  List<SheduleModel> jobList = [];

  late UserModel user;

  fetchUser() async {
    inLoading = true;
    update();
    await ApiService.request(
      endpoint: "/auth/me",
      method: Api.GET,
      onSuccess: (data) {
        if (data.statusCode == 200 || data.statusCode == 201) {
          user = UserModel.fromJson(data.data);
          print(user.toJson());
        } else {
          Get.offAll(
            () => AuthenticationScreen(),
            transition: Transition.leftToRight,
          );
          Customalerts.errorAlert(
            title: "Login Expired",
            body: "Please Login again to continue",
          );
        }
      },
    );
    inLoading = false;
    update();
  }

  fetchShedules() async {
    completed = 0;
    await ApiService.request(
      endpoint: "/schedules/employee",
      method: Api.GET,
      onSuccess: (data) {
        for (var job in data.data["schedules"]) {
          SheduleModel model = SheduleModel.fromJson(job);
          if (model.isFinished == true) completed++;
          jobList.add(model);
        }
      },
    );
    update();
    refreshCtrl.refreshCompleted();
    refreshCtrl1.refreshCompleted();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUser();
    fetchShedules();
  }
}

List statusColor(SheduleModel job) {
  List<dynamic> temp = [];
  if (job.isFinished == true) {
    temp.add("Completed");
    temp.add(Color(0xff148833));

    temp.add(Color(0xff148833));
    temp.add(Color(0xffE7FFED));
  } else if (job.scheduleLogs!.isNotEmpty) {
    temp.add("Active");
    temp.add(Color(0xffFDE68A));

    temp.add(Color(0xffB4540A));
    temp.add(Color(0xffFFFBEB));
  } else {
    temp.add("Started");
    temp.add(Color(0xffFC4C3C));
    temp.add(Color(0xffFC4C3C));

    temp.add(Color(0xffFFB08033).withOpacity(.2));
  }

  return temp;
}
