// import 'dart:typed_data';
// import 'package:data/models/safety_inspection_model.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:intl/intl.dart';

// class SafetyInspectionPdfService {
//   static Future<Uint8List> generatePdf(
//     SafetyInspectionModel formData, {
//     Uint8List? logoImageBytes,
//   }) async {
//     final pdf = pw.Document();

//     // Load logo image
//     final logoImage = logoImageBytes != null
//         ? pw.MemoryImage(logoImageBytes)
//         : await _loadDefaultLogoImage();

//     // Add first page
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(12),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               _buildHeader(formData, logoImage),
//               pw.SizedBox(height: 16),

//               // Customer Information section
//               _buildCustomerInfoSection(formData),
//               pw.SizedBox(height: 12),

//               pw.SizedBox(height: 12),
//               _buildPageFooter(1),
//             ],
//           );
//         },
//       ),
//     );

// pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(12),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Insider Cab section
//               _buildCompleteSectionWithActionData(
//                 'INSIDER CAB',
//                 [
//                   'Drivers seat*',
//                   'Seat belts*',
//                   'Mirrors*',
//                   'Glass & Road View*',
//                   'Accessibility Features*',
//                   'Horn*',
//                 ],
//                 formData,
//                 formData.insiderCabComments,
//                 false, // P, F, N/A, R
//               ),
//               pw.SizedBox(height: 12),
//               _buildPageFooter(2),
//             ],
//           );
//         },
//       ),
//     );

//     // Add second page
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(10),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Vehicle Ground Level section
//               _buildCompleteSectionWithActionData(
//                 'VEHICLE GROUND LEVEL',
//                 [
//                   'Security of body*',
//                   'Exhaust emission*',
//                   'Road wheels & hubs*',
//                   'Size & types of tyres*',
//                   'Condition of tyres*',
//                   'Bumper bars*',
//                 ],
//                 formData,
//                 formData.vehicleGroundLevelComments,
//                 false, // P, F, N/A, R
//               ),
//               pw.SizedBox(height: 8),
//               _buildPageFooter(3),
//             ],
//           );
//         },
//       ),
//     );

//     // Add third page
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(12),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Brake Performance section
//               _buildCompleteSectionWithActionData(
//                 'BRAKE PERFORMANCE',
//                 [
//                   'Service Brake Performance*',
//                   'Brake Performance*',
//                   'Parking Brake Performance*',
//                 ],
//                 formData,
//                 formData.brakePerformanceComments,
//                 false, // P, F, N/A, R
//               ),
//               pw.SizedBox(height: 12),
//               _buildPageFooter(4),
//             ],
//           );
//         },
//       ),
//     );
    
//      pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(12),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // General Servicing section
//               _buildCompleteSectionWithActionData(
//                 'GENERAL SERVICING',
//                 [
//                   'Vehicle excise duty*',
//                   'PSV*',
//                   'Technograph calibration*',
//                 ],
//                 formData,
//                 formData.generalServicingComments,
//                 false, // P, F, N/A, R
//               ),
//               pw.SizedBox(height: 12),
//               _buildPageFooter(5),
//             ],
//           );
//         },
//       ),
//     );

//     // Add fourth page for other sections
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(12),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.SizedBox(height: 10),

//               // Inspection Report section
//               _buildSimpleSection('INSPECTION REPORT', {
//                 'Seen on': formData.seenOn.isNotEmpty
//                     ? formData.seenOn
//                     : 'Not provided',
//                 'Signed by': formData.signedBy.isNotEmpty
//                     ? formData.signedBy
//                     : 'Not provided',
//                 'TM Operator': formData.tmOperator.isNotEmpty
//                     ? formData.tmOperator
//                     : 'Not provided',
//               }),
//               pw.SizedBox(height: 12),

