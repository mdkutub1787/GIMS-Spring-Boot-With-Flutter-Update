enum Role {
  ADMIN,
  USER,
}

class UserModel {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? username;
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
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.password,
    this.cell,
    this.address,
    this.dob,
    this.gender,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? combinedName = json['name'];
    if (combinedName == null && json['firstname'] != null) {
      combinedName = "${json['firstname']} ${json['lastname'] ?? ''}".trim();
    }

    return UserModel(
      id: json['id'],
      name: combinedName,
      firstName: json['firstname'],
      lastName: json['lastname'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      cell: json['phone'] ?? json['cell'],
      address: json['address'],
      dob: json['dob'] == null ? null : DateTime.tryParse(json['dob'].toString()),
      gender: json['gender'],
      role: _parseRole(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'firstname': firstName,
      'lastname': lastName,
      'username': username,
      'email': email,
      'password': password,
      'phone': cell,
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
