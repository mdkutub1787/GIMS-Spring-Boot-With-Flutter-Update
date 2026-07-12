import '../utility_models.dart';

class MarinePolicy {
  int? id;
  String? sysNumber;
  DateTime? date;
  Bank? bank;
  Branch? branch;
  String? policyholder;
  String? address;
  String? voyageFrom;
  String? voyageTo;
  String? via;
  String? stockItem;
  double? sumInsuredUsd;
  double? usdRate;
  double? sumInsured;
  String? coverage;
  bool isHovered = false;

  MarinePolicy({
    this.id,
    this.sysNumber,
    this.date,
    this.bank,
    this.branch,
    this.policyholder,
    this.address,
    this.voyageFrom,
    this.voyageTo,
    this.via,
    this.stockItem,
    this.sumInsuredUsd,
    this.usdRate,
    this.sumInsured,
    this.coverage,
  });

  factory MarinePolicy.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return MarinePolicy(
      id: json['policy_id'] ?? json['id'],
      sysNumber: json['sys_number']?.toString(),
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
      bank: json['bank'] != null ? Bank.fromJson(json['bank']) : null,
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      policyholder: json['policyholder']?.toString() ?? 'N/A',
      address: json['address']?.toString() ?? '',
      voyageFrom: (json['voyage_from'] ?? json['voyageFrom'])?.toString() ?? '',
      voyageTo: (json['voyage_to'] ?? json['voyageTo'])?.toString() ?? '',
      via: json['via']?.toString() ?? '',
      stockItem: (json['stock_item'] ?? json['stockItem'])?.toString() ?? '',
      sumInsuredUsd: parseDouble(json['sum_insured_usd'] ?? json['sumInsuredUsd']),
      usdRate: parseDouble(json['usd_rate'] ?? json['usdRate']),
      sumInsured: parseDouble(json['sum_insured'] ?? json['sumInsured']),
      coverage: json['coverage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (sysNumber != null) data['sysNumber'] = sysNumber;
    if (date != null) data['date'] = date?.toIso8601String();
    if (bank != null) data['bank'] = {'id': bank!.id};
    if (branch != null) data['branch'] = {'id': branch!.id};
    data['policyholder'] = policyholder;
    data['address'] = address;
    data['voyageFrom'] = voyageFrom;
    data['voyageTo'] = voyageTo;
    data['via'] = via;
    data['stockItem'] = stockItem;
    data['sumInsuredUsd'] = sumInsuredUsd;
    data['usdRate'] = usdRate;
    data['sumInsured'] = sumInsured;
    data['coverage'] = coverage;
    return data;
  }
}