//               // Comments on faults found section
//               _buildSimpleSection('COMMENTS ON FAULTS FOUND', {
//                 'Check Number': formData.checkNumber.isNotEmpty
//                     ? formData.checkNumber
//                     : 'Not provided',
//                 'Fault Details': formData.faultDetails.isNotEmpty
//                     ? formData.faultDetails
//                     : 'Not provided',
//                 'Signature Of Inspector': formData.signatureOfInspector.isNotEmpty
//                     ? formData.signatureOfInspector
//                     : 'Not provided',
//                 'Name Of Inspector': formData.nameOfInspector.isNotEmpty
//                     ? formData.nameOfInspector
//                     : 'Not provided',
//               }),
//               pw.SizedBox(height: 12),

//               // Action taken on faults found section
//               _buildSimpleSection('ACTION TAKEN ON FAULTS FOUND', {
//                 'Action taken on fault': formData.actionTakenOnFault.isNotEmpty
//                     ? formData.actionTakenOnFault
//                     : 'Not provided',
//                 'Rectified by': formData.rectifiedBy.isNotEmpty
//                     ? formData.rectifiedBy
//                     : 'Not provided',
//               }),
//               pw.SizedBox(height: 12),

//               // Consider defects have section
//               _buildSimpleSection('CONSIDER DEFECTS HAVE', {
//                 'Rectified satisfactorily':
//                     formData.rectifiedSatisfactorily.isNotEmpty
//                         ? formData.rectifiedSatisfactorily
//                         : 'Not provided',
//                 'Needs more work done': formData.needsMoreWorkDone.isNotEmpty
//                     ? formData.needsMoreWorkDone
//                     : 'Not provided',
//                 'Signature Of Mechanic':
//                     formData.signatureOfMechanic.isNotEmpty
//                         ? formData.signatureOfMechanic
//                         : 'Not provided',
//                 'Date': formData.date.isNotEmpty
//                     ? formData.date
//                     : 'Not provided',
//               }),
//               pw.SizedBox(height: 12),

//               // Final Comments if exists
//               if (formData.comments.isNotEmpty)
//                 _buildCommentsSection('FINAL COMMENTS', formData.comments),

//               pw.SizedBox(height: 12),


//               _buildPageFooter(6),
//             ],
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   static pw.Widget _buildCompleteSectionWithActionData(
//     String title,
//     List<String> items,
//     SafetyInspectionModel formData,
//     String comments,
//     bool isVRXN,
//   ) {
//     // Get action button data for items in this section
//     List<pw.Widget> actionDataWidgets = [];
    
//     for (var item in items) {
//       final actionData = formData.inspectionData[item];
//       if (actionData != null && actionData.isNotEmpty) {
//         actionDataWidgets.add(
//           _buildItemActionDataTable(item, actionData),
//         );
//       }
//     }

//     return pw.Container(
//       width: double.infinity,
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.black, width: 1),
//         borderRadius: pw.BorderRadius.circular(4),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           // Section header
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.all(8),
//             decoration: const pw.BoxDecoration(
//               color: PdfColors.grey300,
//               borderRadius: pw.BorderRadius.only(
//                 topLeft: pw.Radius.circular(4),
//                 topRight: pw.Radius.circular(4),
//               ),
//             ),
//             child: pw.Text(
//               title,
//               style: pw.TextStyle(
//                 fontSize: 12,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),
          
//           // Main inspection table
//           pw.Column(
//             children: [
//               isVRXN
//                   ? _buildVRXNTable(items, formData)
//                   : _buildPFNATable(items, formData),
              
//               // Action button data tables
//               if (actionDataWidgets.isNotEmpty) ...[
//                 pw.SizedBox(height: 8),
//                 pw.Container(
//                   width: double.infinity,
//                   padding: const pw.EdgeInsets.all(6),
//                   decoration: pw.BoxDecoration(
//                     color: PdfColors.grey100,
//                     border: pw.Border.all(color: PdfColors.grey400),
//                   ),
//                   child: pw.Text(
//                     'Action Button Inspection Details:',
//                     style: pw.TextStyle(
//                       fontSize: 10,
//                       fontWeight: pw.FontWeight.bold,
//                       color: PdfColors.black,
//                     ),
//                   ),
//                 ),
//                 ...actionDataWidgets,
//               ],
//             ],
//           ),
          
