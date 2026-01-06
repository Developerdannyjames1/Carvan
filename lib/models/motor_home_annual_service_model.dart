import 'dart:typed_data';

class MotorHomeAnnualServiceModel {
  String vehicleRegistration = '';
  String mileage = '';          // Odometer Reading
  String makeModel = '';        // Make & Type
  String dateOfInspection = ''; // Date Of Inspection (renamed from workshopName)
  String operator = '';         // Operator (renamed from jobReference)
  
  // Photo Sections Data
  Map<String, Map<String, dynamic>> photoData = {
    'Front': {
      'attachedFile': null,
      'attachedFileBytes': null,
      'comments': ''
    },
    'Rear': {
      'attachedFile': null,
      'attachedFileBytes': null,
      'comments': ''
    },
    'Nearside': {
      'attachedFile': null,
      'attachedFileBytes': null,
      'comments': ''
    },
    'Offside': {
      'attachedFile': null,
      'attachedFileBytes': null,
      'comments': ''
    },
  };

  // Final Attachments
  List<String> finalAttachments = [];
  List<Uint8List?> finalAttachmentBytes = [];
  String finalComments = '';

  MotorHomeAnnualServiceModel();

  Map<String, dynamic> toJson() {
    return {
      // Form fields (only 5)
      'vehicleRegistration': vehicleRegistration,
      'mileage': mileage,
      'makeModel': makeModel,
      'dateOfInspection': dateOfInspection,
      'operator': operator,
      
      'photoData': photoData,
      'finalAttachments': finalAttachments,
      'finalComments': finalComments,
    };
  }
}