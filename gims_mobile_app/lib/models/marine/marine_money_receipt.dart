import 'marine_bill.dart';

class MarineMoneyReceipt {
  int? id;
  String? issuingOffice;
  String? classOfInsurance;
  DateTime? date;
  String? modeOfPayment;
  String? issuedAgainst;
  MarineBill? marinebill;

  MarineMoneyReceipt({
    this.id,
    this.issuingOffice,
    this.classOfInsurance,
    this.date,
    this.modeOfPayment,
    this.issuedAgainst,
    this.marinebill,
  });

  MarineMoneyReceipt.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        issuingOffice = json['issuingOffice'],
        classOfInsurance = json['classOfInsurance'],
        date = json['date'] != null ? DateTime.parse(json['date']) : null,
        modeOfPayment = json['modeOfPayment'],
        issuedAgainst = json['issuedAgainst'],
        marinebill = json['marinebill'] != null
            ? MarineBill.fromJson(json['marinebill'])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['issuingOffice'] = issuingOffice;
    data['classOfInsurance'] = classOfInsurance;
    data['date'] = date?.toIso8601String();
    data['modeOfPayment'] = modeOfPayment;
    data['issuedAgainst'] = issuedAgainst;
    if (marinebill != null) {
      data['marinebill'] = marinebill!.toJson();
    }
    return data;
  }
}
