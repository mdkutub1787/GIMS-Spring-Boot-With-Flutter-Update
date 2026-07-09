import 'policy_model.dart';

class BillModel {
  int? id;
  double fire;
  double rsd;
  double netPremium;
  double tax;
  double grossPremium;
  PolicyModel policy;

  BillModel({
    this.id,
    required this.fire,
    required this.rsd,
    required this.netPremium,
    required this.tax,
    required this.grossPremium,
    required this.policy,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'],
      fire: (json['fire'] is num) ? json['fire'].toDouble() : 0.0,
      rsd: (json['rsd'] is num) ? json['rsd'].toDouble() : 0.0,
      netPremium: (json['netPremium'] is num) ? json['netPremium'].toDouble() : 0.0,
      tax: (json['tax'] is num) ? json['tax'].toDouble() : 0.0,
      grossPremium: (json['grossPremium'] is num) ? json['grossPremium'].toDouble() : 0.0,
      policy: PolicyModel.fromJson(json['policy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fire': fire,
      'rsd': rsd,
      'netPremium': netPremium,
      'tax': tax,
      'grossPremium': grossPremium,
      'policy': policy.toJson(),
    };
  }
}
