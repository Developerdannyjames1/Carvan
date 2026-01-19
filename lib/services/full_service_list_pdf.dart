// import 'dart:typed_data';
// import 'package:data/models/full_service_list_model.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class FullServiceListPdfExport {
//   static Future<Uint8List> generatePdf(
//     FullServiceListModel formData, {
//     Uint8List? logoImageBytes,
//     List<Uint8List>? uploadedImages,
//   }) async {
//     final pdf = pw.Document();

//     // Load logo image
//     final logoImage =
//         logoImageBytes != null
//             ? pw.MemoryImage(logoImageBytes)
//             : await _loadDefaultLogoImage();

//     // Add first page with ALL sections
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               _buildHeader(formData, logoImage),
//               pw.SizedBox(height: 10),
              
//               // Main Information Section with images
//               _buildMainInformationSection(formData, uploadedImages: uploadedImages),
//               pw.SizedBox(height: 15),
              
//               // Customer Information Section
//               _buildCustomerInformationSection(formData),
//               pw.SizedBox(height: 15),
              
//               // Service Checklist - Vehicle On Floor
//               _buildVehicleOnFloorSection(formData),
//             ],
//           );
//         },
//       ),
//     );

//     // Add second page
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               _buildHeader(formData, logoImage),
//               pw.SizedBox(height: 10),
              
//               // Safety Checks - Vehicle Raised
//               _buildVehicleRaisedSection(formData),
//               pw.SizedBox(height: 15),
              
//               // Habitation Area Check - Vehicle Fully Raised
//               _buildVehicleFullyRaisedSection(formData),
//             ],
//           );
//         },
//       ),
//     );

//     // Add third page
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               _buildHeader(formData, logoImage),
//               pw.SizedBox(height: 10),
              
//               // Electrical System - Vehicle Half Raised
//               _buildVehicleHalfRaisedSection(formData),
//               pw.SizedBox(height: 15),
              
//               // Water & Gas Systems - Under Bonet Operations
//               _buildUnderBonetOperationsSection(formData),
//             ],
//           );
//         },
//       ),
//     );

//     // Add fourth page
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               _buildHeader(formData, logoImage),
//               pw.SizedBox(height: 10),
              
//               // Final Items Checks
//               _buildFinalItemsChecksSection(formData),
//               pw.SizedBox(height: 15),
              
//               // Finalization
//               _buildFinalizationSection(formData),
//             ],
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   static Future<pw.MemoryImage?> _loadDefaultLogoImage() async {
//     try {
//       final byteData = await rootBundle.load('assets/images/logo.png');
//       final Uint8List imageBytes = byteData.buffer.asUint8List();
//       return pw.MemoryImage(imageBytes);
//     } catch (e) {
//       print('Error loading default logo image: $e');
//       return null;
//     }
//   }

//   static pw.Widget _buildHeader(
//     FullServiceListModel formData,
//     pw.ImageProvider? logoImage,
//   ) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         // Logo, Title, and Workshop Info Row
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Logo
//             if (logoImage != null)
//               pw.Container(width: 100, height: 50, child: pw.Image(logoImage))
//             else
//               pw.Container(
//                 width: 100,
//                 height: 50,
//                 child: pw.Text('LOGO', style: pw.TextStyle(fontSize: 9)),
//               ),

//             pw.SizedBox(width: 15),
            
//             // Title
//             pw.Expanded(
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     'Full Service Checklist',
//                     style: pw.TextStyle(
//                       fontSize: 16,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                     textAlign: pw.TextAlign.start,
//                   ),
//                   pw.SizedBox(height: 6),
//                   pw.Text(
//                     'Complete Vehicle Service and Inspection Report',
//                     style: pw.TextStyle(
//                       fontSize: 12,
//                       fontWeight: pw.FontWeight.normal,
//                     ),
//                     textAlign: pw.TextAlign.start,
//                   ),
//                 ],
//               ),
//             ),

//             pw.SizedBox(width: 15),

//             // Workshop Info - Right side
//             pw.Container(
//               width: 120,
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     'Approved Workshop Name & Address',
//                     style: pw.TextStyle(
//                       fontSize: 8,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                   pw.SizedBox(height: 2),
//                   pw.Text(
//                     formData.workshopName.isNotEmpty
//                         ? formData.workshopName
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 7),
//                   ),
//                   pw.SizedBox(height: 8),
//                   pw.Text(
//                     'Job Reference/Date',
//                     style: pw.TextStyle(
//                       fontSize: 8,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                   pw.SizedBox(height: 2),
//                   pw.Text(
//                     formData.jobReference.isNotEmpty
//                         ? formData.jobReference
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 7),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 10),

