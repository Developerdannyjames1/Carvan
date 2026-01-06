import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class TourerDampModel {
  // Step 0: Main Information
  String workshopName = '';
  String jobReference = '';
  List<Uint8List> uploadedImages = [];

    Uint8List? logoImageBytes;
  String? logoFileName;

  // Step 1: Customer Information
  String customerName = '';
  String makeModel = '';
  String registrationNumber = '';
  String crisVinNumber = '';

  // Step 2: Damp Readings
  String commentsRecommendations = '';
  
  // Steps 3-8: Photo sections (Motorhome-style)
  Map<String, Map<String, dynamic>> photoData = {
    'Front': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
    'Rear': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
    'Nearside': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
    'Offside': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
    'Ceiling': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
    'Floor': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
  };

  // Step 9: Finalization fields
  String dampMeterCalibration = '';
  String weatherConditions = '';
  String ambientTemperature = '';
  String dampMeterMakeModel = '';
  String serviceTechnicianName = '';
  String technicianSignatureText = '';
  String customerSignatureText = '';
  DateTime? date;

  // Section arrays for storage
  List<XFile?> sectionImages = [];
  List<Uint8List?> sectionImageBytes = [];
  List<String> sectionComments = [];

  Map<String, dynamic> toJson() {
    return {
      'workshopName': workshopName,
      'jobReference': jobReference,
      'customerName': customerName,
      'makeModel': makeModel,
      'registrationNumber': registrationNumber,
      'crisVinNumber': crisVinNumber,
      'commentsRecommendations': commentsRecommendations,
      'photoData': photoData,
      'dampMeterCalibration': dampMeterCalibration,
      'weatherConditions': weatherConditions,
      'ambientTemperature': ambientTemperature,
      'dampMeterMakeModel': dampMeterMakeModel,
      'serviceTechnicianName': serviceTechnicianName,
      'technicianSignature': technicianSignatureText,
      'customerSignature': customerSignatureText,
      'date': date?.toIso8601String(),
      'sectionComments': sectionComments,
    };
  }
}