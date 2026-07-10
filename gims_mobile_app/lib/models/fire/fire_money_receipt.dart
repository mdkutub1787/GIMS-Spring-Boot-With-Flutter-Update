import 'fire_bill.dart';

class FireMoneyReceipt {
  int? id;
  String? issuingOffice;
  String? classOfInsurance;
  DateTime? date;
  String? modeOfPayment;
  String? issuedAgainst;
  FireBill? bill;

  FireMoneyReceipt({
    this.id,
    this.issuingOffice,
    this.classOfInsurance,
    this.date,
    this.modeOfPayment,
    this.issuedAgainst,
    this.bill,
  });

  FireMoneyReceipt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    issuingOffice = json['issuingOffice'];
    classOfInsurance = json['classOfInsurance'];
    date = json['date'] != null ? DateTime.parse(json['date']) : null;
    modeOfPayment = json['modeOfPayment'];
    issuedAgainst = json['issuedAgainst'];
    bill = json['bill'] != null ? FireBill.fromJson(json['bill']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['issuingOffice'] = issuingOffice;
    data['classOfInsurance'] = classOfInsurance;
    data['date'] = date?.toIso8601String();
    data['modeOfPayment'] = modeOfPayment;
    data['issuedAgainst'] = issuedAgainst;
    if (bill != null) {
      data['bill'] = bill!.toJson();
    }
    return data;
  }
}
