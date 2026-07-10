import 'marine_policy.dart';

class MarineBill {
  int? id;
  double marineRate;
  double warSrccRate;
  double netPremium;
  double tax;
  double stampDuty;
  double grossPremium;
  MarinePolicy marineDetails;

  MarineBill({
    this.id,
    required this.marineRate,
    required this.warSrccRate,
    required this.netPremium,
    required this.tax,
    required this.stampDuty,
    required this.grossPremium,
    required this.marineDetails,
  });

  factory MarineBill.fromJson(Map<String, dynamic> json) {
    return MarineBill(
      id: json['id'],
      marineRate: (json['marineRate'] is num) ? json['marineRate'].toDouble() : 0.0,
      warSrccRate: (json['warSrccRate'] is num) ? json['warSrccRate'].toDouble() : 0.0,
      netPremium: (json['netPremium'] is num) ? json['netPremium'].toDouble() : 0.0,
      tax: (json['tax'] is num) ? json['tax'].toDouble() : 0.0,
      stampDuty: (json['stampDuty'] is num) ? json['stampDuty'].toDouble() : 0.0,
      grossPremium: (json['grossPremium'] is num) ? json['grossPremium'].toDouble() : 0.0,
      marineDetails: MarinePolicy.fromJson(json['marineDetails']),
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
      'marineDetails': marineDetails.toJson(),
    };
  }
}
