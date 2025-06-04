import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/profile/components/DeleteAccountPopup.dart';
import 'package:hr_app/Screens/DashboardScreen/Menus/profile/components/logoutPopup.dart';
import 'package:hr_app/Screens/DashboardScreen/Service/Controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User details
  String? id = "USR001";
  String? email = "john.doe@company.com";
  String? name = "John Doe";
  String? role = "Field Worker";
  String? employeeId = "EMP12345";
  String? companyId = "COMP789";

  HomeController hctrl = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    id = hctrl.user.id;
    email = hctrl.user.email;
    name = hctrl.user.name;
    role = hctrl.user.role!.replaceAll("_", " ").capitalizeFirst;
    employeeId = hctrl.user.employeeId;
    companyId = hctrl.user.companyId;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Profile Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: const Color(0xFF2D5F3F),
                    child: Text(
                      name?.isNotEmpty == true ? name![0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // User Name
                  Text(
                    name ?? 'N/A',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // User Role
                  Text(
                    role ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // User Details
                  _buildDetailRow('Email', email ?? 'N/A'),
                  SizedBox(height: 12.h),
                  // _buildDetailRow('Employee ID', employeeId ?? 'N/A'),
                  // SizedBox(height: 12.h),
                  _buildDetailRow('Company ID', companyId ?? 'N/A'),
                  SizedBox(height: 12.h),
                  // _buildDetailRow('User ID', id ?? 'N/A'),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Options Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOptionTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildOptionTile(
                    icon: Icons.description_outlined,
                    title: 'Terms and Conditions',
                    onTap: () => _showTermsAndConditions(),
                  ),
                  _buildDivider(),
                  _buildOptionTile(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    titleColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () => Get.dialog(DeleteAccountDialog()),
                  ),
                  _buildDivider(),
                  _buildOptionTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    titleColor: Colors.orange,
                    iconColor: Colors.orange,
                    onTap: () => Get.dialog(LogoutpopupView()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(': ', style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: iconColor ?? Colors.grey[700]),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 24.w,
      endIndent: 24.w,
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            'Change Password',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Would you like to change your password?',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to change password screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5F3F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            'Terms and Conditions',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Text(
              'Here are the terms and conditions for using this application...\n\nBy using this app, you agree to our privacy policy and terms of service.',
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5F3F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }
}
