// engine_vehicle_pdf.dart
import 'dart:typed_data';
import 'package:data/models/engine_vehicle_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class EngineVehiclePdfService {
  static Future<Uint8List> generatePdf(
    EngineVehicleModel formData, {
    Uint8List? logoImageBytes,
    List<Uint8List>? images,
  }) async {
    final pdf = pw.Document();

    // Load logo image
    final logoImage = logoImageBytes != null
        ? pw.MemoryImage(logoImageBytes)
        : await _loadDefaultLogoImage();

    // Get uploaded images if any
    final uploadedImages = images ?? formData.uploadedImages;

    // Add first page with customer info and service sections
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),

              // Customer Information Section
              _buildCustomerInfoSection(formData),
              pw.SizedBox(height: 15),

               // Main Information Table
              _buildSectionTitle('Mini Service'),
              pw.SizedBox(height: 8),

              // Service Sections - First Row
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildPartsIncludedSection(formData),
                  pw.SizedBox(width: 10),
                  _buildTopupsIncludedSection(formData),
                ],
              ),
              pw.SizedBox(height: 10),

              // Second Row: General Checks and Internal/Vision
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildGeneralChecksSection(formData),
                  pw.SizedBox(width: 10),
                  _buildInternalVisionSection(formData),
                ],
              ),
              pw.SizedBox(height: 10),

              // Third Row: Engine and Brake
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildEngineSection(formData),
                  pw.SizedBox(width: 10),
                  _buildBrakeSection(formData),
                ],
              ),
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
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),

              // First Row: Wheels & Tyres and Steering & Suspension
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildWheelsTyresSection(formData),
                  pw.SizedBox(width: 10),
                  _buildSteeringSuspensionSection(formData),
                ],
              ),
              pw.SizedBox(height: 10),

              // Second Row: Exhaust and Drive System
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildExhaustSection(formData),
                  pw.SizedBox(width: 10),
                  _buildDriveSystemSection(formData),
                ],
              ),
              pw.SizedBox(height: 20),

              // Comments Section
              _buildCommentsSection(formData),
              
              // Add images section if there are any images
              if (uploadedImages.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                _buildImagesSection(uploadedImages),
              ],
              
              pw.SizedBox(height: 10),
              _buildPageFooter(2),
            ],
          );
        },
      ),
    );

    // Add additional pages for images if there are many
    if (uploadedImages.length > 4) {
      for (int i = 0; i < uploadedImages.length; i += 4) {
        final pageImages = uploadedImages.sublist(
          i,
          i + 4 > uploadedImages.length ? uploadedImages.length : i + 4,
        );
        
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(20),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildHeader(formData, logoImage),
                  pw.SizedBox(height: 10),
                  _buildImagesSection(pageImages),
                  pw.SizedBox(height: 10),
                  _buildPageFooter(3 + (i ~/ 4)),
                ],
              );
            },
          ),
        );
      }
    }

    return pdf.save();
  }

  static pw.Widget _buildHeader(
    EngineVehicleModel formData,
    pw.ImageProvider? logoImage,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Logo and Title Row
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // Logo
            if (logoImage != null)
              pw.Container(width: 80, height: 40, child: pw.Image(logoImage))
            else
              pw.Container(
                width: 80,
                height: 40,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Center(
                  child: pw.Text('LOGO', style: pw.TextStyle(fontSize: 8)),
                ),
              ),

            // Title
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'MINI VEHICLE SERVICE FORM',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Professional Vehicle Maintenance Record',
                  style: pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),

            pw.Container(width: 80), // Empty container for spacing
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 1),
      ],
    );
  }

  static pw.Widget _buildCustomerInfoSection(EngineVehicleModel formData) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(6),
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
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Table Content
          pw.Table(
            border: pw.TableBorder.all(
              width: 0.5,
              color: PdfColors.grey400,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5), // Label column
              1: const pw.FlexColumnWidth(2),   // Value column
              2: const pw.FlexColumnWidth(1.5), // Label column
              3: const pw.FlexColumnWidth(2),   // Value column
            },
            children: [
              // First row: Customer Name and Vehicle Registration
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  // Customer Name Label
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      'Customer Name:',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  // Customer Name Value
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                    ),
                    child: pw.Text(
                      formData.customerName.isNotEmpty 
                          ? formData.customerName 
                          : 'Not provided',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  ),
                  // Vehicle Registration Label
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      'Vehicle Registration:',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  // Vehicle Registration Value
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                    ),
                    child: pw.Text(
                      formData.vehicleRegistration.isNotEmpty 
                          ? formData.vehicleRegistration 
                          : 'Not provided',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              ),
              
              // Second row: Mileage and Date of Inspection
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  // Mileage Label
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      'Mileage:',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  // Mileage Value
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                    ),
                    child: pw.Text(
                      formData.mileage.isNotEmpty 
                          ? formData.mileage 
                          : 'Not provided',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  ),
                  // Date of Inspection Label
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      'Date of Inspection:',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  // Date of Inspection Value
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                    ),
                    child: pw.Text(
                      formData.dateOfInspection.isNotEmpty 
                          ? formData.dateOfInspection 
                          : 'Not provided',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ));
  }

  // Individual section builders for each category
  static pw.Widget _buildPartsIncludedSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Parts Included'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Parts Included'] ?? {};
    List<String> items = ['Engine Oil', 'Oil Filter'];
    
    return _buildCompleteSection('Parts Included', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildTopupsIncludedSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Top-ups Included'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Top-ups Included'] ?? {};
    List<String> items = [
      'Windscreen Additive',
      'Coolant',
      'Brake Fluid',
      'Power Steering Fluid',
    ];
    
    return _buildCompleteSection('Top-ups Included', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildGeneralChecksSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['General Checks'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['General Checks'] ?? {};
    List<String> items = ['External Lights', 'Instrument warning'];
    
    return _buildCompleteSection('General Checks', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildInternalVisionSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Internal/Vision'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Internal/Vision'] ?? {};
    List<String> items = ['Condition of Windscreen', 'Wiper and Washers'];
    
    return _buildCompleteSection('Internal/Vision', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildEngineSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Engine'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Engine'] ?? {};
    List<String> items = ['General Oil Leaks', 'Antifreeze Strength', 'Timing Belt'];
    
    return _buildCompleteSection('Engine', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildBrakeSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Brake'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Brake'] ?? {};
    List<String> items = ['Visual Check of brake pads'];
    
    return _buildCompleteSection('Brake', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildWheelsTyresSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Wheels & Tyres'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Wheels & Tyres'] ?? {};
    List<String> items = ['Tyre Condition', 'Tyre Pressure'];
    
    return _buildCompleteSection('Wheels & Tyres', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildSteeringSuspensionSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Steering & Suspension'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Steering & Suspension'] ?? {};
    List<String> items = ['Steering Rack condition'];
    
    return _buildCompleteSection('Steering & Suspension', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildExhaustSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Exhaust'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Exhaust'] ?? {};
    List<String> items = ['Exhaust condition'];
    
    return _buildCompleteSection('Exhaust', mainDropdownValue, items, detailedData);
  }

  static pw.Widget _buildDriveSystemSection(EngineVehicleModel formData) {
    String mainDropdownValue = formData.mainDropdownValues['Drive System'] ?? '';
    Map<String, String> detailedData = formData.miniServiceData['Drive System'] ?? {};
    List<String> items = ['Clutch Fluid level', 'Transmission oil'];
    
    return _buildCompleteSection('Drive System', mainDropdownValue, items, detailedData);
  }

  // Universal method to build complete section with main dropdown value and detailed items
  static pw.Widget _buildCompleteSection(
    String title,
    String mainDropdownValue,
    List<String> items,
    Map<String, String> detailedData,
  ) {
    return pw.Container(
      width: 260,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Section header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(4),
                topRight: pw.Radius.circular(4),
              ),
            ),
            child: pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Checkbox table
          pw.Table(
            border: pw.TableBorder.all(width: 0.3),
            columnWidths: {
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(1),
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text('Item', style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Center(
                      child: pw.Text('P', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Center(
                      child: pw.Text('F', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Center(
                      child: pw.Text('N/A', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Center(
                      child: pw.Text('R', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              
              // Main dropdown value row (FIRST ROW - shows main dropdown selection)
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text(
                      '$title',
                      style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Center(
                      child: _buildCheckboxCell(mainDropdownValue == 'P'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Center(
                      child: _buildCheckboxCell(mainDropdownValue == 'F'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Center(
                      child: _buildCheckboxCell(mainDropdownValue == 'N/A'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Center(
                      child: _buildCheckboxCell(mainDropdownValue == 'R'),
                    ),
                  ),
                ],
              ),
              
              // Detailed items rows (Engine Oil, Oil Filter, etc.)
              for (var item in items)
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Text(item, style: pw.TextStyle(fontSize: 7)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Center(
                        child: _buildCheckboxCell(detailedData[item] == 'P'),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Center(
                        child: _buildCheckboxCell(detailedData[item] == 'F'),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Center(
                        child: _buildCheckboxCell(detailedData[item] == 'N/A'),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Center(
                        child: _buildCheckboxCell(detailedData[item] == 'R'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
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
          border: pw.Border.all(color: PdfColors.black, width: 0.5),
          color: isChecked ? PdfColors.black : PdfColors.white,
        ),
      ),
    );
  }

  static pw.Widget _buildCommentsSection(EngineVehicleModel formData) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(4),
                topRight: pw.Radius.circular(4),
              ),
            ),
            child: pw.Text(
              'COMMENTS',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Content
          pw.Padding(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Text(
              formData.comments.isNotEmpty ? formData.comments : 'No comments provided',
              style: pw.TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildImagesSection(List<Uint8List> images) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey300,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(4),
                topRight: pw.Radius.circular(4),
              ),
            ),
            child: pw.Text(
              'ATTACHMENTS',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          
          // Images Grid
          pw.Padding(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Wrap(
              spacing: 10,
              runSpacing: 10,
              children: images.map((imageBytes) {
                try {
                  return pw.Container(
                    width: 80,
                    height: 80,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Image(
                      pw.MemoryImage(imageBytes),
                      fit: pw.BoxFit.cover,
                    ),
                  );
                } catch (e) {
                  return pw.Container(
                    width: 80,
                    height: 80,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        'Image',
                        style: pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
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