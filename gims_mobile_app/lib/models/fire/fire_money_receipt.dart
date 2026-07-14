import '../utility/issue_office.dart';
import 'fire_bill.dart';

class FireMoneyReceipt {
  int? id;
  IssueOffice? issuingOffice;
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
    // Handling both camelCase and snake_case from API
    id = json['id'] ?? json['money_receipt_id'] ?? json['receipt_id'];
    issuingOffice = (json['issuingOffice'] != null || json['issuing_office'] != null)
        ? (json['issuingOffice'] is String 
            ? IssueOffice(name: json['issuingOffice']) 
            : IssueOffice.fromJson(json['issuingOffice'] ?? json['issuing_office']))
        : null;
    classOfInsurance = json['classOfInsurance'] ?? json['class_of_insurance'] ?? 'N/A';
    date = json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null;
    modeOfPayment = json['modeOfPayment'] ?? json['mode_of_payment'] ?? 'N/A';
    issuedAgainst = json['issuedAgainst'] ?? json['issued_against'] ?? 'N/A';
    
    // Handling nested bill object
    if (json['bill'] != null) {
      bill = FireBill.fromJson(json['bill']);
    } else if (json['fire_bill'] != null) {
      bill = FireBill.fromJson(json['fire_bill']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (issuingOffice != null) data['issuingOffice'] = issuingOffice!.toJson();
    data['classOfInsurance'] = classOfInsurance;
    if (date != null) data['date'] = date?.toIso8601String();
    data['modeOfPayment'] = modeOfPayment;
    data['issuedAgainst'] = issuedAgainst;
    if (bill != null) {
      data['bill'] = {'id': bill!.id};
    }
    return data;
  }
}
