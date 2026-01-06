import 'dart:typed_data';
import 'package:data/models/service_form_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfExportService {
  static Future<Uint8List> generatePdf(
    ServiceFormModel formData, {
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

              // First Row: Underbody and Water System
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

    // Add second page (Electrical System and Bodywork)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(formData, logoImage),
              pw.SizedBox(height: 10),

              // Electrical System
              _buildElectricalSystemSection(formData),
              pw.SizedBox(height: 10),
              
              // Bodywork
              _buildBodyworkSection(formData),
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

              // Gas System and Ventilation
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(child: _buildGasSystemSection(formData)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: _buildVentilationSection(formData)),
                ],
              ),
              pw.SizedBox(height: 10),

              // Fire & Safety and Smoke/CO
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(child: _buildFireSafetySection(formData)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: _buildSmokeCOSection(formData)),
                ],
              ),
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

              // Additional Information
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

              // Battery Info
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

              // Finalization
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
    ServiceFormModel formData,
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
              pw.Container(width: 100, height: 50, child: pw.Image(logoImage))
            else
              pw.Container(
                width: 100,
                height: 50,
                child: pw.Text('LOGO', style: pw.TextStyle(fontSize: 9)),
              ),

            pw.SizedBox(width: 15),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Motorhome Annual Habitation Service Check Sheet',
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
                    '${formData.jobReference.isNotEmpty ? formData.jobReference : 'Not provided'}',
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

  static pw.Widget _buildUnderbodySection(ServiceFormModel formData) {
    return _buildSectionWithCheckboxes(
      'Underbody',
      formData.chassisRunningGear.keys.toList(),
      formData.chassisRunningGear,
      formData,
    );
  }

  static pw.Widget _buildElectricalSystemSection(ServiceFormModel formData) {
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
          
          // Horizontal layout for 240V and 12V tables
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 240V Appliances Table
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
              // 12V Appliances Table
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
          
          // Comments
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

  static pw.Widget _buildElectrical240VTable(ServiceFormModel formData) {
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

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
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
                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'P',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'F',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'N/A',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'R',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
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
                  _formatElectricalItemName(item),
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(formData.electricalSystem[item] == 'P'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(formData.electricalSystem[item] == 'F'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(formData.electricalSystem[item] == 'N/A'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(formData.electricalSystem[item] == 'R'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  static pw.Widget _buildElectrical12VTable(ServiceFormModel formData) {
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

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
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
                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'P',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'F',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'N/A',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Center(
                child: pw.Text(
                  'R',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
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
                  _formatElectricalItemName(item),
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(formData.electricalSystem[item] == 'P'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(formData.electricalSystem[item] == 'F'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(formData.electricalSystem[item] == 'N/A'),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4.0),
                child: pw.Center(
                  child: _buildCheckboxCell(formData.electricalSystem[item] == 'R'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  static String _formatElectricalItemName(String original) {
    final name = original.replaceAll('Select* ', '').replaceAll('Check* ', '');
    if (name.length > 30) {
      return name.substring(0, 30) + '...';
    }
    return name;
  }

  static pw.Widget _buildGasSystemSection(ServiceFormModel formData) {
    // Define the expected gas system items in the correct order
    // This prevents duplicates and ensures consistent ordering
    List<String> expectedItems = [
      'Select* Regulator, Gas Hose, Pipe..',
      'Select* Gas Tightness Check',
      'Select* Gas Dispersal Vents',
      'Select* Security Of Gas Cylinder',
      'Select* Operation of Fridge & FF',
      'Check* Operation of Hob/Cooker & FF',
      'Check* Operation of Space Heater & FF',
      'Check* Operation of Water Heater & FF',
      'Select* CO Test',
    ];
    
    // Filter to only include expected items that exist in the map
    // This prevents duplicates from incorrectly formatted keys
    List<String> items = expectedItems.where((key) => formData.gasSystem.containsKey(key)).toList();
    
    // Create a filtered map with only the expected keys to avoid duplicates
    Map<String, String> filteredMap = {};
    for (String key in items) {
      if (formData.gasSystem.containsKey(key)) {
        filteredMap[key] = formData.gasSystem[key]!;
      }
    }
    
    // Also check for legacy keys without prefixes and merge them if they exist
    for (String expectedKey in expectedItems) {
      String legacyKey = expectedKey.replaceAll('Select* ', '').replaceAll('Check* ', '');
      if (formData.gasSystem.containsKey(legacyKey) && !filteredMap.containsKey(expectedKey)) {
        filteredMap[expectedKey] = formData.gasSystem[legacyKey]!;
      }
    }
    
    return _buildSectionWithCheckboxes(
      'Gas System',
      items.isEmpty ? expectedItems : items,
      filteredMap.isEmpty ? formData.gasSystem : filteredMap,
      formData,
    );
  }



  static pw.Widget _buildWaterSystemSection(ServiceFormModel formData) {
    return _buildSectionWithCheckboxes(
      'Water System',
      formData.waterSystem.keys.toList(),
      formData.waterSystem,
      formData,
    );
  }

  static pw.Widget _buildBodyworkSection(ServiceFormModel formData) {
    return _buildSectionWithCheckboxes(
      'Bodywork',
      formData.bodywork.keys.toList(),
      formData.bodywork,
      formData,
    );
  }

  static pw.Widget _buildVentilationSection(ServiceFormModel formData) {
    return _buildSectionWithCheckboxes(
      'Ventilation',
      formData.ventilation.keys.toList(),
      formData.ventilation, 
      formData,
    );
  }

  static pw.Widget _buildFireSafetySection(ServiceFormModel formData) {
    return _buildSectionWithCheckboxes(
      'Fire & Safety',
      formData.fireSafety.keys.toList(),
      formData.fireSafety,
      formData,
    );
  }

  static pw.Widget _buildSmokeCOSection(ServiceFormModel formData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
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
              _buildSmokeCORow('Smoke Alarm Expiry Date', formData.smokeAlarmExpiryDate),
              _buildSmokeCORow('Carbon Monoxide Alarm Expiry Date', formData.carbonMonoxideAlarmExpiryDate),
              _buildSmokeCORow('Fire Extinguisher Expiry Date', formData.fireExtinguisherExpiryDate),
            ],
          ),
        ],
      ),
    );
  }

  static pw.TableRow _buildSmokeCORow(String label, String value) {
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

  static pw.Widget _buildAdditionalInformationSection(ServiceFormModel formData) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1.5),
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
        _buildAdditionalInfoRow('Customer Name:', formData.additionalCustomerName),
        _buildAdditionalInfoRow('Make & Model:', formData.additionalMakeModel),
        _buildAdditionalInfoRow('Vin Number:', formData.additionalVinNumber),
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
    );
  }

  static pw.TableRow _buildAdditionalInfoRow(String label, String value) {
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

  static pw.Widget _buildBatteryInfoSection(ServiceFormModel formData) {
    return pw.Table(
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
        _buildBatteryInfoRow('Battery Rest Voltage', formData.batteryRestVoltage),
        _buildBatteryInfoRow('RCD Test 1x1', formData.rcdTest1x1),
        _buildBatteryInfoRow('RCD Test 5 Times', formData.rcdTest5Times),
        _buildBatteryInfoRow('Earth Bond Chassis', formData.earthBondChassis),
        _buildBatteryInfoRow('Continuity Test Gas', formData.continuityTestGas),
        _buildBatteryInfoRow('Charger Voltage', formData.chargerVoltage),
        _buildBatteryInfoRow('Gas Hose Expiry Date', formData.gasHoseExpiryDate),
        _buildBatteryInfoRow('Regulator Age', formData.regulatorAge),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('Comments', style: pw.TextStyle(fontSize: 9)),
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
    );
  }

  static pw.TableRow _buildBatteryInfoRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4.0),
          child: pw.Text(label, style: pw.TextStyle(fontSize: 9)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4.0),
          child: pw.Text(
            value.isNotEmpty ? value : 'Not provided',
            style: pw.TextStyle(fontSize: 9),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFinalizationSection(ServiceFormModel formData) {
    return pw.Table(
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
        _buildFinalizationRow('Service Technician Name:', formData.serviceTechnicianName),
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
        _buildFinalizationRow('Customer Signature:', formData.customerSignature),
        _buildFinalizationRow('Signature:', formData.signature),
        _buildFinalizationRow('Date:', formData.date),
      ],
    );
  }

  static pw.TableRow _buildFinalizationRow(String label, String value) {
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

  static pw.Widget _buildSectionWithCheckboxes(
    String title,
    List<String> items,
    Map<String, String> sectionData,
    ServiceFormModel formData,
  ) {
    // Get the correct comments for this section
    String comments = '';
    switch (title) {
      case 'Underbody':
        comments = formData.underbodyComments;
        break;
      case 'Water System':
        comments = formData.waterSystemComments;
        break;
      case 'Bodywork':
        comments = formData.bodyworkComments;
        break;
      case 'Ventilation':
        comments = formData.ventilationComments;
        break;
      case 'Fire & Safety':
        comments = formData.fireSafetyComments;
        break;
      case 'LPG Gas System':
        comments = formData.gasSystemComments;
        break;
    }

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
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(0.5),
              2: const pw.FlexColumnWidth(0.5),
              3: const pw.FlexColumnWidth(0.5),
              4: const pw.FlexColumnWidth(0.5),
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
          ),
          pw.SizedBox(height: 8),
          // Always show comments box, but show "None" if empty
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.5),
              // borderRadius: pw.BorderRadius.circular(2),
            ),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(
              'Comments: ${comments.isNotEmpty ? comments : 'None'}',
              style: pw.TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatItemName(String original) {
    return original.replaceAll('Select* ', '').replaceAll('Check* ', '');
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