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

  static Future<void> generateFireBillPdf(FireBill bill) async {
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

          final String periodFrom = bill.policy?.periodFrom != null ? DateFormat('dd-MMM-yy').format(bill.policy!.periodFrom!) : 'N/A';
          final String periodTo = bill.policy?.periodTo != null ? DateFormat('dd-MMM-yy').format(bill.policy!.periodTo!) : 'N/A';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. Top Header Section (3 Columns)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Branch Info
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Crystal', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic, color: PdfColors.blue900)),
                        pw.Text(bill.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                        pw.Text('${bill.policy?.branch?.name ?? ''} Branch', style: pw.TextStyle(fontSize: 10)),
                        pw.Text('Tel: N/A\nMob: N/A', style: pw.TextStyle(fontSize: 9, color: PdfColors.blue)),
                        pw.SizedBox(height: 5),
                        pw.Text('FIRE COVER NOTE NO : ${bill.policy?.sysNumber ?? ''}', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      ],
                    ),
                  ),
                  // Center: Title
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(bill.policy?.company?.name ?? 'Crystal Insurance PLC', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                        pw.Text('Fire Cover Note', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                        pw.Text('SL# ${bill.id ?? ''}', style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  // Right: Corporate Office
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Corporate Office', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                        pw.Text('DR Tower (14th floor), 65/2/2,\nBox Culvert Road, Purana\nPaltan, Dhaka-1000\nTel: 88-02-55112733-38\nFax: 88-029567205\nE-mail: info@crystalins.com\nWebsite: www.crystalins.com', 
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
              
              // 2. Insured Name & Address
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
              
              // 3. Declaration Paragraph
              pw.SizedBox(height: 15),
              pw.Text(
                'Having this day proposed to effect an insurance against Fire and/or lighting for a period of 12 (Twelve) months from $periodFrom to $periodTo on the usual terms and conditions of the company\'s Fire Policy and having paid the undernoted premium in cash /cheque /P.O/D.D./C/A the following property is hereby insured to the extent of Taka ${bill.policy?.sumInsured != null ? NumberFormat('#,##,###').format(bill.policy!.sumInsured) : '0'} Only in the manner specified below:',
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700, lineSpacing: 1.5),
                textAlign: pw.TextAlign.justify,
              ),

              // 4. First Table: Segregation of The Sum Insured
              pw.SizedBox(height: 10),
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(0.5),
                  2: const pw.FlexColumnWidth(1),
                },
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

              // 5. Property & Premises Details Section
              pw.SizedBox(height: 15),
              _buildDetailRow('Property Insured', bill.policy?.interestInsured ?? 'Covering the risk on Stock Of All Kinds'),
              _buildDetailRow('Risk(s) Covered', bill.policy?.coverage ?? 'Fire and/or Lightning, Riot & Strike Damage risks only'),
              _buildDetailRow('Construction of Premises', bill.policy?.construction ?? '1st Class'),
              _buildDetailRow('Owner of Premises', bill.policy?.owner ?? 'The Insured.'),
              _buildDetailRow('Occupation of Premises', bill.policy?.usedAs ?? 'Shop-Cum-Godown Only.'),
              _buildDetailRow('Situation of Premises', bill.policy?.location ?? 'Address'),
              _buildDetailRow('Warranty', 'This Covernote is issued, subject to Terms, Conditions and Warranties of the Policy.'),

              // 6. Second Table: Premium Payable
              pw.SizedBox(height: 15),
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(0.5),
                  2: const pw.FlexColumnWidth(1),
                },
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

              // 7. Footer Section
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
                      pw.Text('MR. No. N/A & Date : ${bill.policy?.date != null ? DateFormat('dd-MMM-yy').format(bill.policy!.date!) : 'N/A'}', style: pw.TextStyle(fontSize: 9)),
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
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(receipt.bill?.policy?.company?.name?.toUpperCase() ?? 'GENERAL INSURANCE MANAGEMENT', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                        pw.Text('Money Receipt - Fire Insurance', style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Receipt ID: #${receipt.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Date: ${receipt.date != null ? DateFormat('dd MMM, yyyy').format(receipt.date!) : 'N/A'}'),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.SizedBox(height: 20),

                // Receipt Info
                pw.Text('RECEIPT INFORMATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Issuing Office', receipt.issuingOffice ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Class of Insurance', receipt.classOfInsurance ?? 'N/A')),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Mode of Payment', receipt.modeOfPayment ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Issued Against', receipt.issuedAgainst ?? 'N/A')),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Policyholder', receipt.bill?.policy?.policyholder ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Branch', receipt.bill?.policy?.branch?.name ?? 'N/A')),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Bill ID', receipt.bill?.id != null ? '#${receipt.bill!.id}' : 'N/A')),
                    pw.Spacer(),
                  ],
                ),

                pw.SizedBox(height: 30),
                
                // Total
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                      child: pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Text('TOTAL AMOUNT: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                          pw.Text('TK ${receipt.bill != null ? NumberFormat('#,##,###.00').format(receipt.bill!.grossPremium) : 'N/A'}', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, color: PdfColors.blue700)),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.Spacer(),
                pw.Divider(),
                pw.Center(child: pw.Text('Thank you for choosing our services!', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey))),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateMarineBillPdf(MarineBill bill) async {
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('GENERAL INSURANCE MANAGEMENT', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                        pw.Text('Marine Insurance Premium Bill', style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Bill ID: #${bill.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Date: ${bill.marineDetails?.date != null ? DateFormat('dd MMM, yyyy').format(bill.marineDetails!.date!) : 'N/A'}'),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.SizedBox(height: 20),

                // Client Info
                pw.Text('CLIENT INFORMATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Policyholder', bill.marineDetails?.policyholder ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Bank Name', bill.marineDetails?.bank?.name ?? 'N/A')),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Branch', bill.marineDetails?.branch?.name ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Policy Number', bill.marineDetails?.sysNumber ?? 'N/A')),
                  ],
                ),

                pw.SizedBox(height: 30),
                // Bill Details Table
                pw.Text('BILLING DETAILS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    _buildTableRow(['Description', 'Rate (%)', 'Amount (TK)'], isHeader: true),
                    _buildTableRow(['Marine Premium', '${bill.marineRate}%', bill.marineAmount > 0 ? NumberFormat('#,##,###.00').format(bill.marineAmount) : '-']),
                    _buildTableRow(['War & SRCC Premium', '${bill.warSrccRate}%', bill.warSrccAmount > 0 ? NumberFormat('#,##,###.00').format(bill.warSrccAmount) : '-']),
                    _buildTableRow(['Net Premium', '-', NumberFormat('#,##,###.00').format(bill.netPremium)]),
                    _buildTableRow(['VAT (Tax)', '${bill.tax}%', bill.taxAmount > 0 ? NumberFormat('#,##,###.00').format(bill.taxAmount) : '-']),
                    _buildTableRow(['Stamp Duty', '-', NumberFormat('#,##,###.00').format(bill.stampDuty)]),
                  ],
                ),
                
                // Total
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                      child: pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Text('TOTAL PAYABLE: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                          pw.Text('TK ${NumberFormat('#,##,###.00').format(bill.grossPremium)}', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, color: PdfColors.blue700)),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.Spacer(),
                pw.Divider(),
                pw.Center(child: pw.Text('Thank you for choosing our services!', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey))),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateMarineMoneyReceiptPdf(MarineMoneyReceipt receipt) async {
    final pdf = await _createDocument();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('GENERAL INSURANCE MANAGEMENT', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                        pw.Text('Money Receipt - Marine Insurance', style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Receipt ID: #${receipt.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Date: ${receipt.date != null ? DateFormat('dd MMM, yyyy').format(receipt.date!) : 'N/A'}'),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.SizedBox(height: 20),

                // Receipt Info
                pw.Text('RECEIPT INFORMATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Issuing Office', receipt.issuingOffice ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Class of Insurance', receipt.classOfInsurance ?? 'N/A')),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Mode of Payment', receipt.modeOfPayment ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Issued Against', receipt.issuedAgainst ?? 'N/A')),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Policyholder', receipt.marinebill?.marineDetails?.policyholder ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Branch', receipt.marinebill?.marineDetails?.branch?.name ?? 'N/A')),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Bill ID', receipt.marinebill?.id != null ? '#${receipt.marinebill!.id}' : 'N/A')),
                    pw.Spacer(),
                  ],
                ),

                pw.SizedBox(height: 30),
                
                // Total
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                      child: pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Text('TOTAL AMOUNT: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                          pw.Text('TK ${receipt.marinebill != null ? NumberFormat('#,##,###.00').format(receipt.marinebill!.grossPremium) : 'N/A'}', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, color: PdfColors.blue700)),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.Spacer(),
                pw.Divider(),
                pw.Center(child: pw.Text('Thank you for choosing our services!', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey))),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
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
}
