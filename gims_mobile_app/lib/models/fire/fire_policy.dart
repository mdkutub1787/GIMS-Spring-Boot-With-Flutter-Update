import '../utility_models.dart';

class FirePolicy {
  int? id;
  String? sysNumber;
  InsuranceCompany? company;
  DateTime? date;
  Bank? bank;
  Branch? branch;
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

  FirePolicy({
    this.id,
    this.sysNumber,
    this.company,
    this.date,
    this.bank,
    this.branch,
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

  factory FirePolicy.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse doubles (especially for large numbers/scientific notation)
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return FirePolicy(
      id: json['policy_id'] ?? json['id'],
      sysNumber: json['sys_number']?.toString(),
      company: json['company'] != null ? InsuranceCompany.fromJson(json['company']) : null,
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
      bank: json['bank'] != null ? Bank.fromJson(json['bank']) : null,
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      policyholder: json['policyholder']?.toString() ?? 'N/A',
      address: json['address']?.toString() ?? '',
      stockInsured: json['stock_insured']?.toString() ?? '',
      sumInsured: parseDouble(json['sum_insured']),
      interestInsured: json['interest_insured']?.toString() ?? '',
      coverage: json['coverage']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      construction: json['construction']?.toString() ?? '',
      owner: json['owner']?.toString() ?? '',
      usedAs: json['used_as']?.toString() ?? '',
      periodFrom: json['period_from'] != null ? DateTime.tryParse(json['period_from'].toString()) : null,
      periodTo: json['period_to'] != null ? DateTime.tryParse(json['period_to'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (sysNumber != null) data['sysNumber'] = sysNumber;
    if (company != null) data['company'] = {'id': company!.id};
    if (date != null) data['date'] = date?.toIso8601String();
    if (bank != null) data['bank'] = {'id': bank!.id};
    if (branch != null) data['branch'] = {'id': branch!.id};
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
    if (periodFrom != null) data['periodFrom'] = periodFrom?.toIso8601String();
    if (periodTo != null) data['periodTo'] = periodTo?.toIso8601String();
    return data;
  }
}
