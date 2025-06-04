import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:hr_app/Screens/DashboardScreen/Models/scheduleModel.dart';
import 'package:hr_app/Screens/DashboardScreen/Service/Controller.dart';
import 'package:hr_app/utils/Colors.dart';
import 'package:hr_app/utils/CustomAlerts.dart';
import 'package:hr_app/utils/apiHandler.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Break Time Model
class BreakTimeEntry {
  final String id;
  final int scheduleId;
  final DateTime startTime;
  final DateTime endTime;
  final String? note;

  BreakTimeEntry({
    required this.id,
    required this.scheduleId,
    required this.startTime,
    required this.endTime,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'note': note,
    };
  }

  factory BreakTimeEntry.fromJson(Map<String, dynamic> json) {
    return BreakTimeEntry(
      id: json['id'],
      scheduleId: json['scheduleId'],
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
      note: json['note'],
    );
  }

  int getDurationInMinutes() {
    return endTime.difference(startTime).inMinutes;
  }
}

// Break Time Database Helper
// class BreakTimeDatabase {
//   static const String _keyPrefix = 'break_times_';

//   static Future<void> saveBreakTime(BreakTimeEntry breakTime) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String key = '${_keyPrefix}${breakTime.scheduleId}';

//     List<String> existingBreaks = prefs.getStringList(key) ?? [];
//     existingBreaks.add(jsonEncode(breakTime.toJson()));

//     await prefs.setStringList(key, existingBreaks);
//   }

//   static Future<List<BreakTimeEntry>> getBreakTimes(int scheduleId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String key = '${_keyPrefix}$scheduleId';

//     List<String> breakStrings = prefs.getStringList(key) ?? [];
//     return breakStrings.map((breakString) {
//       Map<String, dynamic> breakJson = jsonDecode(breakString);
//       return BreakTimeEntry.fromJson(breakJson);
//     }).toList();
//   }

// static Future<void> deleteBreakTime(int scheduleId, String breakId) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String key = '${_keyPrefix}$scheduleId';

//   List<String> existingBreaks = prefs.getStringList(key) ?? [];
//   existingBreaks.removeWhere((breakString) {
//     Map<String, dynamic> breakJson = jsonDecode(breakString);
//     return breakJson['id'] == breakId;
//   });

//   await prefs.setStringList(key, existingBreaks);
// }

//   // static Future<void> clearBreakTimes(int scheduleId) async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String key = '${_keyPrefix}$scheduleId';
//   //   await prefs.remove(key);
//   // }
// }

class TimeClockScreen extends StatefulWidget {
  SheduleModel job;
  TimeClockScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<TimeClockScreen> createState() => _TimeClockScreenState();
}

