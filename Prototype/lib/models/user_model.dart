class User{
  final String employeeName;
  final String employeeID;
  final String email;
  final String password;
  final String phoneNumber;
  final String role;
  final List<dynamic> salesRecord;

  User({
    required this.employeeName,
    required this.employeeID,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.role,
    required this.salesRecord
  });

  factory User.fromJson(Map<String, dynamic> json) {
    dynamic salesRecordList;
    if (json['sales_record'] != null){
      salesRecordList = json["sales_record"].map((x) => SalesRecord.fromJson(x)).toList();
    }
    else {
      salesRecordList = [];
    }
    return User(
      employeeName: json["employee_name"],
      employeeID: json["employee_id"],
      email: json["email"],
      password: json["password"],
      phoneNumber: json["phone_number"],
      role: json["role"],
      salesRecord: salesRecordList,
    );
  }
}

class SalesRecord {
  final int year;
  final int month;
  final double sales;

  SalesRecord({
    required this.year,
    required this.month,
    required this.sales
  });

  factory SalesRecord.fromJson(Map<String, dynamic> json) {
    return SalesRecord(
      year: json["year"],
      month: json["month"],
      sales: json["sales"],
    );
  }
}