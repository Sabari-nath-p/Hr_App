import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_app/utils/Colors.dart';
import 'package:hr_app/utils/apiHandler.dart';
import 'package:intl/intl.dart';

// Work Summary Model
class WorkSummaryModel {
  final int totalDurationWorked;
  final int totalDurationOvertime;
  final double totalPayWorked;
  final double totalPayOvertime;
  final int paidCount;
  final int notPaidCount;

  WorkSummaryModel({
    required this.totalDurationWorked,
    required this.totalDurationOvertime,
    required this.totalPayWorked,
    required this.totalPayOvertime,
    required this.paidCount,
    required this.notPaidCount,
  });

  factory WorkSummaryModel.fromJson(Map<String, dynamic> json) {
    return WorkSummaryModel(
      totalDurationWorked: json['total_duration_worked'] ?? 0,
      totalDurationOvertime: json['total_duration_overtime'] ?? 0,
      totalPayWorked: (json['total_pay_worked'] ?? 0.0).toDouble(),
      totalPayOvertime: (json['total_pay_overtime'] ?? 0.0).toDouble(),
      paidCount: json['paid_count'] ?? 0,
      notPaidCount: json['not_paid_count'] ?? 0,
    );
  }

  // Convert minutes to hours and minutes format
  String formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    } else {
      return '${mins}m';
    }
  }

  // Get total hours worked
  double get totalHoursWorked => totalDurationWorked / 60.0;

  // Get total overtime hours
  double get totalOvertimeHours => totalDurationOvertime / 60.0;

  // Get total pay
  double get totalPay => totalPayWorked + totalPayOvertime;

  // Get total worked sessions
  int get totalSessions => paidCount + notPaidCount;
}

class WorkSummaryScreen extends StatefulWidget {
  final String? employeeId;
  final DateTime? startDate;
  final DateTime? endDate;

  const WorkSummaryScreen({
    Key? key,
    this.employeeId,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  State<WorkSummaryScreen> createState() => _WorkSummaryScreenState();
}

class _WorkSummaryScreenState extends State<WorkSummaryScreen> {
  WorkSummaryModel? workSummary;
  bool pageLoading = true;
  DateTime selectedStartDate = DateTime.now().subtract(Duration(days: 30));
  DateTime selectedEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.startDate != null) selectedStartDate = widget.startDate!;
    if (widget.endDate != null) selectedEndDate = widget.endDate!;
    fetchWorkSummary();
  }

  fetchWorkSummary() async {
    setState(() {
      pageLoading = true;
    });

    await ApiService.request(
      endpoint: "/time-sheets/stats", // Replace with your actual endpoint
      method: Api.GET,

      onSuccess: (data) {
        print(data.data);
        workSummary = WorkSummaryModel.fromJson(data.data);
        setState(() {
          pageLoading = false;
        });
      },
      onError: (error) {
        // For demo purposes, using the provided sample data
        workSummary = WorkSummaryModel(
          totalDurationWorked: 960,
          totalDurationOvertime: 60,
          totalPayWorked: 2903.2,
          totalPayOvertime: 216.78,
          paidCount: 1,
          notPaidCount: 0,
        );
        setState(() {
          pageLoading = false;
        });
      },
    );
  }

  Future<void> _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: selectedStartDate,
        end: selectedEndDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF2D5F3F),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedStartDate = picked.start;
        selectedEndDate = picked.end;
      });
      fetchWorkSummary();
    }
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusCard() {
    if (workSummary == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.payment_outlined,
                  color: Colors.blue[600],
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${workSummary!.paidCount}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Paid Sessions',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${workSummary!.notPaidCount}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange[700],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Pending Sessions',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.orange[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // backgroundColor: Colors.grey[50],
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     'Work Summary',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 18.sp,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.date_range_outlined,
      //         color: Colors.black,
      //         size: 24.sp,
      //       ),
      //       onPressed: _selectDateRange,
      //     ),
      //   ],
      // ),
      child:
          (pageLoading)
              ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 3,
                  constraints: BoxConstraints(minHeight: 40.w, minWidth: 40.w),
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Range Display
                    if (false)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4F0),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFF4A7C59).withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: const Color(0xFF4A7C59),
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${DateFormat("MMM dd, yyyy").format(selectedStartDate)} - ${DateFormat("MMM dd, yyyy").format(selectedEndDate)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4A7C59),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 24.h),

                    // Total Pay Card
                    if (workSummary != null)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF2D5F3F),
                              const Color(0xFF4A7C59),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2D5F3F).withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Total Earnings',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              '\$${workSummary!.totalPay.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${workSummary!.totalSessions} work sessions completed',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 20.h),

                    // Summary Cards Grid
                    if (workSummary != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              title: 'Work Hours',
                              value: workSummary!.formatDuration(
                                workSummary!.totalDurationWorked,
                              ),
                              subtitle:
                                  '${workSummary!.totalHoursWorked.toStringAsFixed(1)} hours',
                              color: Colors.blue[600]!,
                              icon: Icons.access_time_outlined,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildSummaryCard(
                              title: 'Overtime',
                              value: workSummary!.formatDuration(
                                workSummary!.totalDurationOvertime,
                              ),
                              subtitle:
                                  '${workSummary!.totalOvertimeHours.toStringAsFixed(1)} hours',
                              color: Colors.orange[600]!,
                              icon: Icons.schedule_outlined,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              title: 'Regular Pay',
                              value:
                                  '\$${workSummary!.totalPayWorked.toStringAsFixed(2)}',
                              subtitle: 'Base earnings',
                              color: Colors.green[600]!,
                              icon: Icons.attach_money_outlined,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildSummaryCard(
                              title: 'Extra Pay',
                              value:
                                  '\$${workSummary!.totalPayOvertime.toStringAsFixed(2)}',
                              subtitle: 'Additional earnings',
                              color: Colors.purple[600]!,
                              icon: Icons.trending_up_outlined,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Payment Status Card
                      _buildPaymentStatusCard(),

                      SizedBox(height: 20.h),

                      // Statistics Overview
                      Container(
                        padding: EdgeInsets.all(20.w),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.analytics_outlined,
                                    color: Colors.indigo[600],
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Quick Stats',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            _buildStatRow(
                              'Average Daily Hours',
                              '${(workSummary!.totalHoursWorked / 30).toStringAsFixed(1)}h',
                            ),
                            _buildStatRow(
                              'Overtime Percentage',
                              '${((workSummary!.totalOvertimeHours / workSummary!.totalHoursWorked) * 100).toStringAsFixed(1)}%',
                            ),
                            _buildStatRow(
                              'Average Hourly Rate',
                              '\$${(workSummary!.totalPay / (workSummary!.totalHoursWorked + workSummary!.totalOvertimeHours)).toStringAsFixed(2)}',
                            ),
                            _buildStatRow(
                              'Payment Completion',
                              '${((workSummary!.paidCount / workSummary!.totalSessions) * 100).toStringAsFixed(0)}%',
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 32.h),

                    // Refresh Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: fetchWorkSummary,
                        icon: Icon(Icons.refresh_outlined, size: 18.sp),
                        label: Text(
                          'Refresh Data',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5F3F),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
