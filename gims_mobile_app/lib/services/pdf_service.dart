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
  static Future<void> generateFireBillPdf(FireBill bill) async {
    final pdf = pw.Document();

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
                        pw.Text('Fire Insurance Premium Bill', style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Bill ID: #${bill.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Date: ${bill.policy?.date != null ? DateFormat('dd MMM, yyyy').format(bill.policy!.date!) : 'N/A'}'),
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
                    pw.Expanded(child: _buildInfoItem('Policyholder', bill.policy?.policyholder ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Bank Name', bill.policy?.bank?.name ?? 'N/A')),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(child: _buildInfoItem('Branch', bill.policy?.branch?.name ?? 'N/A')),
                    pw.Expanded(child: _buildInfoItem('Policy Number', bill.policy?.sysNumber ?? 'N/A')),
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
                    _buildTableRow(['Fire Premium', '${bill.fire}%', NumberFormat('#,##,###.00').format(bill.fireAmount)]),
                    _buildTableRow(['RSD Premium', '${bill.rsd}%', NumberFormat('#,##,###.00').format(bill.rsdAmount)]),
                    _buildTableRow(['Net Premium', '-', NumberFormat('#,##,###.00').format(bill.netPremium)]),
                    _buildTableRow(['VAT (Tax)', '${bill.tax}%', NumberFormat('#,##,###.00').format(bill.taxAmount)]),
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

  static Future<void> generateFireMoneyReceiptPdf(FireMoneyReceipt receipt) async {
    final pdf = pw.Document();

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
                    pw.Expanded(child: _buildInfoItem('Bill ID', receipt.bill?.id != null ? '#${receipt.bill!.id}' : 'N/A')),
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
    final pdf = pw.Document();

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
                    _buildTableRow(['Marine Premium', '${bill.marineRate}%', '-']),
                    _buildTableRow(['War & SRCC Premium', '${bill.warSrccRate}%', '-']),
                    _buildTableRow(['Net Premium', '-', NumberFormat('#,##,###.00').format(bill.netPremium)]),
                    _buildTableRow(['VAT (Tax)', '${bill.tax}%', '-']),
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
    final pdf = pw.Document();

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
                    pw.Expanded(child: _buildInfoItem('Bill ID', receipt.marinebill?.id != null ? '#${receipt.marinebill!.id}' : 'N/A')),
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
}