//         // Customer info table
//         pw.Table(
//           border: pw.TableBorder.all(width: 0.5),
//           columnWidths: {
//             0: const pw.FlexColumnWidth(1),
//             1: const pw.FlexColumnWidth(1),
//             2: const pw.FlexColumnWidth(1),
//             3: const pw.FlexColumnWidth(1),
//           },
//           children: [
//             pw.TableRow(
//               decoration: pw.BoxDecoration(color: PdfColors.grey300),
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Customer Name',
//                     style: pw.TextStyle(
//                       fontSize: 9,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Make & Model',
//                     style: pw.TextStyle(
//                       fontSize: 9,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Registration Number',
//                     style: pw.TextStyle(
//                       fontSize: 9,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'CRIS/Vin Number',
//                     style: pw.TextStyle(
//                       fontSize: 9,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.customerName.isNotEmpty
//                         ? formData.customerName
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.makeModel.isNotEmpty
//                         ? formData.makeModel
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.registrationNumber.isNotEmpty
//                         ? formData.registrationNumber
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.crisVinNumber.isNotEmpty
//                         ? formData.crisVinNumber
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 10),
//         pw.Divider(thickness: 1),
//       ],
//     );
//   }

//   static pw.Widget _buildMainInformationSection(
//     FullServiceListModel formData, {
//     List<Uint8List>? uploadedImages,
//   }) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           // '1. Main Information',
//           'Main Information',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
        
//         // Workshop Name & Address
//         pw.Table(
//           border: pw.TableBorder.all(width: 0.5),
//           columnWidths: {
//             0: const pw.FlexColumnWidth(1),
//             1: const pw.FlexColumnWidth(3),
//           },
//           children: [
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Workshop Name & Address:',
//                     style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.workshopName.isNotEmpty
//                         ? formData.workshopName
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Job Reference/Date:',
//                     style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.jobReference.isNotEmpty
//                         ? formData.jobReference
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 8),
//       ],
//     );
//   }

//   static pw.Widget _buildCustomerInformationSection(FullServiceListModel formData) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Customer Information',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
//         pw.Table(
//           border: pw.TableBorder.all(width: 0.5),
//           columnWidths: {
//             0: const pw.FlexColumnWidth(1.5),
//             1: const pw.FlexColumnWidth(2.5),
//           },
//           children: [
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Customer Name:',
//                     style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.customerName.isNotEmpty
//                         ? formData.customerName
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Make & Model:',
//                     style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.makeModel.isNotEmpty
//                         ? formData.makeModel
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Registration Number:',
//                     style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.registrationNumber.isNotEmpty
//                         ? formData.registrationNumber
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'CRIS/Vin Number:',
//                     style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.crisVinNumber.isNotEmpty
//                         ? formData.crisVinNumber
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   static pw.Widget _buildVehicleOnFloorSection(FullServiceListModel formData) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Vehicle On Floor',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
//         _buildCheckboxSectionTable(
//           formData.serviceChecklist,
//           formData.serviceStatus,
//         ),
//         if (formData.serviceNotes.isNotEmpty)
//           _buildNotesSection(formData.serviceNotes),
//       ],
//     );
//   }

//   static pw.Widget _buildVehicleRaisedSection(FullServiceListModel formData) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Vehicle Raised',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
//         _buildCheckboxSectionTable(
//           formData.safetyChecks,
//           formData.safetyStatus,
//         ),
//         if (formData.safetyNotes.isNotEmpty)
//           _buildNotesSection(formData.safetyNotes),
//       ],
//     );
//   }

