// engine_vehicle_model.dart
import 'dart:typed_data';

class EngineVehicleModel {
  // Customer Information
  String customerName = '';
  String vehicleRegistration = '';
  String mileage = '';
  String dateOfInspection = '';
  String comments = '';

  // Store MAIN dropdown values for each category (direct user selection)
  Map<String, String> mainDropdownValues = {};
  
  // Detailed mini service data (items within each category from action button)
  Map<String, Map<String, String>> miniServiceData = {};

  // Images
  List<Uint8List> uploadedImages = [];

  // Constructor
  EngineVehicleModel();

  // Helper method to add mini service data (action button items)
  void addMiniServiceData(String category, Map<String, String> selections) {
    miniServiceData[category] = selections;
  }

  // Helper method to set MAIN dropdown value (direct selection)
  void setMainDropdownValue(String category, String value) {
    mainDropdownValues[category] = value;
  }

  // Add method to get all data as JSON
  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'vehicleRegistration': vehicleRegistration,
      'mileage': mileage,
      'dateOfInspection': dateOfInspection,
      'mainDropdownValues': mainDropdownValues,
      'miniServiceData': miniServiceData,
      'comments': comments,
      'imageCount': uploadedImages.length,
    };
  }
}