class SheduleModel {
  int? id;
  int? companyId;
  String? employeeId;
  String? type;
  bool? isFinished;
  String? note;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? createdAt;
  int? duration;
  Employee? employee;
  List<ScheduleLogs>? scheduleLogs;

  SheduleModel({
    this.id,
    this.companyId,
    this.employeeId,
    this.type,
    this.isFinished,
    this.note,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.duration,
    this.employee,
    this.scheduleLogs,
  });

  SheduleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    employeeId = json['employee_id'];
    type = json['type'];
    isFinished = json['is_finished'];
    note = json['note'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    duration = json['duration'];
    employee =
        json['employee'] != null
            ? new Employee.fromJson(json['employee'])
            : null;
    if (json['schedule_logs'] != null) {
      scheduleLogs = <ScheduleLogs>[];
      json['schedule_logs'].forEach((v) {
        scheduleLogs!.add(new ScheduleLogs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['employee_id'] = this.employeeId;
    data['type'] = this.type;
    data['is_finished'] = this.isFinished;
    data['note'] = this.note;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['created_at'] = this.createdAt;
    data['duration'] = this.duration;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    if (this.scheduleLogs != null) {
      data['schedule_logs'] =
          this.scheduleLogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Employee {
  String? name;
  String? id;

  Employee({this.name, this.id});

  Employee.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class ScheduleLogs {
  int? id;
  String? status;
  String? clockInAt;
  String? clockOutAt;
  String? employeeId;

  ScheduleLogs({
    this.id,
    this.status,
    this.clockInAt,
    this.clockOutAt,
    this.employeeId,
  });

  ScheduleLogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    clockInAt = json['clock_in_at'];
    clockOutAt = json['clock_out_at'];
    employeeId = json['employee_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['clock_in_at'] = this.clockInAt;
    data['clock_out_at'] = this.clockOutAt;
    data['employee_id'] = this.employeeId;
    return data;
  }
}
