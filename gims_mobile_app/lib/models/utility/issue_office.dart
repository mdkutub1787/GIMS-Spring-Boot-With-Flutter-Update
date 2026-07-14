class IssueOffice {
  final int? id;
  final String name;
  final String? address;
  final String? phone;
  final String? mobile;
  final String? fax;
  final String? email;
  final String? website;

  IssueOffice({
    this.id,
    required this.name,
    this.address,
    this.phone,
    this.mobile,
    this.fax,
    this.email,
    this.website,
  });

  factory IssueOffice.fromJson(Map<String, dynamic> json) {
    return IssueOffice(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      mobile: json['mobile'],
      fax: json['fax'],
      email: json['email'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'mobile': mobile,
      'fax': fax,
      'email': email,
      'website': website,
    };
  }
}
