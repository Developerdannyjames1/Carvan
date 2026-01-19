// full_service_list_model.dart
import 'dart:typed_data';

class FullServiceListModel {
  // Step 0: Main Information
  String workshopName = '';
  String jobReference = '';
  List<Uint8List> uploadedImages = [];

  // Add comment fields for each section
  String vehicleOnFloorComments = '';
  String vehicleRaisedComments = '';
  String vehicleFullyRaisedComments = '';
  String vehicleHalfRaisedComments = '';
  String underBonetOperationsComments = '';
  String finalItemsChecksComments = '';
   String finalizationComments = '';

  // Step 1: Customer Information
  String customerName = '';
  String makeModel = '';
  String registrationNumber = '';
  String crisVinNumber = '';

  // Step 2: Service Checklist
  Map<String, bool> serviceChecklist = {
    'Fit Protective Covers': false,
    'Instruments': false,
    'Switches': false,
    'Horn': false,
  };
  
  // Status for dropdowns (O.K, Advisory, Need Attention)
  Map<String, String?> serviceStatus = {
    'Instruments': null,
    'Switches': null,
    'Horn': null,
  };
  
  String serviceNotes = '';

  // Step 3: Safety Checks
  Map<String, bool> safetyChecks = {
    'Oil Leaks': false,
    'Engine Oil': false,
    'Engine Oil Filter': false,
    'Gear Oil': false,
  };
  
  Map<String, String?> safetyStatus = {
    'Oil Leaks': null,
    'Gear Oil': null,
  };
  
  String safetyNotes = '';

  // Step 4: Habitation Area Check
  Map<String, bool> habitationChecks = {
    'Oil Leaks': false,
    'Engine Oil': false,
    'Engine Oil Filter': false,
    'Gear Oil': false,
  };
  
  Map<String, String?> habitationStatus = {
    'Oil Leaks': null,
    'Gear Oil': null,
  };
  
  String habitationNotes = '';

  // Step 5: Electrical System
  Map<String, bool> electricalChecks = {
    'Front Brake': false,
    'Rear Brake': false,
    'Drum Shoes': false,
    'Wheel Bearing': false,
  };
  
  Map<String, String?> electricalStatus = {
    'Front Brake': null,
    'Rear Brake': null,
    'Drum Shoes': null,
    'Wheel Bearing': null,
  };
  
  String electricalNotes = '';

  // Step 6: Water & Gas Systems
  Map<String, bool> waterGasChecks = {
    'Spark Plugs': false,
    'Drive Belts': false,
    'Air Filters': false,
    'Pollen Filter': false,
  };
  
  Map<String, String?> waterGasStatus = {
    'Spark Plugs': null,
    'Drive Belts': null,
  };
  
  String waterGasNotes = '';

  // Step 7: Final Items Checks
  Map<String, bool> finalItemsChecks = {
    'Reset Fault': false,
    'Vehicle Locks': false,
    'Road Wheels': false,
    'Service Lights': false,
    'Road Tests': false,
  };
  
  Map<String, String?> finalItemsStatus = {
    'Reset Fault': null,
    'Vehicle Locks': null,
    'Road Wheels': null,
    'Service Lights': null,
    'Road Tests': null,
  };
  
  String finalItemsNotes = '';

  // Step 8: Finalization
  String technicianName = '';
  String technicianSignature = '';
  String finalizationNotes = '';
  
  // Additional photo storage
  List<Uint8List> additionalPhotos = [];

  Map<String, dynamic> toJson() {
    return {
      'workshopName': workshopName,
      'jobReference': jobReference,
      'customerName': customerName,
      'makeModel': makeModel,
      'registrationNumber': registrationNumber,
      'crisVinNumber': crisVinNumber,
      'serviceChecklist': serviceChecklist,
      'serviceStatus': serviceStatus,
      'serviceNotes': serviceNotes,
      'safetyChecks': safetyChecks,
      'safetyStatus': safetyStatus,
      'safetyNotes': safetyNotes,
      'habitationChecks': habitationChecks,
      'habitationStatus': habitationStatus,
      'habitationNotes': habitationNotes,
      'electricalChecks': electricalChecks,
      'electricalStatus': electricalStatus,
      'electricalNotes': electricalNotes,
      'waterGasChecks': waterGasChecks,
      'waterGasStatus': waterGasStatus,
      'waterGasNotes': waterGasNotes,
      'finalItemsChecks': finalItemsChecks,
      'finalItemsStatus': finalItemsStatus,
      'finalItemsNotes': finalItemsNotes,
      'technicianName': technicianName,
      'technicianSignature': technicianSignature,
      'finalizationNotes': finalizationNotes,
      'uploadedImages': uploadedImages.length,
      'additionalPhotos': additionalPhotos.length,
    };
  }
}