//           // Comments section
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.all(10),
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
//             ),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   'Comments:',
//                   style: pw.TextStyle(
//                     fontSize: 10,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 8),
//                 pw.Text(
//                   comments.isNotEmpty ? comments : 'No comments',
//                   style: pw.TextStyle(fontSize: 9),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static pw.Widget _buildItemActionDataTable(String itemName, Map<String, String> actionData) {
//     final fields = actionData.keys.toList();
    
//     return pw.Container(
//       margin: const pw.EdgeInsets.only(bottom: 8, left: 10, right: 10),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             '${itemName}:',
//             style: pw.TextStyle(
//               fontSize: 9,
//               fontWeight: pw.FontWeight.bold,
//               color: PdfColors.black,
//             ),
//           ),
//           pw.SizedBox(height: 3),
//           pw.Table(
//             border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
//             columnWidths: {
//               0: const pw.FlexColumnWidth(1.5),
//               1: const pw.FlexColumnWidth(2),
//             },
//             children: [
//               for (var field in fields)
//                 pw.TableRow(
//                   children: [
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(3),
//                       child: pw.Text(
//                         field,
//                         style: pw.TextStyle(
//                           fontSize: 8,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(3),
//                       child: pw.Text(
//                         actionData[field] ?? '',
//                         style: pw.TextStyle(fontSize: 8),
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//           pw.SizedBox(height: 6),
//         ],
//       ),
//     );
//   }

