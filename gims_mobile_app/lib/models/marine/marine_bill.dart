import 'marine_policy.dart';

class MarineBill {
  int? id;
  double marineRate;
  double warSrccRate;
  double netPremium;
  double tax;
  double stampDuty;
  double grossPremium;
  MarinePolicy? marineDetails;

  MarineBill({
    this.id,
    required this.marineRate,
    required this.warSrccRate,
    required this.netPremium,
    required this.tax,
    required this.stampDuty,
    required this.grossPremium,
    this.marineDetails,
  });

  factory MarineBill.fromJson(Map<String, dynamic> json) {
    return MarineBill(
      id: json['bill_id'] ?? json['id'],
      marineRate: (json['marine_rate_percentage'] ?? json['marineRate'] ?? 0.0).toDouble(),
      warSrccRate: (json['war_srcc_rate_percentage'] ?? json['warSrccRate'] ?? 0.0).toDouble(),
      netPremium: (json['net_premium'] ?? json['netPremium'] ?? 0.0).toDouble(),
      tax: (json['tax_rate_percentage'] ?? json['tax'] ?? 15.0).toDouble(),
      stampDuty: (json['stamp_duty'] ?? json['stampDuty'] ?? 0.0).toDouble(),
      grossPremium: (json['gross_premium'] ?? json['grossPremium'] ?? 0.0).toDouble(),
      marineDetails: json['marineDetails'] != null 
          ? MarinePolicy.fromJson(json['marineDetails']) 
          : (json['PolicyDetails'] != null ? MarinePolicy.fromJson(json['PolicyDetails']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marineRate': marineRate,
      'warSrccRate': warSrccRate,
      'netPremium': netPremium,
      'tax': tax,
      'stampDuty': stampDuty,
      'grossPremium': grossPremium,
      if (marineDetails != null) 'marineDetails': {'id': marineDetails!.id},
    };
  }
}