//   static pw.Widget _buildVehicleFullyRaisedSection(FullServiceListModel formData) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Vehicle Fully Raised',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
//         _buildCheckboxSectionTable(
//           formData.habitationChecks,
//           formData.habitationStatus,
//         ),
//         if (formData.habitationNotes.isNotEmpty)
//           _buildNotesSection(formData.habitationNotes),
//       ],
//     );
//   }

//   static pw.Widget _buildVehicleHalfRaisedSection(FullServiceListModel formData) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Vehicle Half Raised',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
//         _buildCheckboxSectionTable(
//           formData.electricalChecks,
//           formData.electricalStatus,
//         ),
//         if (formData.electricalNotes.isNotEmpty)
//           _buildNotesSection(formData.electricalNotes),
//       ],
//     );
//   }

//   static pw.Widget _buildUnderBonetOperationsSection(FullServiceListModel formData) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Under Bonet Operations',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
//         _buildCheckboxSectionTable(
//           formData.waterGasChecks,
//           formData.waterGasStatus,
//         ),
//         if (formData.waterGasNotes.isNotEmpty)
//           _buildNotesSection(formData.waterGasNotes),
//       ],
//     );
//   }

//   static pw.Widget _buildFinalItemsChecksSection(FullServiceListModel formData) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Final Items Checks',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
//         _buildCheckboxSectionTable(
//           formData.finalItemsChecks,
//           formData.finalItemsStatus,
//         ),
//         if (formData.finalItemsNotes.isNotEmpty)
//           _buildNotesSection(formData.finalItemsNotes),
//       ],
//     );
//   }

//   static pw.Widget _buildCheckboxSectionTable(
//     Map<String, bool> checks,
//     Map<String, String?> status,
//   ) {
//     return pw.Table(
//       border: pw.TableBorder.all(width: 0.5),
//       columnWidths: {
//         0: const pw.FlexColumnWidth(2.5),
//         1: const pw.FlexColumnWidth(0.8),
//         2: const pw.FlexColumnWidth(1.2),
//       },
//       children: [
//         // Header row
//         pw.TableRow(
//           decoration: pw.BoxDecoration(color: PdfColors.grey300),
//           children: [
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(4.0),
//               child: pw.Text(
//                 'Check Item',
//                 style: pw.TextStyle(
//                   fontSize: 9,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(4.0),
//               child: pw.Center(
//                 child: pw.Text(
//                   'Checked',
//                   style: pw.TextStyle(
//                     fontSize: 9,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(4.0),
//               child: pw.Center(
//                 child: pw.Text(
//                   'Status',
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
//         for (var entry in checks.entries)
//           pw.TableRow(
//             children: [
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(4.0),
//                 child: pw.Text(
//                   entry.key,
//                   style: pw.TextStyle(fontSize: 9),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(4.0),
//                 child: pw.Center(
//                   child: _buildCheckboxCell(entry.value),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(4.0),
//                 child: pw.Center(
//                   child: pw.Text(
//                     status[entry.key] ?? 'N/A',
//                     style: pw.TextStyle(
//                       fontSize: 9,
//                       color: _getStatusColor(status[entry.key]),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   static pw.Widget _buildNotesSection(String notes) {
//     return pw.Container(
//       width: double.infinity,
//       margin: const pw.EdgeInsets.only(top: 8),
//       padding: const pw.EdgeInsets.all(8.0),
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
//         borderRadius: pw.BorderRadius.circular(4),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'Notes:',
//             style: pw.TextStyle(
//               fontSize: 10,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           pw.SizedBox(height: 4),
//           pw.Text(
//             notes,
//             style: pw.TextStyle(fontSize: 9),
//           ),
//         ],
//       ),
//     );
//   }

//   static PdfColor _getStatusColor(String? status) {
//     switch (status) {
//       case "O.K":
//         return PdfColors.green;
//       case "Advisory":
//         return PdfColors.orange;
//       case "Need Attention":
//         return PdfColors.red;
//       default:
//         return PdfColors.black;
//     }
//   }

