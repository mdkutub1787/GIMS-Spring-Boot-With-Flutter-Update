enum Role {
  ADMIN,
  USER,
}

class UserModel {
  int? id;
  String? username;
  String? email;
  String? password;
  String? cell;
  String? address;
  int? companyId;
  String? companyName;
  int? officeId;
  String? officeName;
  Role? role;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.cell,
    this.address,
    this.companyId,
    this.companyName,
    this.officeId,
    this.officeName,
    this.role,
  });

  String? get name => officeName ?? companyName ?? username;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      cell: json['phone'] ?? json['cell'],
      address: json['address'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      officeId: json['officeId'],
      officeName: json['officeName'],
      role: _parseRole(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'phone': cell,
      'cell': cell,
      'address': address,
      'companyId': companyId,
      'companyName': companyName,
      'officeId': officeId,
      'officeName': officeName,
      'role': role?.toString().split('.').last,
    };
  }
}

Role _parseRole(String? role) {
  if (role == null) return Role.USER;
  return Role.values.firstWhere(
    (e) => e.toString().split('.').last.toUpperCase() == role.toUpperCase(),
    orElse: () => Role.USER,
  );
}
