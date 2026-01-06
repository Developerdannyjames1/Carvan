import 'dart:typed_data';
import 'package:data/models/tourer_annual_service_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TourerAnnualPDf {
  static Future<Uint8List> generatePdf(
    TourerAnnualServiceModel formData, {
    Uint8List? logoImageBytes,
    Uint8List? bodyworkImageBytes,
  }) async {
    final pdf = pw.Document();

    // Load logo image
    final logoImage = logoImageBytes != null
        ? pw.MemoryImage(logoImageBytes)
        : await _loadDefaultLogoImage();

    // Load bodywork attachment
    final bodyworkImage = bodyworkImageBytes != null
        ? pw.MemoryImage(bodyworkImageBytes)
        : null;

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
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(child: _buildUnderbodySection(formData)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: _buildWaterSystemSection(formData)),
                ],
              ),
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
              _buildElectricalSystemSection(formData),
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
              // pw.SizedBox(height: 10),
              // _buildElectricalSystemSection(formData),
              pw.SizedBox(height: 10),
              _buildBodyworkSection(formData, bodyworkImage),
              // pw.SizedBox(width: 10),
              //  pw.Expanded(child: _buildGasSystemSection(formData)),

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
              // pw.SizedBox(height: 10),
              // _buildElectricalSystemSection(formData),
              pw.SizedBox(height: 10),
               pw.Expanded(child: _buildGasSystemSection(formData)),

            ],
          );
        },
      ),
    );

    // Add fifth page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // pw.Expanded(child: _buildGasSystemSection(formData)),
                  // pw.SizedBox(width: 10),
                  pw.Expanded(child: _buildVentilationSection(formData)),
                          pw.SizedBox(width: 10),
                            pw.Expanded(child: _buildFireSafetySection(formData)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // pw.Expanded(child: _buildFireSafetySection(formData)),
                  // pw.SizedBox(width: 10),
                  pw.Expanded(child: _buildSmokeCOSection(formData)),
                ],
              ),
            ],
          );
        },
      ),
    );

     // Add sixth page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Additional Information',
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  _buildAdditionalInformationSection(formData),
                ],
              ),
              pw.SizedBox(height: 10),
         
       
            ],
          );
        },
      ),
    );

    // Add 7th page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              // pw.SizedBox(height: 10),
              // pw.Column(
              //   crossAxisAlignment: pw.CrossAxisAlignment.start,
              //   children: [
              //     pw.Text(
              //       'Additional Information',
              //       style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
              //     ),
              //     pw.SizedBox(height: 8),
              //     _buildAdditionalInformationSection(formData),
              //   ],
              // ),
              pw.SizedBox(height: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Battery Info',
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  _buildBatteryInfoSection(formData),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Finalization',
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  _buildFinalizationSection(formData),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<pw.MemoryImage?> _loadDefaultLogoImage() async {
    try {
      final byteData = await rootBundle.load('assets/images/logoimg.png');
      final Uint8List imageBytes = byteData.buffer.asUint8List();
      return pw.MemoryImage(imageBytes);
    } catch (e) {
      print('Error loading default logo image: $e');
      return null;
    }
  }

  static pw.Widget _buildHeader(
    TourerAnnualServiceModel formData,
    pw.ImageProvider? logoImage,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
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
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Center(
                  child: pw.Text(
                    'LOGO',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
                  ),
                ),
              ),
            pw.SizedBox(width: 15),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Tourer Annual Service',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'All work must be carried out in accordance with the latest AWS Standard Working Procedures',
                    style: pw.TextStyle(fontSize: 7),
                    textAlign: pw.TextAlign.start,
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Service Technician: Please ensure that every question is answered correctly using: P (pass), F (fail), N/A (not applicable) & R (rectified)',
                    style: pw.TextStyle(fontSize: 7),
                    textAlign: pw.TextAlign.start,
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 15),
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

  static pw.Widget _buildUnderbodySection(TourerAnnualServiceModel formData) {
    return _buildCheckboxSection(
      'Underbody',
      formData.chassisRunningGear,
      formData.underbodyComments,
    );
  }

  static pw.Widget _buildElectricalSystemSection(TourerAnnualServiceModel formData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Electrical System',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '240 V Appliances',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    _buildElectrical240VTable(formData),
                  ],
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '12 V Appliances',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    _buildElectrical12VTable(formData),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
              borderRadius: pw.BorderRadius.circular(2),
            ),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(
              'Comments: ${formData.electricalSystemComments.isNotEmpty ? formData.electricalSystemComments : 'None'}',
              style: pw.TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildElectrical240VTable(TourerAnnualServiceModel formData) {
    final items = [
      '230V consumer unit load test RCD',
      'LV inlet plug & extension lead',
      'Earth bonding continuity test',
      '230V sockets',
      'Charge voltage',
      'Hob/Cooker Mains Test',
      'Water Heater Mains Test',
      'Room Heater Mains Test',
      '230V & 12V fridge operation',
      'Check all aftermarket items',
    ];

    return _buildCheckboxTable(
      items,
      formData.electricalSystem,
    );
  }

  static pw.Widget _buildElectrical12VTable(TourerAnnualServiceModel formData) {
    final items = [
      'Leisure battery condition',
      'Road lights & reflectors',
      'Fuse box & fuse rating check',
      'Interior lighting & equipment',
      'Wiring on all ELV circuits',
      '12V fridge operation',
      'Check Blower System',
      '12V Charger',
    ];

    return _buildCheckboxTable(
      items,
      formData.electricalSystem,
    );
  }

static pw.Widget _buildGasSystemSection(TourerAnnualServiceModel formData) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Gas System',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        _buildGasSystemTable(formData.gasSystem),
        pw.SizedBox(height: 8),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            borderRadius: pw.BorderRadius.circular(2),
          ),
          padding: const pw.EdgeInsets.all(4),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Comments:',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                formData.gasSystemComments.isNotEmpty ? formData.gasSystemComments : 'None',
                style: pw.TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Add this new method to build the gas system table
