import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:hr_app/Screens/AuthenticationScreen/Service/controller.dart';
import 'package:hr_app/Screens/DashboardScreen/DashboardScreen.dart';
import 'package:hr_app/utils/Colors.dart';

class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({super.key});
  AuthController ctrl = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: GetBuilder<AuthController>(
            builder: (__) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.h),
                    Image.asset("Asset/images/logo.png", height: 80.h),
                    SizedBox(height: 40.h),
                    Text.rich(
                      TextSpan(
                        text: "Welcome Back 👋 \nto ",
                        children: [
                          TextSpan(
                            text: "HR Attendee",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 28.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Hello there, login to continue",
                      style: TextStyle(
                        //   fontWeight: FontWeight.w700,
                        color: Colors.black45,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextField(
                      controller: __.emailControllre,
                      decoration: InputDecoration(labelText: "Email Address"),
                    ),
                    SizedBox(height: 15.h),
                    TextField(
                      controller: __.passwordController,
                      obscureText: !__.isObscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: InkWell(
                          onTap: () {
                            __.isObscure = !__.isObscure;
                            __.update();
                          },
                          child: Icon(
                            (__.isObscure)
                                ? Icons.visibility
                                : Icons.visibility_off,

                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password ?",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        __.tryLogin();
                      },
                      child:
                          (__.isloading)
                              ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                                constraints: BoxConstraints(
                                  minHeight: 20.w,
                                  minWidth: 20.w,
                                ),
                              )
                              : Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
