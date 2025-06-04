class UserModel {
  String? id;
  String? email;
  String? name;
  String? role;
  String? employeeId;
  String? companyId;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.role,
    this.employeeId,
    this.companyId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    role = json['role'];
    employeeId = json['employee_id'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['role'] = this.role;
    data['employee_id'] = this.employeeId;
    data['company_id'] = this.companyId;
    return data;
  }
}