class _TimeClockScreenState extends State<TimeClockScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _breakNotesController = TextEditingController();
  DateTime? clock;
  List<BreakTimeEntry> breakTimes = [];
  int totalBreakMinutes = 0;

  int getTotalBreakMinutes() {
    int total = 0;
    for (var data in breakTimes) {
      total = total + data.getDurationInMinutes();
    }
    return total;
  }

  fetchCurrentTime() {
    ApiService.request(
      endpoint: "/current-time",
      method: Api.GET,
      onSuccess: (data) {
        print(data.data);
        clock = DateTime.parse(data.data["time"]).toLocal();
        setState(() {});
        pageLoading = false;
        startClock();
        // loadBreakTimes();
      },
    );
  }

  startClock() async {
    Timer.periodic(Duration(seconds: 1), (value) {
      clock = clock!.add(Duration(seconds: 1));
      setState(() {});
    });
  }

  // loadBreakTimes() async {
  //   breakTimes = await BreakTimeDatabase.getBreakTimes(widget.job.id!);
  //   totalBreakMinutes = await BreakTimeDatabase.getTotalBreakMinutes(
  //     widget.job.id!,
  //   );
  //   setState(() {});
  // }

  bool loading = false;
  bool pageLoading = true;

  // Updated Break time popup method
  void _showBreakTimeDialog() {
    DateTime? startTime;
    DateTime? endTime;
    DateTime now = clock ?? DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Break Time',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey[600],
                              size: 20.sp,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      Text(
                        'Select break start and end time',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Start Time Section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Break Start Time',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: now,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 1),
                                  ),
                                );

                                if (pickedDate != null) {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(now),
                                  );

                                  if (pickedTime != null) {
                                    startTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                    setDialogState(() {});
                                  }
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 12.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      startTime != null
                                          ? DateFormat(
                                            "MMM dd, yyyy - hh:mm a",
                                          ).format(startTime!)
                                          : "Select start time",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color:
                                            startTime != null
                                                ? Colors.black87
                                                : Colors.grey[500],
                                      ),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.grey[600],
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // End Time Section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Break End Time',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: () async {
                                DateTime initialDate = startTime ?? now;
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: startTime ?? DateTime(2020),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 1),
                                  ),
                                );

                                if (pickedDate != null) {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      startTime ?? now,
                                    ),
                                  );

                                  if (pickedTime != null) {
                                    endTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                    setDialogState(() {});
                                  }
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 12.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      endTime != null
                                          ? DateFormat(
                                            "MMM dd, yyyy - hh:mm a",
                                          ).format(endTime!)
                                          : "Select end time",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color:
                                            endTime != null
                                                ? Colors.black87
                                                : Colors.grey[500],
                                      ),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.grey[600],
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Show duration if both times are selected
                      if (startTime != null && endTime != null)
                        Container(
                          margin: EdgeInsets.only(top: 16.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.green[700],
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Duration: ${endTime!.difference(startTime!).inMinutes} minutes',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 16.h),

                      // Notes field
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Break Notes (Optional)',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              controller: _breakNotesController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                hintText: 'Add notes about this break...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14.sp,
                                ),
                                contentPadding: EdgeInsets.all(12.w),
                              ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Add Break Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              startTime != null &&
                                      endTime != null &&
                                      endTime!.isAfter(startTime!)
                                  ? () {
                                    _handleBreakTimeAdd(
                                      startTime!,
                                      endTime!,
                                      _breakNotesController.text.trim(),
                                    );
                                    Navigator.pop(context);
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D5F3F),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Add Break Time',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleBreakTimeAdd(
    DateTime startTime,
    DateTime endTime,
    String note,
  ) async {
    if (endTime.isBefore(startTime)) {
      Customalerts.errorAlert(
        title: "Invalid Time",
        body: "End time must be after start time",
      );
      return;
    }

    BreakTimeEntry newBreak = BreakTimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scheduleId: widget.job.id!,
      startTime: startTime,
      endTime: endTime,
      note: note.isNotEmpty ? note : null,
    );
    breakTimes = [newBreak];
    // await BreakTimeDatabase.saveBreakTime(newBreak);
    // await loadBreakTimes();
    _breakNotesController.clear();

    Customalerts.successAlert(
      title: "Break Time Added",
      body:
          "Break time of ${newBreak.getDurationInMinutes()} minutes added successfully",
    );
    totalBreakMinutes = getTotalBreakMinutes();
    setState(() {});
  }

  void _deleteBreakTime(String breakId) async {
    breakTimes.clear();
    setState(() {});
    Customalerts.successAlert(
      title: "Break Deleted",
      body: "Break time removed successfully",
    );
  }

  Widget _buildBreakTimesList() {
    if (breakTimes.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(16.w),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Break Times',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Total: ${totalBreakMinutes}min',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...breakTimes
              .map(
                (breakTime) => Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${DateFormat("MMM dd - hh:mm a").format(breakTime.startTime)} to ${DateFormat("hh:mm a").format(breakTime.endTime)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${breakTime.getDurationInMinutes()} minutes',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (breakTime.note != null &&
                                breakTime.note!.isNotEmpty)
                              Text(
                                breakTime.note!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _deleteBreakTime(breakTime.id),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red[400],
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentTime();
  }

  @override
  Widget build(BuildContext context) {
    List status = statusColor(widget.job);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Job# ${widget.job.id}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child:
            (pageLoading)
                ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 3,
                    constraints: BoxConstraints(
                      minHeight: 40.w,
                      minWidth: 40.w,
                    ),
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Main clock card
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
                            // Title
                            Text(
                              'Clock in and out for your shift',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Timer display
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 20.h,
                                horizontal: 24.w,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4F0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                clock == null
                                    ? "HH:MM:SS"
                                    : DateFormat("hh:mm:ss a").format(clock!),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4A7C59),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Date
                            Text(
                              DateFormat("EEE, MMM dd,yyyy").format(clock!),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // Status badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: status[3],
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: status[1], width: 1),
                              ),
                              child: Text(
                                status[0],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: status[2],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h),

                            // Notes section
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Notes(Optional)',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            SizedBox(height: 8.h),

                            // Notes text field
                            Container(
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _notesController,
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12.w),
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14.sp,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h),

                            // Buttons
                            Row(
                              children: [
                                // Clock In/Out button
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Handle clock in/out
                                      HomeController hctrl = Get.find();

                                      String endPoint =
                                          widget.job.scheduleLogs!.isEmpty
                                              ? "/schedule-logs/clock-in"
                                              : "/schedule-logs/clock-out";

                                      setState(() {
                                        loading = true;
                                      });

                                      await ApiService.request(
                                        endpoint: endPoint,
                                        body: {
                                          if (breakTimes.isNotEmpty)
                                            "break_start":
                                                breakTimes.first.startTime
                                                    .toUtc()
                                                    .toString(),
                                          // DateFormat(
                                          //   "yyyy-MM-dd hh:mm A",
                                          // ).format(breakTimes.first.startTime),
                                          if (breakTimes.isNotEmpty)
                                            "break_end":
                                                breakTimes.first.endTime
                                                    .toUtc()
                                                    .toString(),

                                          // DateFormat(
                                          //   "yyyy-MM-dd hh:mm A",
                                          // ).format(breakTimes.first.endTime),
                                          "employee_id": hctrl.user!.employeeId,
                                          if (widget
                                              .job
                                              .scheduleLogs!
                                              .isNotEmpty)
                                            "break_time": totalBreakMinutes,

                                          if (widget
                                              .job
                                              .scheduleLogs!
                                              .isNotEmpty)
                                            "clock_out_at":
                                                clock!.toUtc().toString(),
                                          // DateFormat(
                                          //   "yyyy-MM-dd hh:mm A",
                                          // ).format(clock!),
                                          if (widget
                                              .job
                                              .scheduleLogs!
                                              .isNotEmpty)
                                            "schedule_log_id":
                                                widget
                                                    .job
                                                    .scheduleLogs!
                                                    .first
                                                    .id
                                          else
                                            "schedule_id": widget.job.id,
                                          "note": _notesController.text.trim(),
                                        },
                                        onSuccess: (data) {
                                          print(data.data);
                                          if (data.statusCode == 200 ||
                                              data.statusCode == 201) {
                                            // Clear break times after successful clock out
                                            if (widget
                                                .job
                                                .scheduleLogs!
                                                .isNotEmpty) {
                                              breakTimes.clear();
                                            }

                                            Get.back();
                                            hctrl.jobList.clear();
                                            hctrl.fetchShedules();
                                            Customalerts.successAlert(
                                              title:
                                                  widget
                                                          .job
                                                          .scheduleLogs!
                                                          .isEmpty
                                                      ? "Check-In Successful"
                                                      : "Check-Out Successful",
                                              body:
                                                  "Clocked ${widget.job.scheduleLogs!.isEmpty ? 'in' : 'out'} ${DateFormat("dd-M-yyyy : hh:mm:ss a").format(clock!)}",
                                            );
                                          } else {
                                            if (widget
                                                .job
                                                .scheduleLogs!
                                                .isEmpty)
                                              Customalerts.errorAlert(
                                                title: "Check-In failed",
                                                body:
                                                    "Already clocked in or schedule already exists for this date, or employee has an open schedule log.",
                                              );
                                            else {
                                              Customalerts.errorAlert(
                                                title: "Check-out failed",
                                                body: data.data["message"],
                                              );
                                            }
                                          }
                                        },
                                      );

                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2D5F3F),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    child:
                                        (loading)
                                            ? CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 1.5,
                                              constraints: BoxConstraints(
                                                minHeight: 20.w,
                                                minWidth: 20.w,
                                              ),
                                            )
                                            : Text(
                                              widget.job.scheduleLogs!.isEmpty
                                                  ? 'Clock In'
                                                  : "Clock Out",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                  ),
                                ),

                                SizedBox(width: 12.w),

                                // Break Time button
                                if (!widget.job.scheduleLogs!.isEmpty)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _showBreakTimeDialog,
                                      icon: Icon(
                                        Icons.coffee_outlined,
                                        size: 18.sp,
                                        color: const Color(0xFF2D5F3F),
                                      ),
                                      label: Text(
                                        "Add Break",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2D5F3F),
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(
                                          0xFF2D5F3F,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                        ),
                                        side: BorderSide(
                                          color: const Color(0xFF2D5F3F),
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Break times list
                      _buildBreakTimesList(),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _breakNotesController.dispose();
    super.dispose();
  }
}