//   static pw.Widget _buildCheckboxCell(bool isChecked) {
//     return pw.Container(
//       width: 12,
//       height: 12,
//       alignment: pw.Alignment.center,
//       child: pw.Container(
//         width: 10,
//         height: 10,
//         decoration: pw.BoxDecoration(
//           border: pw.Border.all(color: PdfColors.black, width: 0.5),
//           color: isChecked ? PdfColors.black : PdfColors.white,
//         ),
//       ),
//     );
//   }

//   static pw.Widget _buildFinalizationSection(FullServiceListModel formData) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           'Finalization',
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.SizedBox(height: 8),
        
//         // Technician Name
//         pw.Table(
//           border: pw.TableBorder.all(width: 0.5),
//           columnWidths: {
//             0: const pw.FlexColumnWidth(1),
//             1: const pw.FlexColumnWidth(3),
//           },
//           children: [
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Technician Name:',
//                     style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.technicianName.isNotEmpty
//                         ? formData.technicianName
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 8),
        
//         // Signature
//         pw.Table(
//           border: pw.TableBorder.all(width: 0.5),
//           columnWidths: {
//             0: const pw.FlexColumnWidth(1),
//             1: const pw.FlexColumnWidth(3),
//           },
//           children: [
//             pw.TableRow(
//               children: [
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     'Signature:',
//                     style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.all(4.0),
//                   child: pw.Text(
//                     formData.technicianSignature.isNotEmpty
//                         ? formData.technicianSignature
//                         : 'Not provided',
//                     style: pw.TextStyle(fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 15),
        
//         // Notes
//         if (formData.finalizationNotes.isNotEmpty)
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.all(8.0),
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.black, width: 0.5),
//             ),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   'Additional Notes:',
//                   style: pw.TextStyle(
//                     fontSize: 10,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 4),
//                 pw.Text(
//                   formData.finalizationNotes,
//                   style: pw.TextStyle(fontSize: 9),
//                 ),
//               ],
//             ),
//           ),
        