//   static pw.Table _buildVRXNTable(List<String> items, SafetyInspectionModel formData) {
//     return pw.Table(
//       border: pw.TableBorder.all(width: 0.5),
//       columnWidths: {
//         0: const pw.FlexColumnWidth(2.5),
//         1: const pw.FlexColumnWidth(0.7),
//         2: const pw.FlexColumnWidth(0.7),
//         3: const pw.FlexColumnWidth(0.7),
//         4: const pw.FlexColumnWidth(0.7),
//       },
//       children: [
//         // Header row
//         pw.TableRow(
//           decoration: pw.BoxDecoration(color: PdfColors.grey200),
//           children: [
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Text(
//                 'Item',
//                 style: pw.TextStyle(
//                   fontSize: 9,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Center(
//                 child: pw.Text(
//                   'V',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Center(
//                 child: pw.Text(
//                   'R',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Center(
//                 child: pw.Text(
//                   'X',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Center(
//                 child: pw.Text(
//                   'N/A',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
        
//         // Item rows
//         for (var item in items)
//           pw.TableRow(
//             children: [
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Text(
//                   item.replaceAll('*', ''),
//                   style: pw.TextStyle(
//                     fontSize: 8,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(
//                     formData.mainDropdownValues[item] == 'V',
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(
//                     formData.mainDropdownValues[item] == 'R',
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(
//                     formData.mainDropdownValues[item] == 'X',
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(
//                     formData.mainDropdownValues[item] == 'N/A',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   static pw.Table _buildPFNATable(List<String> items, SafetyInspectionModel formData) {
//     return pw.Table(
//       border: pw.TableBorder.all(width: 0.5),
//       columnWidths: {
//         0: const pw.FlexColumnWidth(2.5),
//         1: const pw.FlexColumnWidth(0.7),
//         2: const pw.FlexColumnWidth(0.7),
//         3: const pw.FlexColumnWidth(0.7),
//         4: const pw.FlexColumnWidth(0.7),
//       },
//       children: [
//         // Header row
//         pw.TableRow(
//           decoration: pw.BoxDecoration(color: PdfColors.grey200),
//           children: [
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Text(
//                 'Item',
//                 style: pw.TextStyle(
//                   fontSize: 9,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Center(
//                 child: pw.Text(
//                   'P',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Center(
//                 child: pw.Text(
//                   'F',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Center(
//                 child: pw.Text(
//                   'N/A',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(5),
//               child: pw.Center(
//                 child: pw.Text(
//                   'R',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
        
//         // Item rows
//         for (var item in items)
//           pw.TableRow(
//             children: [
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Text(
//                   item.replaceAll('*', ''),
//                   style: pw.TextStyle(
//                     fontSize: 8,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(
//                     formData.mainDropdownValues[item] == 'P',
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(
//                     formData.mainDropdownValues[item] == 'F',
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(
//                     formData.mainDropdownValues[item] == 'N/A',
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(5),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(
//                     formData.mainDropdownValues[item] == 'R',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   static pw.Widget _buildCustomerInfoSection(SafetyInspectionModel formData) {
//     return pw.Container(
//       width: double.infinity,
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.black, width: 1),
//         borderRadius: pw.BorderRadius.circular(4),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           // Section header
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.all(8),
//             decoration: const pw.BoxDecoration(
//               color: PdfColors.grey300,
//               borderRadius: pw.BorderRadius.only(
//                 topLeft: pw.Radius.circular(4),
//                 topRight: pw.Radius.circular(4),
//               ),
//             ),
//             child: pw.Text(
//               'CUSTOMER INFORMATION',
//               style: pw.TextStyle(
//                 fontSize: 14,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),
          
//           // Data table
//           pw.Table(
//             border: pw.TableBorder.all(width: 0.5),
//             columnWidths: {
//               0: const pw.FlexColumnWidth(2),
//               1: const pw.FlexColumnWidth(3),
//             },
//             children: [
//               _buildSimpleFieldRow('Vehicle Registration', formData.vehicleRegistration),
//               _buildSimpleFieldRow('Odometer Reading', formData.mileage),
//               _buildSimpleFieldRow('Make & Type', formData.makeModel),
//               _buildSimpleFieldRow('Date Of Inspection', formData.jobReference),
//               _buildSimpleFieldRow('Operator', formData.operator),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   static pw.Widget _buildSimpleSection(String title, Map<String, String> data) {
//     return pw.Container(
//       width: double.infinity,
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.black, width: 1),
//         borderRadius: pw.BorderRadius.circular(4),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           // Section header
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.all(10),
//             decoration: const pw.BoxDecoration(
//               color: PdfColors.grey300,
//               borderRadius: pw.BorderRadius.only(
//                 topLeft: pw.Radius.circular(4),
//                 topRight: pw.Radius.circular(4),
//               ),
//             ),
//             child: pw.Text(
//               title,
//               style: pw.TextStyle(
//                 fontSize: 12,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),
          
//           // Data table
//           pw.Table(
//             border: pw.TableBorder.all(width: 0.5),
//             columnWidths: {
//               0: const pw.FlexColumnWidth(2),
//               1: const pw.FlexColumnWidth(3),
//             },
//             children: [
//               for (var entry in data.entries)
//                 _buildSimpleFieldRow(entry.key, entry.value),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   static pw.Widget _buildCommentsSection(String title, String comments) {
//     return pw.Container(
//       width: double.infinity,
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.black, width: 1),
//         borderRadius: pw.BorderRadius.circular(4),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           // Header
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.all(10),
//             decoration: const pw.BoxDecoration(
//               color: PdfColors.grey300,
//               borderRadius: pw.BorderRadius.only(
//                 topLeft: pw.Radius.circular(4),
//                 topRight: pw.Radius.circular(4),
//               ),
//             ),
//             child: pw.Text(
//               title,
//               style: pw.TextStyle(
//                 fontSize: 12,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),
          
//           // Content
//           pw.Padding(
//             padding: const pw.EdgeInsets.all(10),
//             child: pw.Text(
//               comments,
//               style: pw.TextStyle(fontSize: 9),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static pw.TableRow _buildSimpleFieldRow(String fieldName, String value) {
//     return pw.TableRow(
//       children: [
//         pw.Padding(
//           padding: const pw.EdgeInsets.all(6),
//           child: pw.Text(
//             fieldName,
//             style: pw.TextStyle(
//               fontSize: 9,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ),
//         pw.Padding(
//           padding: const pw.EdgeInsets.all(6),
//           child: pw.Text(
//             value.isNotEmpty ? value : 'Not provided',
//             style: pw.TextStyle(fontSize: 9),
//           ),
//         ),
//       ],
//     );
//   }

//   static pw.Widget _buildCheckboxCell(bool isChecked) {
//     return pw.Container(
//       width: 10,
//       height: 10,
//       alignment: pw.Alignment.center,
//       child: pw.Container(
//         width: 8,
//         height: 8,
//         decoration: pw.BoxDecoration(
//           border: pw.Border.all(color: PdfColors.black, width: 0.8),
//           color: isChecked ? PdfColors.black : PdfColors.white,
//         ),
//       ),
//     );
//   }

//   static pw.Widget _buildHeader(
//     SafetyInspectionModel formData,
//     pw.ImageProvider? logoImage,
//   ) {
//     return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         // Logo
//         if (logoImage != null)
//           pw.Container(
//             width: 100,
//             height: 50,
//             child: pw.Image(logoImage),
//           )
//         else
//           pw.Container(
//             width: 100,
//             height: 50,
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.black, width: 1),
//             ),
//             child: pw.Center(
//               child: pw.Text('LOGO', style: pw.TextStyle(fontSize: 10)),
//             ),
//           ),

//         // Title and Info
//         pw.Expanded(
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Text(
//                 'SAFETY INSPECTION FORM',
//                 style: pw.TextStyle(
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 3),
//               pw.Text(
//                 'Professional Vehicle Safety Inspection Record',
//                 style: pw.TextStyle(fontSize: 10),
//               ),
//               pw.SizedBox(height: 6),
//               pw.Text(
//                 'Date: ${DateFormat('dd/MM/yyyy').format(formData.inspectionDate ?? DateTime.now())}',
//                 style: pw.TextStyle(fontSize: 9),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   static pw.Widget _buildPageFooter(int pageNumber) {
//     return pw.Container(
//       width: double.infinity,
//       padding: const pw.EdgeInsets.only(top: 10),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(
//             'Page $pageNumber',
//             style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
//           ),
//           pw.Text(
//             'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
//             style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
//           ),
//         ],
//       ),
//     );
//   }

//   static Future<pw.MemoryImage?> _loadDefaultLogoImage() async {
//     try {
//       final byteData = await rootBundle.load('assets/images/logo.png');
//       final Uint8List imageBytes = byteData.buffer.asUint8List();
//       return pw.MemoryImage(imageBytes);
//     } catch (e) {
//       return null;
//     }
//   }
// }

import 'dart:typed_data';
import 'package:data/models/safety_inspection_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class SafetyInspectionPdfService {
  static Future<Uint8List> generatePdf(
    SafetyInspectionModel formData, {
    Uint8List? logoImageBytes,
  }) async {
    final pdf = pw.Document();

    // Check if user uploaded a main image (from Step 0) - use that as logo
    final mainLogoImage = formData.mainImageBytes != null
        ? pw.MemoryImage(formData.mainImageBytes!)
        : (logoImageBytes != null
            ? pw.MemoryImage(logoImageBytes)
            : await _loadDefaultLogoImage());

    // Add first page with Header and Main Information
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(12),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, mainLogoImage, 1),
              pw.SizedBox(height: 16),

              // Customer Information section
              _buildCustomerInfoSection(formData),
              pw.SizedBox(height: 12),

              pw.SizedBox(height: 12),
              _buildPageFooter(1),
            ],
          );
        },
      ),
    );

    // Add second page with Insider Cab section
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(8),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // _buildHeader(formData, mainLogoImage, 2),
              // pw.SizedBox(height: 5),

              // Insider Cab section
              _buildCompleteSectionWithActionData(
                'INSIDER CAB',
                [
                  'Drivers seat*',
                  'Seat belts*',
                  'Mirrors*',
                  'Glass & Road View*',
                  'Accessibility Features*',
                  'Horn*',
                ],
                formData,
                formData.insiderCabComments,
                false, // P, F, N/A, R
              ),
              pw.SizedBox(height: 8),
              _buildPageFooter(2),
            ],
          );
        },
      ),
    );

    // Add third page with Vehicle Ground Level section
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(8),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // _buildHeader(formData, mainLogoImage, 3),
              // pw.SizedBox(height: 8),

              // Vehicle Ground Level section
              _buildCompleteSectionWithActionData(
                'VEHICLE GROUND LEVEL',
                [
                  'Security of body*',
                  'Exhaust emission*',
                  'Road wheels & hubs*',
                  'Size & types of tyres*',
                  'Condition of tyres*',
                  'Bumper bars*',
                ],
                formData,
                formData.vehicleGroundLevelComments,
                false, // P, F, N/A, R
              ),
              pw.SizedBox(height: 8),
              _buildPageFooter(3),
            ],
          );
        },
      ),
    );

    // Add fourth page with Brake Performance section
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(8),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // _buildHeader(formData, mainLogoImage, 4),
              // pw.SizedBox(height: 10),

              // Brake Performance section
              _buildCompleteSectionWithActionData(
                'BRAKE PERFORMANCE',
                [
                  'Service Brake Performance*',
                  'Brake Performance*',
                  'Parking Brake Performance*',
                ],
                formData,
                formData.brakePerformanceComments,
                false, // P, F, N/A, R
              ),
              pw.SizedBox(height: 8),
              _buildPageFooter(4),
            ],
          );
        },
      ),
    );
    
    // Add fifth page with General Servicing section
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(8),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // _buildHeader(formData, mainLogoImage, 5),
              // pw.SizedBox(height: 10),

              // General Servicing section
              _buildCompleteSectionWithActionData(
                'GENERAL SERVICING',
                [
                  'Vehicle excise duty*',
                  'PSV*',
                  'Technograph calibration*',
                ],
                formData,
                formData.generalServicingComments,
                false, // P, F, N/A, R
              ),
              pw.SizedBox(height: 8),
              _buildPageFooter(5),
            ],
          );
        },
      ),
    );

    // Add sixth page for other sections
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(12),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // _buildHeader(formData, mainLogoImage, 6),
              // pw.SizedBox(height: 10),

              // Inspection Report section
              _buildSimpleSection('INSPECTION REPORT', {
                'Seen on': formData.seenOn.isNotEmpty
                    ? formData.seenOn
                    : 'Not provided',
                'Signed by': formData.signedBy.isNotEmpty
                    ? formData.signedBy
                    : 'Not provided',
                'TM Operator': formData.tmOperator.isNotEmpty
                    ? formData.tmOperator
                    : 'Not provided',
              }),
              pw.SizedBox(height: 12),

              // Comments on faults found section
              _buildSimpleSection('COMMENTS ON FAULTS FOUND', {
                'Check Number': formData.checkNumber.isNotEmpty
                    ? formData.checkNumber
                    : 'Not provided',
                'Fault Details': formData.faultDetails.isNotEmpty
                    ? formData.faultDetails
                    : 'Not provided',
                'Signature Of Inspector': formData.signatureOfInspector.isNotEmpty
                    ? formData.signatureOfInspector
                    : 'Not provided',
                'Name Of Inspector': formData.nameOfInspector.isNotEmpty
                    ? formData.nameOfInspector
                    : 'Not provided',
              }),
              pw.SizedBox(height: 12),

              // Action taken on faults found section
              _buildSimpleSection('ACTION TAKEN ON FAULTS FOUND', {
                'Action taken on fault': formData.actionTakenOnFault.isNotEmpty
                    ? formData.actionTakenOnFault
                    : 'Not provided',
                'Rectified by': formData.rectifiedBy.isNotEmpty
                    ? formData.rectifiedBy
                    : 'Not provided',
              }),
              pw.SizedBox(height: 12),

              // Consider defects have section
              _buildSimpleSection('CONSIDER DEFECTS HAVE', {
                'Rectified satisfactorily':
                    formData.rectifiedSatisfactorily.isNotEmpty
                        ? formData.rectifiedSatisfactorily
                        : 'Not provided',
                'Needs more work done': formData.needsMoreWorkDone.isNotEmpty
                    ? formData.needsMoreWorkDone
                    : 'Not provided',
                'Signature Of Mechanic':
                    formData.signatureOfMechanic.isNotEmpty
                        ? formData.signatureOfMechanic
                        : 'Not provided',
                'Date': formData.date.isNotEmpty
                    ? formData.date
                    : 'Not provided',
              }),
              pw.SizedBox(height: 12),

              // Final Comments if exists
              if (formData.comments.isNotEmpty)
                _buildCommentsSection('FINAL COMMENTS', formData.comments),

              pw.SizedBox(height: 12),

              _buildPageFooter(6),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ==================== UPDATED HEADER WITH MAIN INFORMATION ====================
  static pw.Widget _buildHeader(
    SafetyInspectionModel formData,
    pw.ImageProvider? logoImage,
    int pageNumber,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Logo - Uses uploaded image from Step 0
            if (logoImage != null)
              pw.Container(
                width: 100,
                height: 70,
                child: pw.Image(logoImage, fit: pw.BoxFit.contain),
              )
            else
              pw.Container(
                width: 100,
                height: 70,
                child: pw.Text('LOGO', style: pw.TextStyle(fontSize: 9)),
              ),

            pw.SizedBox(width: 30),
            
            // Title and Info
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SAFETY INSPECTION FORM',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'Professional Vehicle Safety Inspection Record',
                    style: pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Comprehensive vehicle safety inspection report',
                    style: pw.TextStyle(fontSize: 7),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(formData.inspectionDate ?? DateTime.now())}',
                    style: pw.TextStyle(fontSize: 7),
                    textAlign: pw.TextAlign.start,
                  ),
                ],
              ),
            ),

            pw.SizedBox(width: 15),

            // Main Information displayed in header (Workshop Name & Address, Job Reference/Date)
            pw.Container(
              width: 120,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Workshop Name & Address',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    formData.workshopName.isNotEmpty
                        ? formData.workshopName
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 7),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Job Reference/Date',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    formData.jobReference.isNotEmpty
                        ? formData.jobReference
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 1),
      ],
    );
  }

  // ==================== REST OF THE CODE REMAINS THE SAME ====================

  static pw.Widget _buildCompleteSectionWithActionData(
    String title,
    List<String> items,
    SafetyInspectionModel formData,
    String comments,
    bool isVRXN,
  ) {
    // Get action button data for items in this section
    List<pw.Widget> actionDataWidgets = [];
    
    for (var item in items) {
      final actionData = formData.inspectionData[item];
      if (actionData != null && actionData.isNotEmpty) {
        actionDataWidgets.add(
          _buildItemActionDataTable(item, actionData),
        );
      }
    }

    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Section header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: pw.BorderRadius.only(
                topLeft: pw.Radius.circular(4),
                topRight: pw.Radius.circular(4),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Main inspection table
          pw.Column(
            children: [
              isVRXN
                  ? _buildVRXNTable(items, formData)
                  : _buildPFNATable(items, formData),
              
              // Action button data tables
              if (actionDataWidgets.isNotEmpty) ...[
                pw.SizedBox(height: 8),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(6),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey400),
                  ),
                  child: pw.Text(
                    'Action Button Inspection Details:',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
                ...actionDataWidgets,
              ],
            ],
          ),
          
          // Comments section
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Comments:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  comments.isNotEmpty ? comments : 'No comments',
                  style: pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemActionDataTable(String itemName, Map<String, String> actionData) {
    final fields = actionData.keys.toList();
    
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8, left: 10, right: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${itemName}:',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              for (var field in fields)
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Text(
                        field,
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Text(
                        actionData[field] ?? '',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          pw.SizedBox(height: 6),
        ],
      ),
    );
  }

  static pw.Table _buildVRXNTable(List<String> items, SafetyInspectionModel formData) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(0.7),
        2: const pw.FlexColumnWidth(0.7),
        3: const pw.FlexColumnWidth(0.7),
        4: const pw.FlexColumnWidth(0.7),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Item',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child: pw.Text(
                  'V',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child: pw.Text(
                  'R',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child: pw.Text(
                  'X',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child: pw.Text(
                  'N/A',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // Item rows
        for (var item in items)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  item.replaceAll('*', ''),
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: _buildCheckboxCell(
                    formData.mainDropdownValues[item] == 'V',
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: _buildCheckboxCell(
                    formData.mainDropdownValues[item] == 'R',
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: _buildCheckboxCell(
                    formData.mainDropdownValues[item] == 'X',
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: _buildCheckboxCell(
                    formData.mainDropdownValues[item] == 'N/A',
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  static pw.Table _buildPFNATable(List<String> items, SafetyInspectionModel formData) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(0.7),
        2: const pw.FlexColumnWidth(0.7),
        3: const pw.FlexColumnWidth(0.7),
        4: const pw.FlexColumnWidth(0.7),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Item',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child: pw.Text(
                  'P',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child: pw.Text(
                  'F',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child: pw.Text(
                  'N/A',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Center(
                child: pw.Text(
                  'R',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // Item rows
        for (var item in items)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  item.replaceAll('*', ''),
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: _buildCheckboxCell(
                    formData.mainDropdownValues[item] == 'P',
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: _buildCheckboxCell(
                    formData.mainDropdownValues[item] == 'F',
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: _buildCheckboxCell(
                    formData.mainDropdownValues[item] == 'N/A',
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: _buildCheckboxCell(
                    formData.mainDropdownValues[item] == 'R',
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  static pw.Widget _buildCustomerInfoSection(SafetyInspectionModel formData) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Section header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: pw.BorderRadius.only(
                topLeft: pw.Radius.circular(4),
                topRight: pw.Radius.circular(4),
              ),
            ),
            child: pw.Text(
              'CUSTOMER INFORMATION',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Data table
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(3),
            },
            children: [
              _buildSimpleFieldRow('Vehicle Registration', formData.vehicleRegistration),
              _buildSimpleFieldRow('Odometer Reading', formData.mileage),
              _buildSimpleFieldRow('Make & Type', formData.makeModel),
              _buildSimpleFieldRow('Date Of Inspection', formData.dateOfInspection),
              _buildSimpleFieldRow('Operator', formData.operator),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSimpleSection(String title, Map<String, String> data) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Section header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: pw.BorderRadius.only(
                topLeft: pw.Radius.circular(4),
                topRight: pw.Radius.circular(4),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Data table
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(3),
            },
            children: [
              for (var entry in data.entries)
                _buildSimpleFieldRow(entry.key, entry.value),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCommentsSection(String title, String comments) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: pw.BorderRadius.only(
                topLeft: pw.Radius.circular(4),
                topRight: pw.Radius.circular(4),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Content
          pw.Padding(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Text(
              comments,
              style: pw.TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }

  static pw.TableRow _buildSimpleFieldRow(String fieldName, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            fieldName,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            value.isNotEmpty ? value : 'Not provided',
            style: pw.TextStyle(fontSize: 9),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildCheckboxCell(bool isChecked) {
    return pw.Container(
      width: 10,
      height: 10,
      alignment: pw.Alignment.center,
      child: pw.Container(
        width: 8,
        height: 8,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black, width: 0.8),
          color: isChecked ? PdfColors.black : PdfColors.white,
        ),
      ),
    );
  }

  static pw.Widget _buildPageFooter(int pageNumber) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Page $pageNumber',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.Text(
            'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static Future<pw.MemoryImage?> _loadDefaultLogoImage() async {
    try {
      final byteData = await rootBundle.load('assets/images/logo.png');
      final Uint8List imageBytes = byteData.buffer.asUint8List();
      return pw.MemoryImage(imageBytes);
    } catch (e) {
      return null;
    }
  }
}