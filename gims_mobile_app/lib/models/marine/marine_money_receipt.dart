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
        date = json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
        modeOfPayment = json['modeOfPayment'],
        issuedAgainst = json['issuedAgainst'],
        marinebill = json['marinebill'] != null
            ? MarineBill.fromJson(json['marinebill'])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['issuingOffice'] = issuingOffice;
    data['classOfInsurance'] = classOfInsurance;
    if (date != null) data['date'] = date?.toIso8601String();
    data['modeOfPayment'] = modeOfPayment;
    data['issuedAgainst'] = issuedAgainst;
    if (marinebill != null) {
      data['marinebill'] = {'id': marinebill!.id};
    }
    return data;
  }
}
