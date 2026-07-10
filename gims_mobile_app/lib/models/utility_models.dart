class Bank {
  final int id;
  final String name;

  Bank({required this.id, required this.name});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Branch {
  final int id;
  final String name;

  Branch({required this.id, required this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
    );
  }
}

class InsuranceCompany {
  final int id;
  final String name;
  final String type;
  final String sector;

  InsuranceCompany({
    required this.id,
    required this.name,
    required this.type,
    required this.sector,
  });

  factory InsuranceCompany.fromJson(Map<String, dynamic> json) {
    return InsuranceCompany(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      sector: json['sector'],
    );
  }
}
