import 'dart:typed_data';
import 'package:data/models/tourer_damp_report_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class StaticCarvanDampReportPdfService {
  static Future<Uint8List> generatePdf(
    TourerDampModel formData, {
    Uint8List? logoImageBytes,
  }) async {
    final pdf = pw.Document();

    // Load logo image
    final logoImage = logoImageBytes != null
        ? pw.MemoryImage(logoImageBytes)
        : await _loadDefaultLogoImage();

    // =========== PAGE 1: Header, Main Info, Customer Info ===========
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(formData, logoImage, 1),
              pw.SizedBox(height: 15),

              // Main Information Table
              _buildSectionTitle('Main Information'),
              pw.SizedBox(height: 8),
              _buildMainInfoTable(formData),
              pw.SizedBox(height: 20),

              // Customer Information Table
              _buildSectionTitle('Customer Information'),
              pw.SizedBox(height: 8),
              _buildCustomerInfoTable(formData),
              pw.SizedBox(height: 20),

              // Footer
              // pw.Spacer(),
              // _buildPageFooter(1, 4),
            ],
          );
        },
      ),
    );

    // =========== PAGE 2: Damp Readings & Notes ===========
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(formData, logoImage, 2),
              pw.SizedBox(height: 15),

              // Guidance Notes (BLUE)
              _buildGuidanceNotesSection(),
              pw.SizedBox(height: 15),

              // Comments & Recommendations
              _buildCommentsSection(formData.commentsRecommendations),
              pw.SizedBox(height: 15),

              // Precaution Notes (BLACK)
              _buildPrecautionNotesSection(),

              // Footer
              // pw.Spacer(),
              // _buildPageFooter(2, 4),
            ],
          );
        },
      ),
    );

    // // =========== PAGE 3: Photo Documentation (Front, Rear, Nearside, Offside) ===========
    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Column(
    //         crossAxisAlignment: pw.CrossAxisAlignment.start,
    //         children: [
    //           // Header Section
    //           _buildHeader(formData, logoImage, 3),
    //           pw.SizedBox(height: 15),

    //           // Photo Documentation Title
    //           pw.Center(
    //             child: pw.Text(
    //               'PHOTO DOCUMENTATION',
    //               style: pw.TextStyle(
    //                 fontSize: 14,
    //                 fontWeight: pw.FontWeight.bold,
    //                 color: PdfColors.black,
    //               ),
    //             ),
    //           ),
    //           pw.SizedBox(height: 15),

    //           // First Row:  Nearside & Offside
    //           pw.Row(
    //             crossAxisAlignment: pw.CrossAxisAlignment.start,
    //             children: [
    //                 pw.Expanded(
    //                 child: _buildPhotoSectionWithTable('Nearside', formData.photoData['Nearside'] ?? {}),
    //               ),
    //               pw.SizedBox(width: 10),
    //                 pw.Expanded(
    //                 child: _buildPhotoSectionWithTable('Offside', formData.photoData['Offside'] ?? {}),
    //               ),
          
    //             ],
    //           ),
    //           pw.SizedBox(height: 15),
              
    //           // Second Row: Front & Rear
    //           pw.Row(
    //             crossAxisAlignment: pw.CrossAxisAlignment.start,
    //             children: [
    //                  pw.Expanded(
    //                 child: _buildPhotoSectionWithTable('Front', formData.photoData['Front'] ?? {}),
    //               ),
    //               pw.SizedBox(width: 10),
    //                  pw.Expanded(
    //                 child: _buildPhotoSectionWithTable('Rear', formData.photoData['Rear'] ?? {}),
    //               ),
    //             ],
    //           ),

    //           // Footer
    //           // pw.Spacer(),
    //           // _buildPageFooter(3, 4),
    //         ],
    //       );
    //     },
    //   ),
    // );

    // // =========== PAGE 4: Remaining Photos and Finalization ===========
    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Column(
    //         crossAxisAlignment: pw.CrossAxisAlignment.start,
    //         children: [
    //           // Header Section
    //           _buildHeader(formData, logoImage, 4),
    //           pw.SizedBox(height: 15),

    //           // Ceiling & Floor Photos
    //           pw.Row(
    //             crossAxisAlignment: pw.CrossAxisAlignment.start,
    //             children: [
    //               pw.Expanded(
    //                 child: _buildPhotoSectionWithTable('Ceiling', formData.photoData['Ceiling'] ?? {}),
    //               ),
    //               pw.SizedBox(width: 10),
    //               pw.Expanded(
    //                 child: _buildPhotoSectionWithTable('Floor', formData.photoData['Floor'] ?? {}),
    //               ),
    //             ],
    //           ),
    //           pw.SizedBox(height: 15),

    //           // Finalization Section
    //           _buildSectionTitle('Finalization'),
    //           pw.SizedBox(height: 8),
    //           _buildFinalizationTable(formData),

    //           // Footer
    //           // pw.Spacer(),
    //           // _buildPageFooter(4, 4),
    //         ],
    //       );
    //     },
    //   ),
    // );

     // =========== PAGE 3: Nearside & Offside Photos ===========
pdf.addPage(
  pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(formData, logoImage, 3),
          pw.SizedBox(height: 15),

          // Photo Documentation Title
          pw.Center(
            child: pw.Text(
              'PHOTO DOCUMENTATION',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.SizedBox(height: 15),

          // // First Row: Nearside & Offside
     
           pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: _buildPhotoSectionWithTable('Nearside', formData.photoData['Nearside'] ?? {}),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: _buildPhotoSectionWithTable('Offside', formData.photoData['Offside'] ?? {}),
              ),
            ],
          ),
          // Footer
          // pw.Spacer(),
          // _buildPageFooter(3, 5),  // Changed to 5 total pages
        ],
      );
    },
  ),
);

