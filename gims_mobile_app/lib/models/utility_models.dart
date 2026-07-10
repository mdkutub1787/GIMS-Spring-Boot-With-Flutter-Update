class Bank {
  final int id;
  final String name;

  Bank({required this.id, required this.name});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'] ?? json['bankId'] ?? 0,
      name: json['name']?.toString() ?? 'N/A',
    );
  }
}

class Branch {
  final int id;
  final String name;

  Branch({required this.id, required this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? json['branchId'] ?? 0,
      name: json['name']?.toString() ?? 'N/A',
    );
  }
}

class InsuranceCompany {
  final int id;
  final String name;
  final String? type;
  final String? sector;

  InsuranceCompany({
    required this.id,
    required this.name,
    this.type,
    this.sector,
  });

  factory InsuranceCompany.fromJson(Map<String, dynamic> json) {
    return InsuranceCompany(
      id: json['id'] ?? json['companyId'] ?? 0,
      name: json['name']?.toString() ?? 'N/A',
      type: json['type']?.toString(),
      sector: json['sector']?.toString(),
    );
  }
}
