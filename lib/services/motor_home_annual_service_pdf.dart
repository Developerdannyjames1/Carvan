import 'dart:typed_data';
import 'package:data/models/motor_home_annual_service_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class MotorHomeAnnualServicePdfService {
  static Future<Uint8List> generatePdf(
    MotorHomeAnnualServiceModel formData, {
    Uint8List? logoImageBytes,
  }) async {
    final pdf = pw.Document();

    // Load logo image
    final logoImage = logoImageBytes != null
        ? pw.MemoryImage(logoImageBytes)
        : await _loadDefaultLogoImage();

    // Add first page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),

              // Customer Information Section
              _buildCustomerInfoSection(formData),
              pw.SizedBox(height: 10),

              // Photo Documentation Sections - Page 1
              _buildPhotoDocumentationSection(formData, 1),
              pw.SizedBox(height: 10),
              _buildPageFooter(1),
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

              // Continue Photo Documentation Sections - Page 2
              _buildPhotoDocumentationSection(formData, 2),
              pw.SizedBox(height: 10),

              // Final Attachments Section
              if (formData.finalAttachments.isNotEmpty || 
                  formData.finalComments.isNotEmpty)
                _buildFinalAttachmentsSection(formData),

              pw.SizedBox(height: 10),
              _buildPageFooter(2),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(
    MotorHomeAnnualServiceModel formData,
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
            // Title
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Motor Home Annual Service Form',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'Complete Annual Service & Inspection Record',
                    style: pw.TextStyle(fontSize: 9),
                    textAlign: pw.TextAlign.start,
                  ),
                ],
              ),
            ),

            pw.SizedBox(width: 15),

            // Service Info - Right side
            pw.Container(
              width: 120,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Service Date',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    formData.dateOfInspection.isNotEmpty
                        ? formData.dateOfInspection
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 7),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Operator',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    formData.operator.isNotEmpty
                        ? formData.operator
                        : 'Not provided',
                    style: pw.TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),

        // Vehicle info table - ONLY SHOW FIELDS FROM FORM
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.2),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(0.8),
          },
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Vehicle Registration',
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
                    'Odometer Reading',
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
                    formData.vehicleRegistration.isNotEmpty
                        ? formData.vehicleRegistration
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
                    formData.mileage.isNotEmpty
                        ? formData.mileage
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

  static pw.Widget _buildCustomerInfoSection(
    MotorHomeAnnualServiceModel formData,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Customer Information',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(3),
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
                  child: pw.Text(
                    'Field',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4.0),
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
            // Data rows - ONLY THE 5 FIELDS FROM YOUR FORM
            _buildCustomerInfoRow('Vehicle Registration', formData.vehicleRegistration),
            _buildCustomerInfoRow('Odometer Reading', formData.mileage),
            _buildCustomerInfoRow('Make & Type', formData.makeModel),
            _buildCustomerInfoRow('Date of Inspection', formData.dateOfInspection),
            _buildCustomerInfoRow('Operator', formData.operator),
            // NO additional fields - only what's in your form
          ],
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  static pw.TableRow _buildCustomerInfoRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4.0),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4.0),
          child: pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Text(
              value.isNotEmpty ? value : 'Not provided',
              style: pw.TextStyle(fontSize: 8),
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPhotoDocumentationSection(
    MotorHomeAnnualServiceModel formData,
    int pageNumber,
  ) {
    List<String> sections;
    String title;
    
    if (pageNumber == 1) {
      sections = ['Front', 'Rear'];
      title = 'PHOTO DOCUMENTATION - PART 1';
    } else {
      sections = ['Nearside', 'Offside'];
      title = 'PHOTO DOCUMENTATION - PART 2';
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            for (var section in sections)
              pw.Expanded(
                child: pw.Column(
                  children: [
                    _buildPhotoSectionWithImage(section, formData.photoData[section] ?? {}),
                    if (section != sections.last) pw.SizedBox(width: 10),
                  ],
                ),
              ),
          ],
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  static pw.Widget _buildPhotoSectionWithImage(String title, Map<String, dynamic> data) {
    bool hasImage = data['attachedFileBytes'] != null;
    
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Title
          pw.Container(
            padding: const pw.EdgeInsets.all(4.0),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            child: pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Image or placeholder
          pw.Container(
            width: double.infinity,
            height: 120,
            padding: const pw.EdgeInsets.all(8.0),
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
                        'NO IMAGE ATTACHED',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
          ),
          
          // File name
          if (data['attachedFile'] != null)
            pw.Container(
              padding: const pw.EdgeInsets.all(4.0),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'FILE NAME:',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    data['attachedFile'] as String,
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ),
          
          // Comments
          if (data['comments']?.isNotEmpty == true)
            pw.Container(
              padding: const pw.EdgeInsets.all(4.0),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Comments',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    data['comments']?.toString() ?? '',
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildFinalAttachmentsSection(MotorHomeAnnualServiceModel formData) {
    bool hasAttachments = formData.finalAttachments.isNotEmpty;
    bool hasComments = formData.finalComments.isNotEmpty;
    
    if (!hasAttachments && !hasComments) {
      return pw.Container();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Final Attachments & Comments',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        
        // Show attachment images if available
        if (formData.finalAttachmentBytes.isNotEmpty)
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(4.0),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  child: pw.Text(
                    'ADDITIONAL IMAGES (${formData.finalAttachmentBytes.length})',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                
                // Images grid
                pw.Container(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: formData.finalAttachmentBytes.isEmpty
                      ? pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'No images in additional attachments',
                            style: pw.TextStyle(
                              fontSize: 8, 
                              color: PdfColors.grey,
                              fontStyle: pw.FontStyle.italic
                            ),
                          ),
                        )
                      : pw.Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: formData.finalAttachmentBytes.asMap().entries.map((entry) {
                            final index = entry.key;
                            final bytes = entry.value;
                            final fileName = index < formData.finalAttachments.length 
                                ? formData.finalAttachments[index]
                                : 'Image ${index + 1}';
                            
                            return bytes != null
                                ? pw.Container(
                                    width: 90,
                                    height: 70,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                                    ),
                                    child: pw.Column(
                                      children: [
                                        pw.Expanded(
                                          child: pw.Image(
                                            pw.MemoryImage(bytes),
                                            fit: pw.BoxFit.cover,
                                          ),
                                        ),
                                        pw.Container(
                                          padding: const pw.EdgeInsets.all(2),
                                          color: PdfColors.grey50,
                                          child: pw.Text(
                                            fileName.length > 12 
                                                ? '${fileName.substring(0, 10)}...' 
                                                : fileName,
                                            style: const pw.TextStyle(fontSize: 6),
                                            textAlign: pw.TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : pw.Container(
                                    width: 90,
                                    height: 70,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                                      color: PdfColors.grey100,
                                    ),
                                    child: pw.Center(
                                      child: pw.Text(
                                        'No Image',
                                        style: pw.TextStyle(
                                          fontSize: 7, 
                                          color: PdfColors.grey
                                        ),
                                      ),
                                    ),
                                  );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        
        // Final Comments
        if (hasComments) ...[
          if (hasAttachments) pw.SizedBox(height: 8),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(4.0),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  child: pw.Text(
                    'FINAL COMMENTS',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                
                // Comments content
                pw.Container(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    formData.finalComments,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        pw.SizedBox(height: 8),
      ],
    );
  }

  static pw.Widget _buildPageFooter(int pageNumber) {
    return pw.Container(
      width: double.infinity,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Part $pageNumber of 2', style: pw.TextStyle(fontSize: 9)),
          pw.Text(
            'Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(fontSize: 9),
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
      print('Error loading default logo image: $e');
      return null;
    }
  }
}