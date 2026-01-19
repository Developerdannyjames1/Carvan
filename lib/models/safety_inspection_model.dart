// safety_inspection_model.dart

import 'dart:typed_data';

class SafetyInspectionModel {

 // New fields for Main Information
 String workShopName = '';
 String JobReference = '';
 Uint8List? mainImageBytes;
  // Customer Information
  String vehicleRegistration = '';
  String mileage = '';
  String makeModel = '';
  String dateOfInspection = '';
  String workshopName = '';
  String jobReference = '';
  String operator = '';
  String comments = '';
  
  // Section-specific comments (add these)
  String insiderCabComments = '';
  String vehicleGroundLevelComments = '';
  String brakePerformanceComments = '';
  String generalServicingComments = '';

  // Store main dropdown values for each item (V, R, X, N/A)
  Map<String, String> mainDropdownValues = {};
  
  // Detailed inspection data for each individual item (from action button)
  Map<String, Map<String, String>> inspectionData = {};

  // Inspection Report section
  String seenOn = '';
  String signedBy = '';
  String tmOperator = '';

  // Comments on faults found section
  String checkNumber = '';
  String faultDetails = '';
  String signatureOfInspector = '';
  String nameOfInspector = '';

  // Action taken on faults found section
  String actionTakenOnFault = '';
  String rectifiedBy = '';

  // Consider defects have section
  String rectifiedSatisfactorily = '';
  String needsMoreWorkDone = '';
  String signatureOfMechanic = '';
  String date = '';

  DateTime? inspectionDate;

  SafetyInspectionModel({this.inspectionDate}) {
    inspectionDate ??= DateTime.now();
  }

  // Helper method to add main dropdown value
  void setMainDropdownValue(String item, String value) {
    mainDropdownValues[item] = value;
  }

  // Helper method to add detailed inspection data
  void addInspectionData(String item, Map<String, String> data) {
    inspectionData[item] = data;
  }

  // Get all data as JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicleRegistration': vehicleRegistration,
      'mileage': mileage,
      'makeModel': makeModel,
      'workshopName': workshopName,
      'jobReference': jobReference,
      'operator': operator,
      'comments': comments,
      'insiderCabComments': insiderCabComments,
      'vehicleGroundLevelComments': vehicleGroundLevelComments,
      'brakePerformanceComments': brakePerformanceComments,
      'generalServicingComments': generalServicingComments,
      'mainDropdownValues': mainDropdownValues,
      'inspectionData': inspectionData,
      'seenOn': seenOn,
      'signedBy': signedBy,
      'tmOperator': tmOperator,
      'checkNumber': checkNumber,
      'faultDetails': faultDetails,
      'signatureOfInspector': signatureOfInspector,
      'nameOfInspector': nameOfInspector,
      'actionTakenOnFault': actionTakenOnFault,
      'rectifiedBy': rectifiedBy,
      'rectifiedSatisfactorily': rectifiedSatisfactorily,
      'needsMoreWorkDone': needsMoreWorkDone,
      'signatureOfMechanic': signatureOfMechanic,
      'date': date,
      'inspectionDate': inspectionDate?.toIso8601String(),
    };
  }
}