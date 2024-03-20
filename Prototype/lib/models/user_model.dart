class User{
  final String employeeName;
  final String employeeID;
  final String email;
  final String password;
  final String phoneNumber;
  final String role;

  User({
    required this.employeeName,
    required this.employeeID,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.role
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      employeeName: json["employee_name"],
      employeeID: json["employee_id"],
      email: json["email"],
      password: json["password"],
      phoneNumber: json["phoneNumber"],
      role: json["role"]
    );
  }
}