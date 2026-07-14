import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/fire/fire_bill.dart';
import '../models/fire/fire_money_receipt.dart';
import '../models/marine/marine_bill.dart';
import '../models/marine/marine_money_receipt.dart';
import '../models/utility/issue_office.dart';

class PdfService {
  static Future<pw.Document> _createDocument() async {
    try {
      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();
      return pw.Document(
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
      );
    } catch (e) {
      return pw.Document();
    }
  }

  static pw.Widget _buildInfoItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return pw.TableRow(
      children: cells.map((cell) => pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(cell, 
          textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
          style: pw.TextStyle(fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal)),
      )).toList(),
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 140, child: pw.Text(label, style: pw.TextStyle(fontSize: 9))),
          pw.Text(':  ', style: pw.TextStyle(fontSize: 9)),
          pw.Expanded(child: pw.Text(value, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey800))),
        ]
      )
    );
  }

  // --------------------------------------------------------------------------
  // FIRE PDFs
  // --------------------------------------------------------------------------

  static Future<void> generateFireBillPdf(FireBill bill) async {
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return _buildFireTemplate(bill, "PREMIUM BILL");
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateFireCoverNotePdf(FireMoneyReceipt receipt) async {
    final bill = receipt.bill!;
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return _buildFireTemplate(bill, "FIRE COVER NOTE", receiptId: receipt.id.toString(), issuingOffice: receipt.issuingOffice);
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static pw.Widget _buildFireTemplate(FireBill bill, String title, {String? receiptId, IssueOffice? issuingOffice}) {
    final String bankStr = bill.policy?.bank?.name != null ? "${bill.policy?.bank?.name}, " : "";
    final String branchStr = bill.policy?.branch?.name != null ? "${bill.policy?.branch?.name}, " : "";
    final String insuredNameStr = "$bankStr$branchStr${bill.policy?.policyholder ?? ''}";
    final String addressStr = bill.policy?.address ?? '';

    final String periodFrom = bill.policy?.periodFrom != null ? DateFormat('dd-MMM-yy').format(bill.policy!.periodFrom!) : 'N/A';
    final String periodTo = bill.policy?.periodTo != null ? DateFormat('dd-MMM-yy').format(bill.policy!.periodTo!) : 'N/A';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Crystal', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic, color: PdfColors.blue900)),
                  pw.Text(issuingOffice?.name ?? bill.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                  pw.Text(issuingOffice?.address ?? '${bill.policy?.branch?.name ?? ''} Branch', style: pw.TextStyle(fontSize: 10)),
                  pw.Text('Tel: ${issuingOffice?.phone ?? 'N/A'}\nMob: ${issuingOffice?.mobile ?? 'N/A'}', style: pw.TextStyle(fontSize: 9, color: PdfColors.blue)),
                  if (title == "FIRE COVER NOTE") ...[
                    pw.SizedBox(height: 5),
                    pw.Text('FIRE COVER NOTE NO : ${bill.policy?.sysNumber ?? ''}', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                  ]
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(issuingOffice?.name ?? bill.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                  if (title == "FIRE COVER NOTE") 
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: pw.BoxDecoration(color: PdfColors.black, borderRadius: pw.BorderRadius.circular(15)),
                      child: pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.white))
                    )
                  else 
                    pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Corporate Office', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                  pw.Text('DR Tower (14th floor), 65/2/2,\nBox Culvert Road, Purana\nPaltan, Dhaka-1000\nTel: ${issuingOffice?.phone ?? '88-02-55112733-38'}\nFax: ${issuingOffice?.fax ?? '88-029567205'}\nE-mail: ${issuingOffice?.email ?? 'info@crystalins.com'}\nWebsite: ${issuingOffice?.website ?? 'www.crystalins.com'}', 
                    textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                  pw.SizedBox(height: 5),
                  pw.Text('Date: ${bill.policy?.date != null ? DateFormat('dd-MMM-yy').format(bill.policy!.date!) : 'N/A'}', style: pw.TextStyle(fontSize: 9)),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 1, color: PdfColors.grey400),
        
        pw.SizedBox(height: 5),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(width: 90, child: pw.Text('The Insured Name : ', style: pw.TextStyle(fontSize: 9))),
            pw.Expanded(child: pw.Text(insuredNameStr, style: pw.TextStyle(fontSize: 9))),
          ]
        ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(width: 90, child: pw.Text('& Address : ', style: pw.TextStyle(fontSize: 9))),
            pw.Expanded(child: pw.Text(addressStr, style: pw.TextStyle(fontSize: 9))),
          ]
        ),
        
        pw.SizedBox(height: 15),
        pw.Text(
          'Having this day proposed to effect an insurance against Fire and/or lighting for a period of 12 (Twelve) months from $periodFrom to $periodTo on the usual terms and conditions of the company\'s Fire Policy and having paid the undernoted premium in cash /cheque /P.O/D.D./C/A the following property is hereby insured to the extent of Taka ${bill.policy?.sumInsured != null ? NumberFormat('#,##,###').format(bill.policy!.sumInsured) : '0'} Only in the manner specified below:',
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700, lineSpacing: 1.5),
          textAlign: pw.TextAlign.justify,
        ),

        pw.SizedBox(height: 10),
        pw.Table(
          columnWidths: { 0: const pw.FlexColumnWidth(3), 1: const pw.FlexColumnWidth(0.5), 2: const pw.FlexColumnWidth(1) },
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          children: [
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Segregation of The Sum Insured', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Sum Insured', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${bill.policy?.stockInsured ?? 'Stock Of All Kinds'}', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.policy?.sumInsured ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Total Sum Insured :', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.policy?.sumInsured ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
          ]
        ),

        pw.SizedBox(height: 15),
        _buildDetailRow('Property Insured', bill.policy?.interestInsured ?? 'Covering the risk on Stock Of All Kinds'),
        _buildDetailRow('Risk(s) Covered', bill.policy?.coverage ?? 'Fire and/or Lightning, Riot & Strike Damage risks only'),
        _buildDetailRow('Construction of Premises', bill.policy?.construction ?? '1st Class'),
        _buildDetailRow('Owner of Premises', bill.policy?.owner ?? 'The Insured.'),
        _buildDetailRow('Occupation of Premises', bill.policy?.usedAs ?? 'Shop-Cum-Godown Only.'),
        _buildDetailRow('Situation of Premises', bill.policy?.location ?? 'Address'),
        _buildDetailRow('Warranty', 'This Covernote is issued, subject to Terms, Conditions and Warranties of the Policy.'),

        pw.SizedBox(height: 15),
        pw.Table(
          columnWidths: { 0: const pw.FlexColumnWidth(3), 1: const pw.FlexColumnWidth(0.5), 2: const pw.FlexColumnWidth(1) },
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          children: [
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Premium Rate', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Premium Payable', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Fire@ ${bill.fire}%', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.fireAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('R&SD @ ${bill.rsd}%', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.rsdAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Net Premium:', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.netPremium), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('VAT @ ${bill.tax}%', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.taxAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Gross Premium:', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.grossPremium), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
              ]
            ),
          ]
        ),

        pw.SizedBox(height: 10),
        pw.Text('The following terms, conditions and warranties mentioned/ attached here to :', style: pw.TextStyle(fontSize: 8)),
        pw.Text(
          'Note : Should the terms and condition of the Company\'s Policy be unknown to the insured it shall be incumbent upon him to make application to this Office for a copy for such terms and conditions. Failure to comply with the policy terms and conditions though the insured being unacquainted with them shall not excuse his failure to act in accordance there with and by the acceptance of this Cover Note the Insured binds himself by the terms and conditions of the Company\'s Policy.\nNo. Receipt is Valid Unless made out on the company\'s official cash receipt from and signed by a duly authorised officer of the Company.\nThis Cover Note does not cover computer system records unless specifically mentioned and insured by this Cover Note.',
          style: pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          textAlign: pw.TextAlign.justify,
        ),

        pw.Spacer(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Renewal No.:', style: pw.TextStyle(fontSize: 9)),
                pw.Text('MR. No. ${receiptId ?? 'N/A'} & Date : ${bill.policy?.date != null ? DateFormat('dd-MMM-yy').format(bill.policy!.date!) : 'N/A'}', style: pw.TextStyle(fontSize: 9)),
              ]
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Fully Re-insured with', style: pw.TextStyle(fontSize: 9)),
                pw.Text('Sadharan Bima Corporation', style: pw.TextStyle(fontSize: 9)),
              ]
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('For & on behalf of', style: pw.TextStyle(fontSize: 9)),
                pw.Text(bill.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 30), // Space for signature
                pw.SizedBox(width: 100, child: pw.Divider(thickness: 1)),
                pw.Text('Branch-In-charge', style: pw.TextStyle(fontSize: 9)),
              ]
            ),
          ]
        )
      ],
    );
  }

  static Future<void> generateFirePolicySchedulePdf(FireMoneyReceipt receipt) async {
    final bill = receipt.bill!;
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          final String bankStr = bill.policy?.bank?.name != null ? "${bill.policy?.bank?.name}, " : "";
          final String branchStr = bill.policy?.branch?.name != null ? "${bill.policy?.branch?.name}, " : "";
          final String insuredNameStr = "$bankStr$branchStr${bill.policy?.policyholder ?? ''}";
          final String addressStr = bill.policy?.address ?? '';

          final String periodFrom = bill.policy?.periodFrom != null ? DateFormat('dd-MMM-yyyy').format(bill.policy!.periodFrom!) : 'N/A';
          final String periodTo = bill.policy?.periodTo != null ? DateFormat('dd-MMM-yyyy').format(bill.policy!.periodTo!) : 'N/A';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top Header
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Crystal', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic, color: PdfColors.black)),
                        pw.Text(receipt.issuingOffice?.name ?? bill.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                        pw.Text(receipt.issuingOffice?.address ?? '${bill.policy?.branch?.name ?? ''} Branch', style: pw.TextStyle(fontSize: 10)),
                        pw.Text('Tel: ${receipt.issuingOffice?.phone ?? 'N/A'}\nMob: ${receipt.issuingOffice?.mobile ?? 'N/A'}', style: pw.TextStyle(fontSize: 9, color: PdfColors.blue)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(receipt.issuingOffice?.name ?? bill.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic)),
                        pw.SizedBox(height: 5),
                        pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: pw.BoxDecoration(border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(15), color: PdfColors.grey200),
                            child: pw.Text('FIRE POLICY', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text('THE SCHEDULE', style: pw.TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Corporate Office', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                        pw.Text('DR Tower (14th floor), 65/2/2,\nBox Culvert Road, Purana\nPaltan, Dhaka-1000\nTel: ${receipt.issuingOffice?.phone ?? '88-02-55112733-38'}\nFax: ${receipt.issuingOffice?.fax ?? '88-029567205'}\nE-mail: ${receipt.issuingOffice?.email ?? 'info@crystalins.com'}\nWebsite: ${receipt.issuingOffice?.website ?? 'www.crystalins.com'}', 
                          textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Schedule Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('The Company : ${bill.policy?.company?.name ?? 'Crystal Insurance PLC'}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
                          pw.Text('POLICY NUMBER', style: pw.TextStyle(fontSize: 9)),
                          pw.Text('${bill.policy?.sysNumber ?? 'N/A'}', style: pw.TextStyle(fontSize: 9)),
                          pw.Text('IN LIEU OF COVER NOTE NO.', style: pw.TextStyle(fontSize: 9)),
                          pw.Text('${bill.policy?.sysNumber ?? 'N/A'}', style: pw.TextStyle(fontSize: 9)),
                      ])),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('The Insured Name\nand Address:', style: pw.TextStyle(fontSize: 9)),
                            pw.SizedBox(width: 10),
                            pw.Expanded(child: pw.Text('$insuredNameStr, $addressStr', style: pw.TextStyle(fontSize: 9)))
                          ]
                      )),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('IN LIEU OF ADDENDUM NO.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('The Period :      From : $periodFrom', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('To:    $periodTo           Until 4. P.M (B.S.T)', style: pw.TextStyle(fontSize: 9))),
                    ]
                  )
                ]
              ),

              pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: 0.5)),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Column(
                    children: [
                        pw.Text('Description of the Property Insured', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                        pw.Text('The following interest being the property of the insured or held by them in trust or on commission or on joint account with others for which they are legally liable for loss or damage by the perils mentioned hereunder :', style: pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.justify),
                    ]
                )
              ),

              pw.Table(
                columnWidths: { 0: const pw.FlexColumnWidth(3), 1: const pw.FlexColumnWidth(0.5), 2: const pw.FlexColumnWidth(1) },
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('|| SEGREGATION OF THE SUM INSURED ||', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('SUM INSURED', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${bill.policy?.stockInsured ?? 'Stock Of All Kinds'}', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.policy?.sumInsured ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('(In word : Taka ... Only)', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.policy?.sumInsured ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                ]
              ),

              pw.SizedBox(height: 5),
              _buildDetailRow('PROPERTY INSURED', bill.policy?.interestInsured ?? 'Covering the risk on Stock Of All Kinds'),
              _buildDetailRow('RISK(S) COVERED', bill.policy?.coverage ?? 'Fire and/or Lightning, Riot & Strike Damage risks only'),
              _buildDetailRow('SITUATION OF PREMISES', bill.policy?.location ?? 'Address'),
              _buildDetailRow('CONSTRUCTION OF PREMISES', bill.policy?.construction ?? '1st Class'),
              _buildDetailRow('OWNER OF PREMISES', bill.policy?.owner ?? 'The Insured.'),
              _buildDetailRow('OCCUPATION OF PREMISES', bill.policy?.usedAs ?? 'Shop-Cum-Godown Only.'),
              pw.SizedBox(height: 5),

              pw.Table(
                columnWidths: { 0: const pw.FlexColumnWidth(3), 1: const pw.FlexColumnWidth(0.5), 2: const pw.FlexColumnWidth(1) },
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Premium Rate', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Premium Payable', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Fire@ ${bill.fire}%', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.fireAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('R&SD @ ${bill.rsd}%', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.rsdAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Net Premium', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.netPremium), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('VAT @ ${bill.tax}%', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.taxAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Gross Premium:', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.grossPremium), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                ]
              ),

              pw.SizedBox(height: 10),
              pw.Text('Clauses / Warranties :', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                'Subject to Mortgage Clause attached hereto.\nSubject to Tariff warranty \'B\' & General warranties 1 to 6 as per form A attached hereto.\nWarranted that Terrorism & Sabotage Risks are excluded under this Policy\nThis Policy is issued subject to terms, conditions and warranties printed on the Policy.',
                style: pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.left,
              ),

              pw.Spacer(),
              pw.Text('In witness where of the undersigned acting on behalf of and under the authority of the company has hereto set his hand at Head Office, Dhaka.', style: pw.TextStyle(fontSize: 8)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('MR. No. ${receipt.id} & Date : ${receipt.date != null ? DateFormat('dd-MMM-yy').format(receipt.date!) : 'N/A'}', style: pw.TextStyle(fontSize: 8)),
                      pw.Text('Renewal Fire Policy No.:', style: pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 30),
                      pw.Text('Checked By', style: pw.TextStyle(fontSize: 8)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('Fully Re-insured with', style: pw.TextStyle(fontSize: 8)),
                      pw.Text('Sadharan Bima Corporation', style: pw.TextStyle(fontSize: 8)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('For & on behalf of', style: pw.TextStyle(fontSize: 8)),
                      pw.Text(bill.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 30),
                      pw.SizedBox(width: 100, child: pw.Divider(thickness: 1)),
                      pw.Text('Authorized Officer', style: pw.TextStyle(fontSize: 8)),
                    ]
                  ),
                ]
              )
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateFireMoneyReceiptPdf(FireMoneyReceipt receipt) async {
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          final String bankStr = receipt.bill?.policy?.bank?.name != null ? "${receipt.bill?.policy?.bank?.name}, " : "";
          final String branchStr = receipt.bill?.policy?.branch?.name != null ? "${receipt.bill?.policy?.branch?.name}, " : "";
          final String insuredNameStr = "$bankStr$branchStr${receipt.bill?.policy?.policyholder ?? ''}";
          final String addressStr = receipt.bill?.policy?.address ?? '';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Crystal', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic, color: PdfColors.blue900)),
                      pw.Text(receipt.issuingOffice?.name ?? receipt.bill?.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                      pw.Text(receipt.issuingOffice?.address ?? '${receipt.bill?.policy?.branch?.name ?? ''} Branch', style: pw.TextStyle(fontSize: 11)),
                      pw.Text('Tel: ${receipt.issuingOffice?.phone ?? 'N/A'}\nMob: ${receipt.issuingOffice?.mobile ?? 'N/A'}', style: pw.TextStyle(fontSize: 10, color: PdfColors.blue)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('ORIGINAL', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                      pw.SizedBox(height: 5),
                      pw.Text('MONEY RECEIPT', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text('MUSHAK : 6.3', style: pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Hotline', style: pw.TextStyle(fontSize: 12)),
                      pw.Text('09678771766', style: pw.TextStyle(fontSize: 12)),
                    ]
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.SizedBox(width: 120, child: pw.Text('Issuing Office', style: pw.TextStyle(fontSize: 10))),
                  pw.Text(': ${receipt.issuingOffice?.name ?? ''}', style: pw.TextStyle(fontSize: 10)),
                ]
              ),
              pw.Row(
                children: [
                  pw.SizedBox(width: 120, child: pw.Text('Money Receipt No', style: pw.TextStyle(fontSize: 10))),
                  pw.Text(': ${receipt.id}', style: pw.TextStyle(fontSize: 10)),
                ]
              ),
              pw.Row(
                children: [
                  pw.SizedBox(width: 120, child: pw.Text('Class of Insurance', style: pw.TextStyle(fontSize: 10))),
                  pw.Text(': ${receipt.classOfInsurance ?? 'Fire'}', style: pw.TextStyle(fontSize: 10)),
                  pw.Spacer(),
                  pw.Text('Date : ${receipt.date != null ? DateFormat('dd-MM-yyyy').format(receipt.date!) : ''}', style: pw.TextStyle(fontSize: 10)),
                ]
              ),
              pw.SizedBox(height: 15),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 120, child: pw.Text('Received with thanks from', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(child: pw.Text('$insuredNameStr, $addressStr', style: pw.TextStyle(fontSize: 10))),
                ]
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 120, child: pw.Text('The sum of', style: pw.TextStyle(fontSize: 10))),
                  pw.Expanded(child: pw.Text('Tk. ${NumberFormat('#,##,###.00').format(receipt.bill?.grossPremium ?? 0)}', style: pw.TextStyle(fontSize: 10))),
                ]
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 120, child: pw.Text('Mode of Payment', style: pw.TextStyle(fontSize: 10))),
                  pw.Expanded(child: pw.Text('${receipt.modeOfPayment ?? ''}', style: pw.TextStyle(fontSize: 10))),
                  pw.Text('Dated   ${receipt.date != null ? DateFormat('dd-MM-yyyy').format(receipt.date!) : ''}', style: pw.TextStyle(fontSize: 10)),
                ]
              ),
              pw.Divider(),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 120, child: pw.Text('Issued against', style: pw.TextStyle(fontSize: 10))),
                  pw.Expanded(child: pw.Text('${receipt.issuedAgainst ?? ''}', style: pw.TextStyle(fontSize: 10))),
                ]
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.SizedBox(
                width: 250,
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Premium', style: pw.TextStyle(fontSize: 10))),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('BDT', style: pw.TextStyle(fontSize: 10))),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(receipt.bill?.netPremium ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10))),
                      ]
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('VAT', style: pw.TextStyle(fontSize: 10))),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('BDT', style: pw.TextStyle(fontSize: 10))),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(receipt.bill?.taxAmount ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10))),
                      ]
                    ),
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Total', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('BDT', style: pw.TextStyle(fontSize: 10))),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(receipt.bill?.grossPremium ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                      ]
                    ),
                  ]
                )
              ),
              pw.Spacer(),
              pw.Center(child: pw.Text('This RECEIPT is computer generated, authorized signature is not required.', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
              pw.Container(
                width: double.infinity,
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Center(child: pw.Text('Receipt valid subject to encashment of cheque/P.O./D.D.', style: pw.TextStyle(fontSize: 9)))
              ),
              pw.Text('* Note: If have any complain about Insurance, call 16130.', style: pw.TextStyle(fontSize: 8)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // --------------------------------------------------------------------------
  // MARINE PDFs
  // --------------------------------------------------------------------------

  static pw.Widget _buildMarineHeader(MarineBill bill, String title, {String? receiptNo, String? dateStr, IssueOffice? issuingOffice}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(issuingOffice?.name ?? 'Islami Insurance Com. Bangladesh Ltd', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Text(issuingOffice?.address ?? 'DR Tower (14th floor), 65/2/2,Purana Paltan, Dhaka-1000.', style: pw.TextStyle(fontSize: 10)),
        pw.Text('Tel: ${issuingOffice?.phone ?? '02478853405'}, Mob: ${issuingOffice?.mobile ?? '01763001787'}', style: pw.TextStyle(fontSize: 10)),
        pw.Text('Fax: ${issuingOffice?.fax ?? '+88 02 55112742'}', style: pw.TextStyle(fontSize: 10)),
        pw.Text('Email: ${issuingOffice?.email ?? 'infociclbd.com'}', style: pw.TextStyle(fontSize: 10)),
        pw.Text('Web: ${issuingOffice?.website ?? 'www.islamiinsurance.com'}', style: pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 15),
        pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 15),
      ]
    );
  }

  static Future<void> generateMarineBillPdf(MarineBill bill) async {
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          final String bankStr = bill.marineDetails?.bank?.name != null ? "${bill.marineDetails?.bank?.name}, " : "";
          final String branchStr = bill.marineDetails?.branch?.name != null ? "${bill.marineDetails?.branch?.name}, " : "";
          final String insuredNameStr = "$bankStr$branchStr${bill.marineDetails?.policyholder ?? ''}";
          final String addressStr = bill.marineDetails?.address ?? '';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildMarineHeader(bill, 'Marine Bill Information'),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Marine Bill No'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${bill.id}'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Issue Date'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${bill.marineDetails?.date != null ? DateFormat('yyyy-MM-dd').format(bill.marineDetails!.date!) : 'N/A'}'))),
                  ])
                ]
              ),
              pw.SizedBox(height: 15),
              pw.Text('Insured Details', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(3) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Bank Name')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('$bankStr$branchStr')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Policyholder')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.policyholder ?? ''}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Address')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(addressStr)),
                  ]),
                ]
              ),
              pw.SizedBox(height: 15),
              pw.Text('Segregation of The Sum Insured', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(2), 1: const pw.FlexColumnWidth(1) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Sum Insured Usd'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.sumInsuredUsd ?? 0} Usd')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Usd Rate')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.usdRate ?? 0}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Sum Insured')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.sumInsured ?? 0} TK')),
                  ]),
                ]
              ),
              pw.SizedBox(height: 15),
              pw.Text('Situation', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(1) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Voyage From'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${bill.marineDetails?.voyageFrom ?? 'India'}'))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Voyage To')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.voyageTo ?? 'Dhaka'}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Interest Insured')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.stockItem ?? 'Benapole Port'}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Coverage')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.coverage ?? 'Lorry Risk Only'}')),
                  ]),
                ]
              ),
              pw.SizedBox(height: 15),
              pw.Text('Premium and Tax', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(2), 1: const pw.FlexColumnWidth(2), 2: const pw.FlexColumnWidth(1), 3: const pw.FlexColumnWidth(1) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Description'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Rate'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('BDT'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Amount'))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Marine Rate')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineRate}% on ${bill.marineDetails?.sumInsured ?? 0}')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.marineAmount))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('War/SRCC Rate')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.warSrccRate}% on ${bill.marineDetails?.sumInsured ?? 0}')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.warSrccAmount))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Net Premium')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.netPremium))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Tax on Net Premium')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.tax}% on ${bill.netPremium}')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.taxAmount))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Stamp Duty')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.stampDuty))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Gross Premium')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.grossPremium))),
                  ]),
                ]
              ),
            ]
          );
        }
      )
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateMarineCoverNotePdf(MarineMoneyReceipt receipt) async {
    final bill = receipt.marinebill!;
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          final String bankStr = bill.marineDetails?.bank?.name != null ? "${bill.marineDetails?.bank?.name}, " : "";
          final String branchStr = bill.marineDetails?.branch?.name != null ? "${bill.marineDetails?.branch?.name}, " : "";
          final String insuredNameStr = "$bankStr$branchStr${bill.marineDetails?.policyholder ?? ''}";
          final String addressStr = bill.marineDetails?.address ?? '';
          final String dateStr = bill.marineDetails?.date != null ? DateFormat('dd-MM-yyyy').format(bill.marineDetails!.date!) : 'N/A';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildMarineHeader(bill, 'Marine Cover Note', issuingOffice: receipt.issuingOffice),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Marine Cover Note No'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${bill.marineDetails?.sysNumber ?? ''}'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Marine Bill No'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${bill.id}'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Date'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text(dateStr))),
                  ])
                ]
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(2) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('The Insured Name & Address'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('$insuredNameStr\n$addressStr', textAlign: pw.TextAlign.center))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(
                      'Having this day proposed to effect an insurance against ${bill.marineDetails?.coverage ?? 'Lorry Risk Only'} from ${bill.marineDetails?.voyageFrom ?? 'India'}, To ${bill.marineDetails?.voyageTo ?? 'Dhaka'}, $dateStr, on the usual terms and conditions of the company\'s Marine Policy.\nHaving paid the undernoted premium in cash/cheque/P.O/D.D./C.A, the following Property is hereby insured to the extent of TK ${bill.marineDetails?.sumInsured ?? 0} Only in the manner specified below:',
                      textAlign: pw.TextAlign.justify
                    )),
                  ]),
                ]
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(2) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Sum Insured Usd')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${bill.marineDetails?.sumInsuredUsd ?? 0} Usd'))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Usd Rate')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.usdRate ?? 0}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Sum Insured in Taka')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK. ${bill.marineDetails?.sumInsured ?? 0}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Sum Insured')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK. ${bill.marineDetails?.sumInsured ?? 0}')),
                  ]),
                ]
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(1) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Voyage From'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${bill.marineDetails?.voyageFrom ?? 'India'}'))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Voyage To')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.voyageTo ?? 'Dhaka'}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Interest Insured')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.stockItem ?? 'Benapole Port'}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Coverage')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.coverage ?? 'Lorry Risk Only'}')),
                  ]),
                ]
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(2), 1: const pw.FlexColumnWidth(2), 2: const pw.FlexColumnWidth(1), 3: const pw.FlexColumnWidth(1) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Description'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Rate'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('BDT'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Amount'))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Marine Rate')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineRate}% on ${bill.marineDetails?.sumInsured ?? 0}')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.marineAmount))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('War/SRCC Rate')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.warSrccRate}% on ${bill.marineDetails?.sumInsured ?? 0}')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.warSrccAmount))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Net Premium')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.netPremium))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Tax on Net Premium')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.tax}% on ${bill.netPremium}')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.taxAmount))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Stamp Duty')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.stampDuty))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Gross Premium')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('TK')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(NumberFormat('#,##,###.00').format(bill.grossPremium))),
                  ]),
                ]
              ),
              pw.Spacer(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Renewal No:', style: pw.TextStyle(fontSize: 10)),
                      pw.Text('${bill.marineDetails?.sysNumber ?? ''} / ${bill.id} / $dateStr', style: pw.TextStyle(fontSize: 10)),
                      pw.Text('Checked by', style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 5),
                      pw.Text('________________', style: pw.TextStyle(fontSize: 10)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('Fully Re-insured with', style: pw.TextStyle(fontSize: 10)),
                      pw.Text('Sadharan Bima Corporation', style: pw.TextStyle(fontSize: 10)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('For & on behalf of', style: pw.TextStyle(fontSize: 10)),
                      pw.Text('Islami Insurance Com. Ltd.', style: pw.TextStyle(fontSize: 10)),
                      pw.Text('Authorized Officer', style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 5),
                      pw.Text('______________________', style: pw.TextStyle(fontSize: 10)),
                    ]
                  )
                ]
              )
            ]
          );
        }
      )
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateMarineMoneyReceiptPdf(MarineMoneyReceipt receipt) async {
    final bill = receipt.marinebill!;
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          final String bankStr = bill.marineDetails?.bank?.name != null ? "${bill.marineDetails?.bank?.name}, " : "";
          final String branchStr = bill.marineDetails?.branch?.name != null ? "${bill.marineDetails?.branch?.name}, " : "";
          final String insuredNameStr = "$bankStr$branchStr\n${bill.marineDetails?.policyholder ?? ''}";
          final String addressStr = bill.marineDetails?.address ?? '';
          final String dateStr = receipt.date != null ? DateFormat('dd-MM-yyyy').format(receipt.date!) : 'N/A';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildMarineHeader(bill, 'Marine Money Receipt', issuingOffice: receipt.issuingOffice),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Fire Bill No'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${bill.id}'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Date'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text(dateStr))),
                  ])
                ]
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(2) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Issuing Office', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('${receipt.issuingOffice?.name ?? 'Dhaka'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Money Receipt No')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${receipt.id}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Class of Insurance')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${receipt.classOfInsurance ?? 'Marine Insurance'}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Received with thanks from')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('$insuredNameStr\n$addressStr')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('The sum USD')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.sumInsuredUsd ?? 0} USD')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Rate')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.usdRate ?? 0} TK')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('The sum of')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${bill.marineDetails?.sumInsured ?? 0} TK')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Mode Of Payment')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${receipt.modeOfPayment ?? 'Bank Transfer'}')),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Issued Against')),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('${receipt.issuedAgainst ?? bill.marineDetails?.sysNumber ?? ''}')),
                  ]),
                ]
              ),
              pw.SizedBox(height: 15),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: { 0: const pw.FlexColumnWidth(2), 1: const pw.FlexColumnWidth(1), 2: const pw.FlexColumnWidth(1) },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Net Premium', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('BDT', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text(NumberFormat('#,##,###.00').format(bill.netPremium), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Tax'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('BDT'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text(NumberFormat('#,##,###.00').format(bill.taxAmount)))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('Gross Premium'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text('BDT'))),
                    pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Center(child: pw.Text(NumberFormat('#,##,###.00').format(bill.grossPremium)))),
                  ]),
                ]
              ),
              pw.SizedBox(height: 20),
              pw.Center(child: pw.Text('This receipt is computer-generated; an authorized signature is not required.', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 5),
              pw.Center(child: pw.Text('Receipt is valid subject to the encashment of cheque/P.O./D.D.', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 5),
              pw.Center(child: pw.Text('Note: For any complaints regarding insurance, please call 16130.', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
            ]
          );
        }
      )
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateMarinePolicySchedulePdf(MarineMoneyReceipt receipt) async {
    final bill = receipt.marinebill!;
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          final String bankStr = bill.marineDetails?.bank?.name != null ? "${bill.marineDetails?.bank?.name}, " : "";
          final String branchStr = bill.marineDetails?.branch?.name != null ? "${bill.marineDetails?.branch?.name}, " : "";
          final String insuredNameStr = "$bankStr$branchStr${bill.marineDetails?.policyholder ?? ''}";
          final String addressStr = bill.marineDetails?.address ?? '';
          final String dateStr = bill.marineDetails?.date != null ? DateFormat('dd-MM-yyyy').format(bill.marineDetails!.date!) : 'N/A';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top Header
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(receipt.issuingOffice?.name ?? 'Islami Insurance Com. Bangladesh Ltd', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                        pw.Text(receipt.issuingOffice?.address ?? 'DR Tower (14th floor), 65/2/2,Purana Paltan, Dhaka-1000.', style: pw.TextStyle(fontSize: 8)),
                        pw.Text('Tel: ${receipt.issuingOffice?.phone ?? '02478853405'}, Mob: ${receipt.issuingOffice?.mobile ?? '01763001787'}', style: pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(receipt.issuingOffice?.name ?? 'Islami Insurance Com. Bangladesh Ltd', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: pw.BoxDecoration(border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(15), color: PdfColors.grey200),
                            child: pw.Text('MARINE POLICY', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text('THE SCHEDULE', style: pw.TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Corporate Office', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Fax: ${receipt.issuingOffice?.fax ?? '+88 02 55112742'}\nEmail: ${receipt.issuingOffice?.email ?? 'infociclbd.com'}\nWeb: ${receipt.issuingOffice?.website ?? 'www.islamiinsurance.com'}', 
                          textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Schedule Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('The Company : Islami Insurance Com. Bangladesh Ltd', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
                          pw.Text('POLICY NUMBER', style: pw.TextStyle(fontSize: 9)),
                          pw.Text('${bill.marineDetails?.sysNumber ?? 'N/A'}', style: pw.TextStyle(fontSize: 9)),
                          pw.Text('IN LIEU OF COVER NOTE NO.', style: pw.TextStyle(fontSize: 9)),
                          pw.Text('${bill.marineDetails?.sysNumber ?? 'N/A'}', style: pw.TextStyle(fontSize: 9)),
                      ])),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('The Insured Name\nand Address:', style: pw.TextStyle(fontSize: 9)),
                            pw.SizedBox(width: 10),
                            pw.Expanded(child: pw.Text('$insuredNameStr, $addressStr', style: pw.TextStyle(fontSize: 9)))
                          ]
                      )),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('IN LIEU OF ADDENDUM NO.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('The Period :      Date : $dateStr', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('To:    N/A           Until 4. P.M (B.S.T)', style: pw.TextStyle(fontSize: 9))),
                    ]
                  )
                ]
              ),

              pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: 0.5)),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Column(
                    children: [
                        pw.Text('Description of the Property Insured', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                        pw.Text('The following interest being the property of the insured or held by them in trust or on commission or on joint account with others for which they are legally liable for loss or damage by the perils mentioned hereunder :', style: pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.justify),
                    ]
                )
              ),

              pw.Table(
                columnWidths: { 0: const pw.FlexColumnWidth(3), 1: const pw.FlexColumnWidth(0.5), 2: const pw.FlexColumnWidth(1) },
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('|| SEGREGATION OF THE SUM INSURED ||', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('SUM INSURED', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('USD Rate: ${bill.marineDetails?.usdRate ?? 0}, Sum USD: ${bill.marineDetails?.sumInsuredUsd ?? 0}', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.marineDetails?.sumInsured ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('(In word : Taka ... Only)', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.marineDetails?.sumInsured ?? 0), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                ]
              ),

              pw.SizedBox(height: 5),
              _buildDetailRow('INTEREST INSURED', bill.marineDetails?.stockItem ?? 'N/A'),
              _buildDetailRow('RISK(S) COVERED', bill.marineDetails?.coverage ?? 'Lorry Risk Only'),
              _buildDetailRow('VOYAGE FROM', bill.marineDetails?.voyageFrom ?? 'India'),
              _buildDetailRow('VOYAGE TO', bill.marineDetails?.voyageTo ?? 'Dhaka'),
              pw.SizedBox(height: 5),

              pw.Table(
                columnWidths: { 0: const pw.FlexColumnWidth(3), 1: const pw.FlexColumnWidth(0.5), 2: const pw.FlexColumnWidth(1) },
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Premium Rate', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Premium Payable', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Marine@ ${bill.marineRate}%', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.marineAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('War/SRCC @ ${bill.warSrccRate}%', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.warSrccAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Net Premium', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.netPremium), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('VAT @ ${bill.tax}%', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.taxAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Stamp Duty', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.stampDuty), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Gross Premium:', style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Tk.', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(NumberFormat('#,##,###.00').format(bill.grossPremium), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 9))),
                    ]
                  ),
                ]
              ),

              pw.SizedBox(height: 10),
              pw.Text('Clauses / Warranties :', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                'Subject to Marine Clause attached hereto.\nWarranted that Terrorism & Sabotage Risks are excluded under this Policy\nThis Policy is issued subject to terms, conditions and warranties printed on the Policy.',
                style: pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.left,
              ),

              pw.Spacer(),
              pw.Text('In witness where of the undersigned acting on behalf of and under the authority of the company has hereto set his hand at Head Office, Dhaka.', style: pw.TextStyle(fontSize: 8)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('MR. No. ${receipt.id} & Date : ${receipt.date != null ? DateFormat('dd-MMM-yy').format(receipt.date!) : 'N/A'}', style: pw.TextStyle(fontSize: 8)),
                      pw.Text('Marine Policy No.:', style: pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 30),
                      pw.Text('Checked By', style: pw.TextStyle(fontSize: 8)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('Fully Re-insured with', style: pw.TextStyle(fontSize: 8)),
                      pw.Text('Sadharan Bima Corporation', style: pw.TextStyle(fontSize: 8)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('For & on behalf of', style: pw.TextStyle(fontSize: 8)),
                      pw.Text('Islami Insurance Com. Bangladesh Ltd', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 30),
                      pw.SizedBox(width: 100, child: pw.Divider(thickness: 1)),
                      pw.Text('Authorized Officer', style: pw.TextStyle(fontSize: 8)),
                    ]
                  ),
                ]
              )
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
