class PolicyModel {
  int? id;
  String? sysNumber;
  String? company;
  DateTime? date;
  String? bankName;
  String? branchName;
  String? policyholder;
  String? address;
  String? stockInsured;
  double? sumInsured;
  String? interestInsured;
  String? coverage;
  String? location;
  String? construction;
  String? owner;
  String? usedAs;
  DateTime? periodFrom;
  DateTime? periodTo;
  bool isHovered = false;

  PolicyModel({
    this.id,
    this.sysNumber,
    this.company,
    this.date,
    this.bankName,
    this.policyholder,
    this.address,
    this.stockInsured,
    this.sumInsured,
    this.interestInsured,
    this.coverage,
    this.location,
    this.construction,
    this.owner,
    this.usedAs,
    this.periodFrom,
    this.periodTo,
  });

  PolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sysNumber = json['sysNumber'];
    company = json['company'];
    date = json['date'] != null ? DateTime.tryParse(json['date']) : null;
    bankName = json['bankName'];
    branchName = json['branchName'];
    policyholder = json['policyholder'];
    address = json['address'];
    stockInsured = json['stockInsured'];
    sumInsured = json['sumInsured']?.toDouble();
    interestInsured = json['interestInsured'];
    coverage = json['coverage'];
    location = json['location'];
    construction = json['construction'];
    owner = json['owner'];
    usedAs = json['usedAs'];
    periodFrom = json['periodFrom'] != null ? DateTime.tryParse(json['periodFrom']) : null;
    periodTo = json['periodTo'] != null ? DateTime.tryParse(json['periodTo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sysNumber'] = sysNumber;
    data['company'] = company;
    data['date'] = date?.toIso8601String();
    data['bankName'] = bankName;
    data['branchName'] = branchName;
    data['policyholder'] = policyholder;
    data['address'] = address;
    data['stockInsured'] = stockInsured;
    data['sumInsured'] = sumInsured;
    data['interestInsured'] = interestInsured;
    data['coverage'] = coverage;
    data['location'] = location;
    data['construction'] = construction;
    data['owner'] = owner;
    data['usedAs'] = usedAs;
    data['periodFrom'] = periodFrom?.toIso8601String();
    data['periodTo'] = periodTo?.toIso8601String();
    return data;
  }
}
