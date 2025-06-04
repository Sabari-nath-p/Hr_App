class TimeLogData {
  final int? id;
  final int? scheduleId;
  final int? companyId;
  final String? employeeId;
  final String? status;
  final String? clockInAt;
  final String? clockOutAt;
  final String? note;
  final String? adminNote;
  final int? duration;
  final String? createdAt;
  final String? approvedAt;
  final int? workDuration;
  final int? overtimeDuration;
  final String? totalPay;
  final String? overtimePay;
  final String? workPay;
  final bool? timeSheetUpdated;
  final String? timeSheetId;
  final int? breakTime;
  final List<PaySplit>? workPaySplit;
  final List<PaySplit>? overtimePaySplit;
  final Schedule? schedules;
  final Employee? employee;

  TimeLogData({
    this.id,
    this.scheduleId,
    this.companyId,
    this.employeeId,
    this.status,
    this.clockInAt,
    this.clockOutAt,
    this.note,
    this.adminNote,
    this.duration,
    this.createdAt,
    this.approvedAt,
    this.workDuration,
    this.overtimeDuration,
    this.totalPay,
    this.overtimePay,
    this.workPay,
    this.timeSheetUpdated,
    this.timeSheetId,
    this.breakTime,
    this.workPaySplit,
    this.overtimePaySplit,
    this.schedules,
    this.employee,
  });

  factory TimeLogData.fromJson(Map<String, dynamic> json) {
    return TimeLogData(
      id: json['id'],
      scheduleId: json['schedule_id'],
      companyId: json['company_id'],
      employeeId: json['employee_id'],
      status: json['status'],
      clockInAt: json['clock_in_at'],
      clockOutAt: json['clock_out_at'],
      note: json['note'],
      adminNote: json['admin_note'],
      duration: json['duration'],
      createdAt: json['created_at'],
      approvedAt: json['approved_at'],
      workDuration: json['work_duration'],
      overtimeDuration: json['overtime_duration'],
      totalPay: json['total_pay'],
      overtimePay: json['overtime_pay'],
      workPay: json['work_pay'],
      timeSheetUpdated: json['time_sheet_updated'],
      timeSheetId: json['time_sheet_id'],
      breakTime: json['break_time'],
      workPaySplit:
          json['work_pay_split'] != null
              ? (json['work_pay_split'] as List)
                  .map((item) => PaySplit.fromJson(item))
                  .toList()
              : null,
      overtimePaySplit:
          json['overtime_pay_split'] != null
              ? (json['overtime_pay_split'] as List)
                  .map((item) => PaySplit.fromJson(item))
                  .toList()
              : null,
      schedules:
          json['schedules'] != null
              ? Schedule.fromJson(json['schedules'])
              : null,
      employee:
          json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }
}

class PaySplit {
  final String? end;
  final double? rate;
  final Shift? shift;
  final String? start;
  final double? amount;
  final double? hoursWorked;

  PaySplit({
    this.end,
    this.rate,
    this.shift,
    this.start,
    this.amount,
    this.hoursWorked,
  });

  factory PaySplit.fromJson(Map<String, dynamic> json) {
    return PaySplit(
      end: json['end'],
      rate: json['rate']?.toDouble(),
      shift: json['shift'] != null ? Shift.fromJson(json['shift']) : null,
      start: json['start'],
      amount: json['amount']?.toDouble(),
      hoursWorked: json['hours_worked'],
    );
  }
}

class Shift {
  final int? id;
  final String? name;
  final String? endTime;
  final int? breakTime;
  final String? startTime;
  final double? hourlyRate;

  Shift({
    this.id,
    this.name,
    this.endTime,
    this.breakTime,
    this.startTime,
    this.hourlyRate,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'],
      name: json['name'],
      endTime: json['end_time'],
      breakTime: json['break_time'],
      startTime: json['start_time'],
      hourlyRate: json['hourly_rate']?.toDouble(),
    );
  }
}

class Schedule {
  final int? id;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;

  Schedule({
    this.id,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}

class Employee {
  final String? id;
  final String? name;
  final String? phone;

  Employee({this.id, this.name, this.phone});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(id: json['id'], name: json['name'], phone: json['phone']);
  }
}
