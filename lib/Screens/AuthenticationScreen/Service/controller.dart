import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_app/Screens/DashboardScreen/DashboardScreen.dart';
import 'package:hr_app/Screens/DashboardScreen/Service/Controller.dart';
import 'package:hr_app/utils/CustomAlerts.dart';
import 'package:hr_app/utils/apiHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  TextEditingController emailControllre = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = false;
  bool isloading = false;

  void tryLogin() async {
    if (emailControllre.text.isEmpty) {
      Customalerts.successAlert(
        title: "Missing Field",
        body: "Email is required",
      );
      return;
    } else if (passwordController.text.isEmpty) {
      Customalerts.successAlert(
        title: "Missing Field",
        body: "Email is required",
      );
      return;
    }
    isloading = true;
    update();
    final Response = await http.post(
      Uri.parse(ApiService.baseUrl + "/auth/login"),
      body: {
        "email": emailControllre.text,
        "password": passwordController.text,
      },
    );
    print(Response.body);
    print(Response.statusCode);
    if (Response.statusCode == 200 || Response.statusCode == 201) {
      var data = json.decode(Response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("AUTHKEY", data["access_token"]);
      pref.setString("STATUS", "IN");
      Get.delete<HomeController>();

      Get.off(() => DashboardScreen(), transition: Transition.rightToLeft);
    } else {
      Customalerts.errorAlert(
        title: "Invalid Credentials",
        body: "Please login with valid email and password",
      );
    }
    // await ApiService.request(
    //   endpoint: "/auth/login",
    //   //headers: {"app-type": "employee"},
    //   requiresAuth: false,
    //   body: {
    //     "email": emailControllre.text,
    //     "password": passwordController.text,
    //   },

    //   onSuccess: (data) async {
    //     print(data.statusCode);
    //     if (data.statusCode == 200 || data.statusCode == 201) {
    //       SharedPreferences pref = await SharedPreferences.getInstance();
    //       pref.setString("AUTHKEY", data.data["access_token"]);
    //       pref.setString("STATUS", "IN");
    //       Get.delete<HomeController>();

    //       Get.off(() => DashboardScreen(), transition: Transition.rightToLeft);
    //     } else {
    //       // Customalerts.errorAlert(
    //       //   title: "Invalid Credentials",
    //       //   body: "Please login with valid email and password",
    //       // );
    //     }
    //   },
    // );
    isloading = false;
    update();
  }
}
