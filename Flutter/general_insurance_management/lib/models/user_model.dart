enum Role {
  ADMIN,
  USER,
}

class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? cell;
  String? address;
  DateTime? dob;
  String? gender;
  Role? role;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.cell,
    this.address,
    this.dob,
    this.gender,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      cell: json['cell'],
      address: json['address'],
      dob: json['dob'] == null ? null : DateTime.parse(json['dob']),
      gender: json['gender'],
      role: _parseRole(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'cell': cell,
      'address': address,
      'dob': dob?.toIso8601String(),
      'gender': gender,
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