//         // Footer with date
//         // pw.Container(
//         //   width: double.infinity,
//         //   margin: const pw.EdgeInsets.only(top: 20),
//         //   padding: const pw.EdgeInsets.all(8.0),
//         //   decoration: pw.BoxDecoration(
//         //     border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
//         //   ),
//         //   child: pw.Column(
//         //     children: [
//         //       pw.Text(
//         //         'Document Generated On: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
//         //         style: pw.TextStyle(
//         //           fontSize: 9,
//         //           fontWeight: pw.FontWeight.bold,
//         //         ),
//         //       ),
//         //       pw.SizedBox(height: 4),
//         //       pw.Text(
//         //         'Full Service Checklist v1.0',
//         //         style: pw.TextStyle(
//         //           fontSize: 8,
//         //           color: PdfColors.grey600,
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
// FullServiceListPdfExport class - update _buildFinalizationSection method
import 'dart:typed_data';
import 'package:data/models/full_service_list_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class FullServiceListPdfExport {
  static Future<Uint8List> generatePdf(
    FullServiceListModel formData, {
    Uint8List? logoImageBytes,
    List<Uint8List>? uploadedImages,
  }) async {
    final pdf = pw.Document();

    // Load logo image
    final logoImage =
        logoImageBytes != null
            ? pw.MemoryImage(logoImageBytes)
            : await _loadDefaultLogoImage();

    // Add first page with ALL sections
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),
              
              // Main Information Section with images
              _buildMainInformationSection(formData, uploadedImages: uploadedImages),
              pw.SizedBox(height: 15),
              
              // Customer Information Section
              _buildCustomerInformationSection(formData),
              pw.SizedBox(height: 15),
              
              // Service Checklist - Vehicle On Floor
              _buildVehicleOnFloorSection(formData),
            ],
          );
        },
      ),
    );

    // Add second page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),
              
              // Safety Checks - Vehicle Raised
              _buildVehicleRaisedSection(formData),
              pw.SizedBox(height: 15),
              
              // Habitation Area Check - Vehicle Fully Raised
              _buildVehicleFullyRaisedSection(formData),
            ],
          );
        },
      ),
    );

    // Add third page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),
              
              // Electrical System - Vehicle Half Raised
              _buildVehicleHalfRaisedSection(formData),
              pw.SizedBox(height: 15),
              
              // Water & Gas Systems - Under Bonet Operations
              _buildUnderBonetOperationsSection(formData),
            ],
          );
        },
      ),
    );

    // Add fourth page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),
              
              // Final Items Checks
              _buildFinalItemsChecksSection(formData),
              pw.SizedBox(height: 15),
              
              // Finalization
              _buildFinalizationSection(formData),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<pw.MemoryImage?> _loadDefaultLogoImage() async {
    try {
      final byteData = await rootBundle.load('assets/images/logo.png');
      final Uint8List imageBytes = byteData.buffer.asUint8List();
      return pw.MemoryImage(imageBytes);
    } catch (e) {
      print('Error loading default logo image: $e');
      return null;
    }
  }

  static pw.Widget _buildHeader(
    FullServiceListModel formData,
    pw.ImageProvider? logoImage,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Logo, Title, and Workshop Info Row
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Logo
            if (logoImage != null)
              pw.Container(width: 100, height: 50, child: pw.Image(logoImage))
            else
              pw.Container(
                width: 100,
                height: 50,
                child: pw.Text('LOGO', style: pw.TextStyle(fontSize: 9)),
              ),

            pw.SizedBox(width: 15),
            
            // Title
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Full Service Checklist',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'Complete Vehicle Service and Inspection Report',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.normal,
                    ),
                    textAlign: pw.TextAlign.start,
                  ),
                ],
              ),
            ),

            pw.SizedBox(width: 15),

            // Workshop Info - Right side
            pw.Container(
              width: 120,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Approved Workshop Name & Address',
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
        pw.SizedBox(height: 10),

        // Customer info table
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Customer Name',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Make & Model',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Registration Number',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'CRIS/Vin Number',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.customerName.isNotEmpty
                        ? formData.customerName
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.makeModel.isNotEmpty
                        ? formData.makeModel
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.registrationNumber.isNotEmpty
                        ? formData.registrationNumber
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.crisVinNumber.isNotEmpty
                        ? formData.crisVinNumber
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 1),
      ],
    );
  }

  static pw.Widget _buildMainInformationSection(
    FullServiceListModel formData, {
    List<Uint8List>? uploadedImages,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Main Information',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        
        // Workshop Name & Address
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(3),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Workshop Name & Address:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.workshopName.isNotEmpty
                        ? formData.workshopName
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Job Reference/Date:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.jobReference.isNotEmpty
                        ? formData.jobReference
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  static pw.Widget _buildCustomerInformationSection(FullServiceListModel formData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Customer Information',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(2.5),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Customer Name:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.customerName.isNotEmpty
                        ? formData.customerName
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Make & Model:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.makeModel.isNotEmpty
                        ? formData.makeModel
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Registration Number:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.registrationNumber.isNotEmpty
                        ? formData.registrationNumber
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'CRIS/Vin Number:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.crisVinNumber.isNotEmpty
                        ? formData.crisVinNumber
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildVehicleOnFloorSection(FullServiceListModel formData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Vehicle On Floor',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        _buildCheckboxSectionTable(
          formData.serviceChecklist,
          formData.serviceStatus,
        ),
        // Add comments section
        if (formData.vehicleOnFloorComments.isNotEmpty)
          _buildCommentsSection('Vehicle On Floor Comments', formData.vehicleOnFloorComments),
      ],
    );
  }

  static pw.Widget _buildVehicleRaisedSection(FullServiceListModel formData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Vehicle Raised',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        _buildCheckboxSectionTable(
          formData.safetyChecks,
          formData.safetyStatus,
        ),
        // Add comments section
        if (formData.vehicleRaisedComments.isNotEmpty)
          _buildCommentsSection('Vehicle Raised Comments', formData.vehicleRaisedComments),
      ],
    );
  }

  static pw.Widget _buildVehicleFullyRaisedSection(FullServiceListModel formData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Vehicle Fully Raised',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        _buildCheckboxSectionTable(
          formData.habitationChecks,
          formData.habitationStatus,
        ),
        // Add comments section
        if (formData.vehicleFullyRaisedComments.isNotEmpty)
          _buildCommentsSection('Vehicle Fully Raised Comments', formData.vehicleFullyRaisedComments),
      ],
    );
  }

  static pw.Widget _buildVehicleHalfRaisedSection(FullServiceListModel formData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Vehicle Half Raised',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        _buildCheckboxSectionTable(
          formData.electricalChecks,
          formData.electricalStatus,
        ),
        // Add comments section
        if (formData.vehicleHalfRaisedComments.isNotEmpty)
          _buildCommentsSection('Vehicle Half Raised Comments', formData.vehicleHalfRaisedComments),
      ],
    );
  }

  static pw.Widget _buildUnderBonetOperationsSection(FullServiceListModel formData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Under Bonet Operations',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        _buildCheckboxSectionTable(
          formData.waterGasChecks,
          formData.waterGasStatus,
        ),
        // Add comments section
        if (formData.underBonetOperationsComments.isNotEmpty)
          _buildCommentsSection('Under Bonet Operations Comments', formData.underBonetOperationsComments),
      ],
    );
  }

  static pw.Widget _buildFinalItemsChecksSection(FullServiceListModel formData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Final Items Checks',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        _buildCheckboxSectionTable(
          formData.finalItemsChecks,
          formData.finalItemsStatus,
        ),
        // Add comments section
        if (formData.finalItemsChecksComments.isNotEmpty)
          _buildCommentsSection('Final Items Checks Comments', formData.finalItemsChecksComments),
      ],
    );
  }

  static pw.Widget _buildCheckboxSectionTable(
    Map<String, bool> checks,
    Map<String, String?> status,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(0.8),
        2: const pw.FlexColumnWidth(1.2),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text(
                'Check Item',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'Checked',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'Status',
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
        for (var entry in checks.entries)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Text(
                  entry.key,
                  style: pw.TextStyle(fontSize: 9),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(entry.value),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: pw.Text(
                    status[entry.key] ?? 'N/A',
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: _getStatusColor(status[entry.key]),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  static pw.Widget _buildCommentsSection(String title, String comments) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(top: 8),
      padding: const pw.EdgeInsets.all(8.0),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title + ':',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            comments,
            style: pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }

  static PdfColor _getStatusColor(String? status) {
    switch (status) {
      case "O.K":
        return PdfColors.green;
      case "Advisory":
        return PdfColors.orange;
      case "Need Attention":
        return PdfColors.red;
      default:
        return PdfColors.black;
    }
  }

  static pw.Widget _buildCheckboxCell(bool isChecked) {
    return pw.Container(
      width: 12,
      height: 12,
      alignment: pw.Alignment.center,
      child: pw.Container(
        width: 10,
        height: 10,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black, width: 0.5),
          color: isChecked ? PdfColors.black : PdfColors.white,
        ),
      ),
    );
  }

  // UPDATED FINALIZATION SECTION WITH COMMENTS
  static pw.Widget _buildFinalizationSection(FullServiceListModel formData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Finalization',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        
        // Technician Name
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(3),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Technician Name:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.technicianName.isNotEmpty
                        ? formData.technicianName
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        
        // Signature
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(3),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Signature:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    formData.technicianSignature.isNotEmpty
                        ? formData.technicianSignature
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        
        // Comments section
        if (formData.finalizationComments.isNotEmpty)
          pw.Container(
            width: double.infinity,
            margin: const pw.EdgeInsets.only(top: 8),
            padding: const pw.EdgeInsets.all(8.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Finalization Comments:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  formData.finalizationComments,
                  style: pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        
        pw.SizedBox(height: 8),
        
        // Notes (existing field - keep for backward compatibility)
        if (formData.finalizationNotes.isNotEmpty)
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Additional Notes:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  formData.finalizationNotes,
                  style: pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
      ],
    );
  }
}