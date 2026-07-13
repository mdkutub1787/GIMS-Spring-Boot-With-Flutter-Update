import 'marine_policy.dart';

class MarineBill {
  int? id;
  double marineRate;
  double marineAmount;
  double warSrccRate;
  double warSrccAmount;
  double netPremium;
  double tax;
  double taxAmount;
  double stampDuty;
  double grossPremium;
  MarinePolicy? marineDetails;

  MarineBill({
    this.id,
    required this.marineRate,
    this.marineAmount = 0.0,
    required this.warSrccRate,
    this.warSrccAmount = 0.0,
    required this.netPremium,
    required this.tax,
    this.taxAmount = 0.0,
    required this.stampDuty,
    required this.grossPremium,
    this.marineDetails,
  });

  factory MarineBill.fromJson(Map<String, dynamic> json) {
    // Helper for nested percentage parsing
    double parsePercentage(dynamic value, String key) {
      if (value is Map<String, dynamic>) {
        return (value['percentage'] ?? 0.0).toDouble();
      }
      return (value ?? 0.0).toDouble();
    }

    double parseAmount(dynamic value) {
      if (value is Map<String, dynamic>) {
        return (value['amount'] ?? 0.0).toDouble();
      }
      return 0.0;
    }

    double parsedMarineRate = parsePercentage(json['marine'], 'marine') != 0.0 ? parsePercentage(json['marine'], 'marine') : (json['marineRate'] ?? 0.0).toDouble();
    double parsedWarSrccRate = parsePercentage(json['warSrcc'], 'warSrcc') != 0.0 ? parsePercentage(json['warSrcc'], 'warSrcc') : (json['warSrccRate'] ?? 0.0).toDouble();
    double parsedTaxRate = parsePercentage(json['tax'], 'tax') != 0.0 ? parsePercentage(json['tax'], 'tax') : (json['tax_rate_percentage'] ?? json['tax'] ?? 15.0).toDouble();
    double parsedNetPremium = (json['netPremium'] ?? json['net_premium'] ?? 0.0).toDouble();

    MarinePolicy? details = json['marineDetails'] != null 
          ? MarinePolicy.fromJson(json['marineDetails']) 
          : (json['PolicyDetails'] != null ? MarinePolicy.fromJson(json['PolicyDetails']) : null);

    double mAmount = parseAmount(json['marine']);
    if (mAmount == 0.0 && details != null) {
      mAmount = (details.sumInsured ?? 0.0) * (parsedMarineRate / 100);
    }

    double wAmount = parseAmount(json['warSrcc']);
    if (wAmount == 0.0 && details != null) {
      wAmount = (details.sumInsured ?? 0.0) * (parsedWarSrccRate / 100);
    }

    double tAmount = parseAmount(json['tax']);
    if (tAmount == 0.0 && parsedNetPremium > 0) {
      tAmount = parsedNetPremium * (parsedTaxRate / 100);
    }

    return MarineBill(
      id: json['billId'] ?? json['bill_id'] ?? json['id'],
      marineRate: parsedMarineRate,
      marineAmount: mAmount,
      warSrccRate: parsedWarSrccRate,
      warSrccAmount: wAmount,
      netPremium: parsedNetPremium,
      tax: parsedTaxRate,
      taxAmount: tAmount,
      stampDuty: (json['stampDuty'] ?? json['stamp_duty'] ?? 0.0).toDouble(),
      grossPremium: (json['grossPremium'] ?? json['gross_premium'] ?? 0.0).toDouble(),
      marineDetails: details,
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