// =========== PAGE 4: Front & Rear Photos ===========
pdf.addPage(
  pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(formData, logoImage, 4),  // Changed to 4
          pw.SizedBox(height: 15),

          // Second Row:  Front & Rear
              pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: _buildPhotoSectionWithTable('Front', formData.photoData['Front'] ?? {}),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: _buildPhotoSectionWithTable('Rear', formData.photoData['Rear'] ?? {}),
              ),
            ],
          ),

          // Footer
          // pw.Spacer(),
          // _buildPageFooter(4, 5),  // Changed to 4, 5
        ],
      );
    },
  ),
);

// =========== PAGE 5: Ceiling, Floor, and Finalization ===========
pdf.addPage(
  pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(formData, logoImage, 5),  // Changed to 5
          pw.SizedBox(height: 15),

          // Ceiling & Floor Photos
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: _buildPhotoSectionWithTable('Ceiling', formData.photoData['Ceiling'] ?? {}),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: _buildPhotoSectionWithTable('Floor', formData.photoData['Floor'] ?? {}),
              ),
            ],
          ),
          pw.SizedBox(height: 15),

          // Finalization Section
          _buildSectionTitle('Finalization'),
          pw.SizedBox(height: 8),
          _buildFinalizationTable(formData),

          // Footer
          // pw.Spacer(),
          // _buildPageFooter(5, 5),  // Changed to 5, 5
        ],
      );
    },
  ),
);

    return pdf.save();
  }

  // ==================== HEADER (Matching reference style) ====================
  static pw.Widget _buildHeader(
    TourerDampModel formData,
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
            // Logo
            if (logoImage != null)
              pw.Container(
                width: 100,
                height: 50,
                child: pw.Image(logoImage, fit: pw.BoxFit.contain),
              )
            else
              pw.Container(
                width: 100,
                height: 50,
                child: pw.Text('LOGO', style: pw.TextStyle(fontSize: 9)),
              ),

            pw.SizedBox(width: 15),
            
            // Title and Info
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Static Carvan Damp Report',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'All work must be carried out in accordance with the latest AWS Damp Testing Matrix and Service Technician\'s Handbook',
                    style: pw.TextStyle(fontSize: 7),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Only readings of over 15% are recorded. Personal belongings will not be removed from lockers and storage areas.',
                    style: pw.TextStyle(fontSize: 7),
                    textAlign: pw.TextAlign.start,
                  ),
                ],
              ),
            ),

            pw.SizedBox(width: 15),

            // Workshop Info
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
                    '${formData.jobReference.isNotEmpty ? formData.jobReference : 'Not provided'}',
                    style: pw.TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),

        // Customer Info Table (Matching reference style)
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
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

  // ==================== SECTION TITLE ====================
  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        ),
      ),
    );
  }

  // ==================== MAIN INFORMATION TABLE ====================
  static pw.Widget _buildMainInfoTable(TourerDampModel formData) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Field',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Value',
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
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Workshop Name & Address',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.workshopName.isNotEmpty ? formData.workshopName : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Job Reference/Date',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.jobReference.isNotEmpty ? formData.jobReference : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== CUSTOMER INFORMATION TABLE ====================
  static pw.Widget _buildCustomerInfoTable(TourerDampModel formData) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Field',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Value',
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
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Customer Name',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.customerName.isNotEmpty ? formData.customerName : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Make & Model',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.makeModel.isNotEmpty ? formData.makeModel : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Registration Number',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.registrationNumber.isNotEmpty ? formData.registrationNumber : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'CRIS/Vin Number',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.crisVinNumber.isNotEmpty ? formData.crisVinNumber : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== COMMENTS SECTION ====================
  static pw.Widget _buildCommentsSection(String comments) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
            ),
            child: pw.Text(
              'Comments & Recommendations',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            child: comments.isNotEmpty
                ? pw.Text(
                    comments,
                    style: pw.TextStyle(
                      fontSize: 10,
                      height: 1.5,
                      color: PdfColors.grey800,
                    ),
                  )
                : pw.Text(
                    '(No comments or recommendations provided)',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ==================== GUIDANCE NOTES (BLUE) ====================
  static pw.Widget _buildGuidanceNotesSection() {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#173EA6'),
            ),
            child: pw.Row(
              children: [
                pw.Text(
                  'Guidance Note',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
          
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            child: pw.Text(
              'Moisture levels between 0-15% - no cause for concern, only readings of over 15% are recorded. '
              'Moisture levels between 15-20% - may require further investigation. Compare with average readings and consider a recheck after 3 months.\n\n'
              'Moisture levels between 20-30% - will require further investigations to look for other possible indications of water ingress. '
              'Possible resealing required to avoid further degrading.\n\n'
              'Moisture levels 30% and above may indicate that structural damage or deterioration is occurring. '
              'Possible resealing required to avoid further degrading followed by immediate rectification action, as necessary.',
              style: pw.TextStyle(
                fontSize: 10,
                height: 1.5,
                color: PdfColors.grey800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PRECAUTION NOTES (BLACK) ====================
  static pw.Widget _buildPrecautionNotesSection() {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(
              color: PdfColors.black,
            ),
            child: pw.Row(
              children: [
                pw.Text(
                  'Precaution Note',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
          
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            child: pw.Text(
              'We would emphasise that the above report accurately reflects the condition of your motorhome at the date stated. '
              'These readings may be subject to atmospheric conditions and the company cannot accept any liability for damp, '
              'which may become apparent at a future date. Completed in line with the latest AWS Damp Testing Matrix and carried out '
              'in accordance with the latest AWS service technician\'s handbook and manufacturers guidance in relation to areas required to test. '
              'Only the inside of the habitation unit is tested. Personal belongings will not be removed from lockers and storage areas, '
              'which therefore, may limit the scope of the damp report.',
              style: pw.TextStyle(
                fontSize: 10,
                height: 1.5,
                color: PdfColors.grey800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PHOTO SECTION WITH TABLE STRUCTURE ====================
  static pw.Widget _buildPhotoSectionWithTable(String title, Map<String, dynamic> data) {
    bool hasImage = data['attachedFileBytes'] != null;
    String comments = data['comments']?.toString() ?? '';
    
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Title
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          
          // Image Container
          pw.Container(
            height: 150,
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            child: hasImage
                ? pw.Image(
                    pw.MemoryImage(data['attachedFileBytes'] as Uint8List),
                    fit: pw.BoxFit.cover,
                  )
                : pw.Container(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        'NO IMAGE\nATTACHED',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ),
          ),
          
          // File Name (if exists)
          if (hasImage && data['attachedFile'] != null)
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey200, width: 0.5),
              ),
              child: pw.Text(
                'File: ${data['attachedFile']}',
                style: pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          
          // Comments
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey200, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Comments:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey50,
                    border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                  ),
                  child: comments.isNotEmpty
                      ? pw.Text(
                          comments,
                          style: pw.TextStyle(
                            fontSize: 9,
                            height: 1.4,
                            color: PdfColors.grey800,
                          ),
                        )
                      : pw.Text(
                          '(No comments provided)',
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== FINALIZATION TABLE ====================
  static pw.Widget _buildFinalizationTable(TourerDampModel formData) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Field',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Value',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        // Damp Meter Information
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Damp Meter Calibration Check Figure',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.dampMeterCalibration.isNotEmpty ? formData.dampMeterCalibration : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Damp Meter Make & Model',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.dampMeterMakeModel.isNotEmpty ? formData.dampMeterMakeModel : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        // Test Conditions
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Weather Conditions',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.weatherConditions.isNotEmpty ? formData.weatherConditions : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Ambient Temperature',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.ambientTemperature.isNotEmpty ? formData.ambientTemperature : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        // Service Technician
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Service Technician Name',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.serviceTechnicianName.isNotEmpty ? formData.serviceTechnicianName : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        // Technician Signature
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Technician Signature',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.technicianSignatureText.isNotEmpty ? formData.technicianSignatureText : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        // Customer Signature
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Customer Signature',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.customerSignatureText.isNotEmpty ? formData.customerSignatureText : 'Not provided',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        // Date
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                'Date',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6.0),
              child: pw.Text(
                formData.date != null 
                    ? DateFormat('dd/MM/yyyy').format(formData.date!)
                    : 'Not specified',
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== PAGE FOOTER ====================
  // static pw.Widget _buildPageFooter(int currentPage, int totalPages) {
  //   return pw.Container(
  //     width: double.infinity,
  //     padding: const pw.EdgeInsets.symmetric(vertical: 10),
  //     decoration: pw.BoxDecoration(
  //       border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
  //     ),
  //     child: pw.Row(
  //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //       children: [
  //         pw.Text(
  //           'Page $currentPage of $totalPages',
  //           style: pw.TextStyle(
  //             fontSize: 9,
  //             color: PdfColors.grey600,
  //           ),
  //         ),
  //         pw.Text(
  //           'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  //           style: pw.TextStyle(
  //             fontSize: 9,
  //             color: PdfColors.grey600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ==================== HELPER METHODS ====================
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
}