static pw.Table _buildGasSystemTable(Map<String, String> gasSystemData) {
  // Define the correct keys that match your form
  final items = [
    'Regulator, Gas Hose, Pipe..',
    'Gas Tightness Check',
    'Gas Dispersal Vents',
    'Security Of Gas Cylinder',
    'Operation of Fridge & FF',
    'Operation of Hob/Cooker & FF',
    'Operation of Space Heater & FF',
    'Operation of Water Heater & FF',
    'CO Test',
  ];

  return pw.Table(
    border: pw.TableBorder.all(width: 0.5),
    columnWidths: {
      0: const pw.FlexColumnWidth(3),
      1: const pw.FlexColumnWidth(0.4),
      2: const pw.FlexColumnWidth(0.4),
      3: const pw.FlexColumnWidth(0.4),
      4: const pw.FlexColumnWidth(0.4),
    },
    children: [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              'Item',
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Center(
              child: pw.Text(
                'P',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Center(
              child: pw.Text(
                'F',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Center(
              child: pw.Text(
                'N/A',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Center(
              child: pw.Text(
                'R',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      for (var item in items)
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text(
                _formatGasSystemItemName(item),
                style: pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: _buildCheckboxCell(gasSystemData[item] == 'P'),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: _buildCheckboxCell(gasSystemData[item] == 'F'),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: _buildCheckboxCell(gasSystemData[item] == 'N/A'),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: _buildCheckboxCell(gasSystemData[item] == 'R'),
              ),
            ),
          ],
        ),
    ],
  );
}

// Add this helper method for formatting gas system item names
static String _formatGasSystemItemName(String original) {
  return original
      .replaceAll('Select* ', '')
      .replaceAll('Check* ', '')
      .replaceAll('&', '&')
      .replaceAll('..', '...')
      .replaceAll('FF', 'Flame Failure');
}

  static pw.Widget _buildWaterSystemSection(TourerAnnualServiceModel formData) {
    return _buildCheckboxSection(
      'Water System',
      formData.waterSystem,
      formData.waterSystemComments,
    );
  }

  static pw.Widget _buildBodyworkSection(
    TourerAnnualServiceModel formData,
    pw.MemoryImage? bodyworkImage,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Bodywork',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          _buildCheckboxTable(
            formData.bodywork.keys.toList(),
            formData.bodywork,
          ),
          pw.SizedBox(height: 8),
          if (bodyworkImage != null)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Bodywork Attachment:',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Container(
                  padding: const pw.EdgeInsets.all(4),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Image(
                    bodyworkImage,
                    width: 150,
                    height: 100,
                    fit: pw.BoxFit.cover,
                  ),
                ),
                pw.SizedBox(height: 8),
              ],
            ),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
              borderRadius: pw.BorderRadius.circular(2),
            ),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Comments:',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  formData.bodyworkComments.isNotEmpty ? formData.bodyworkComments : 'None',
                  style: pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildVentilationSection(TourerAnnualServiceModel formData) {
    return _buildCheckboxSection(
      'Ventilation',
      formData.ventilation,
      formData.ventilationComments,
    );
  }

  static pw.Widget _buildFireSafetySection(TourerAnnualServiceModel formData) {
    return _buildCheckboxSection(
      'Fire & Safety',
      formData.fireSafety,
      formData.fireSafetyComments,
    );
  }

  static pw.Widget _buildSmokeCOSection(TourerAnnualServiceModel formData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      // decoration: pw.BoxDecoration(
      //   border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
      //   borderRadius: pw.BorderRadius.circular(4),
      // ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Smoke/Carbon Monoxide',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(1),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Item',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Value',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              _buildTextRow('Smoke Alarm Expiry Date', formData.smokeAlarmExpiryDate),
              _buildTextRow('Carbon Monoxide Alarm Expiry Date', formData.carbonMonoxideAlarmExpiryDate),
              _buildTextRow('Fire Extinguisher Expiry Date', formData.fireExtinguisherExpiryDate),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
              borderRadius: pw.BorderRadius.circular(2),
            ),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Comments:',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  formData.smokeCOAlarmComments.isNotEmpty 
                      ? formData.smokeCOAlarmComments 
                      : 'None',
                  style: pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAdditionalInformationSection(TourerAnnualServiceModel formData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Additional Information',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.2),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Field',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Value',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              _buildTextRow('Customer Name:', formData.additionalCustomerName),
              _buildTextRow('Make & Model:', formData.additionalMakeModel),
              _buildTextRow('Vin Number:', formData.additionalVinNumber),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6.0),
                    child: pw.Text(
                      'Service Information:',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6.0),
                    child: pw.Text(
                      formData.additionalServiceInfo.isNotEmpty
                          ? formData.additionalServiceInfo
                          : 'None',
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
                      'Comments:',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6.0),
                    child: pw.Text(
                      formData.additionalComments.isNotEmpty
                          ? formData.additionalComments
                          : 'None',
                      style: pw.TextStyle(fontSize: 9),
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

  static pw.Widget _buildBatteryInfoSection(TourerAnnualServiceModel formData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Battery Info',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(1),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Test/Parameter',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Value',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              _buildTextRow('Battery Rest Voltage', formData.batteryRestVoltage),
              _buildTextRow('RCD Test 1x1', formData.rcdTest1x1),
              _buildTextRow('RCD Test 5 Times', formData.rcdTest5Times),
              _buildTextRow('Earth Bond Chassis', formData.earthBondChassis),
              _buildTextRow('Continuity Test Gas', formData.continuityTestGas),
              _buildTextRow('Charger Voltage', formData.chargerVoltage),
              _buildTextRow('Gas Hose Expiry Date', formData.gasHoseExpiryDate),
              _buildTextRow('Regulator Age', formData.regulatorAge),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Comments',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      formData.comments.isNotEmpty ? formData.comments : 'None',
                      style: pw.TextStyle(fontSize: 9),
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

  static pw.Widget _buildFinalizationSection(TourerAnnualServiceModel formData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Finalization',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Field',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4.0),
                    child: pw.Text(
                      'Value',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              _buildTextRow('Service Technician Name:', formData.serviceTechnicianName),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6.0),
                    child: pw.Text(
                      'EICR Offered:',
                      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6.0),
                    child: pw.Text(
                      formData.eicrOffered ? 'Yes' : 'No',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              ),
              _buildTextRow('Customer Signature:', formData.customerSignature),
              _buildTextRow('Signature:', formData.signature),
              _buildTextRow('Date:', formData.date),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Methods
  static pw.Widget _buildCheckboxSection(
    String title,
    Map<String, String> sectionData,
    String comments,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          _buildCheckboxTable(
            sectionData.keys.toList(),
            sectionData,
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
              borderRadius: pw.BorderRadius.circular(2),
            ),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Comments:',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  comments.isNotEmpty ? comments : 'None',
                  style: pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Table _buildCheckboxTable(
    List<String> items,
    Map<String, String> sectionData,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(0.4),
        2: const pw.FlexColumnWidth(0.4),
        3: const pw.FlexColumnWidth(0.4),
        4: const pw.FlexColumnWidth(0.4),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text(
                'Item',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'P',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'F',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'N/A',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'R',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        for (var item in items)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Text(
                  _formatItemName(item),
                  style: pw.TextStyle(fontSize: 9),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(sectionData[item] == 'P'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(sectionData[item] == 'F'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(sectionData[item] == 'N/A'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(sectionData[item] == 'R'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  static pw.TableRow _buildTextRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6.0),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6.0),
          child: pw.Text(
            value.isNotEmpty ? value : 'Not provided',
            style: pw.TextStyle(fontSize: 9),
          ),
        ),
      ],
    );
  }

  static String _formatItemName(String original) {
    return original
        .replaceAll('Select* ', '')
        .replaceAll('Check* ', '')
        .replaceAll('&', '&')
        .replaceAll('..', '...');
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
}