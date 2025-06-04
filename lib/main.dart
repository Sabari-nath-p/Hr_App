import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hr_app/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:hr_app/Screens/DashboardScreen/DashboardScreen.dart';
import 'package:hr_app/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

String _login = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  _login = pref.getString("STATUS") ?? "";
  print(pref.getString("AUTHKEY"));
  print(_login);
  runApp(hrApp());
}

class hrApp extends StatelessWidget {
  const hrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 850),
      builder: (context, size) {
        return ToastificationWrapper(
          child: GetMaterialApp(
            color: AppColors.primaryColor,
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xffFBFBFB),
              fontFamily: "dm",
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,

                centerTitle: true,
              ),

              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  //   borderSide: BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                labelStyle: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: AppColors.primaryColor),
                //   borderRadius: BorderRadius.circular(8.r),
                // ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),

              primaryColor: AppColors.primaryColor,

              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      //side: BorderSide(color: Colors.red),
                    ),
                  ),
                  minimumSize: WidgetStateProperty.all(
                    Size(double.infinity, 48),
                  ),

                  textStyle: WidgetStatePropertyAll(
                    TextStyle(
                      fontFamily: "dm",
                      fontSize: 16.w,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  backgroundColor: WidgetStatePropertyAll(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            home: (_login == "IN") ? DashboardScreen() : AuthenticationScreen(),
          ),
        );
      },
    );
  }
}
