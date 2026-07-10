import 'fire_policy.dart';

class FireBill {
  int? id;
  double fire; // Percentage
  double fireAmount;
  double rsd; // Percentage
  double rsdAmount;
  double netPremium;
  double tax; // Percentage
  double taxAmount;
  double grossPremium;
  FirePolicy? policy;

  FireBill({
    this.id,
    required this.fire,
    this.fireAmount = 0.0,
    required this.rsd,
    this.rsdAmount = 0.0,
    required this.netPremium,
    required this.tax,
    this.taxAmount = 0.0,
    required this.grossPremium,
    this.policy,
  });

  factory FireBill.fromJson(Map<String, dynamic> json) {
    // Helper to extract double from complex objects or direct values
    double getVal(dynamic data, {bool isAmount = false}) {
      if (data == null) return 0.0;
      if (data is num) {
        return isAmount ? 0.0 : data.toDouble();
      }
      if (data is Map) {
        return (data[isAmount ? 'amount' : 'percentage'] ?? 0.0).toDouble();
      }
      return 0.0;
    }

    return FireBill(
      id: json['billId'] ?? json['bill_id'] ?? json['id'],
      fire: getVal(json['fire']),
      fireAmount: getVal(json['fire'], isAmount: true),
      rsd: getVal(json['rsd']),
      rsdAmount: getVal(json['rsd'], isAmount: true),
      netPremium: (json['netPremium'] ?? json['net_premium'] ?? 0.0).toDouble(),
      tax: getVal(json['tax']),
      taxAmount: getVal(json['tax'], isAmount: true),
      grossPremium: (json['grossPremium'] ?? json['gross_premium'] ?? 0.0).toDouble(),
      policy: json['policy'] != null ? FirePolicy.fromJson(json['policy']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fire': fire,
      'fireAmount': fireAmount,
      'rsd': rsd,
      'rsdAmount': rsdAmount,
      'netPremium': netPremium,
      'tax': tax,
      'taxAmount': taxAmount,
      'grossPremium': grossPremium,
      if (policy != null) 'policy': {'id': policy!.id},
    };
  }
}
