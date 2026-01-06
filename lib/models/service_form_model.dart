// class ServiceFormModel {
//   // Customer Information
//   String customerName = '';
//   String makeModel = '';
//   String workshopName = '';
//   String jobReference = '';
//   String crisVinNumber = '';
//   DateTime? serviceDate;

//   // Underbody
//   Map<String, String> chassisRunningGear = {
//     'Corner Steadies': '',
//     'Folding Steps': '',
//     'Under Slung Tanks & Pipes': '',
//   };
  
//   // Comments fields for each section
//   String underbodyComments = '';

//   // Electrical System
//   Map<String, String> electricalSystem = {
//     '230V consumer unit load test RCD': '',
//     'LV inlet plug & extension lead': '',
//     'Earth bonding continuity test': '',
//     '230V sockets': '',
//     'Charge voltage': '',
//     'Hob/Cooker Mains Test': '',
//     'Water Heater Mains Test': '',
//     'Room Heater Mains Test': '',
//     '230V & 12V fridge operation': '',
//     'Check all aftermarket items': '',
//     // 12V Appliances
//     '13 pin/7 pin plugs, cables & storage position': '',
//     'Road lights & reflectors': '',
//     'Leisure battery': '',
//     'Battery compartment': '',
//     'Interior lighting & equipment': '',
//     'Awning light': '',
//     'Wiring on ELV circuits': '',
//   };
  
//   String electricalSystemComments = '';

//   // Water System
//   Map<String, String> waterSystem = {
//     'Water Pump & Pressure': '',
//     'Taps, Valve, Pipes & Tank': '',
//     'Water Inlets': '',
//     'Waste System': '',
//     'Toilet': '',
//   };
  
//   String waterSystemComments = '';

//   // Bodywork
//  Map<String, String> bodywork = {
//     'Doors & Windows': '',
//     'General Roof Condition': '',
//     'External Seals': '',
//     'Floor': '',
//     'Furniture': '',
//     'Damp Test': '',
//   };
  
//   String bodyworkComments = '';

//   // Ventilation
//   Map<String, String> ventilation = {
//     'Fixed ventilation': '',
//     'Roof lights': '',
//   };
  
//   String ventilationComments = '';

//   // Fire & Safety
//   Map<String, String> fireSafety = {
//     'Press Test Button On Smoke': '',
//     'Press Test Button CO Alarm': '',
//     'If A Fire Extinguisher is Fitted': '',
//   };
  
//   String fireSafetyComments = '';

//   // LPG Gas System
//  // Gas System
//   Map<String, String> gasSystem = {
//     'Regulator, Gas Hose, Pipe..': '',
//     'Gas Tightness Check': '',
//     'Gas Dispersal Vents': '',
//     'Security Of Gas Cylinder': '',
//     'Operation of Fridge & FF': '',
//     'Operation of Hob/Cooker & FF': '',
//     'Operation of Space Heater & FF': '',
//     'Operation of Water Heater & FF': '',
//     'CO Test': '',
//   };
  
//   String gasSystemComments = '';

//   // Gas System Details
//   String gasHoseExpiry = '';
//   String regulatorAge = '';
//   String gasDetailsComments = '';

//   // Smoke/Carbon Monoxide fields
//   String smokeAlarmExpiryDate = '';
//   String carbonMonoxideAlarmExpiryDate = '';
//   String fireExtinguisherExpiryDate = '';
  
//   String tyreComments = '';

//    // Additional Information fields
//   String additionalCustomerName = '';
//   String additionalMakeModel = '';
//   String additionalVinNumber = '';
//   String additionalServiceInfo = '';
//   String additionalComments = '';

//    // Battery Info Section
//   String batteryRestVoltage = '';
//   String rcdTest1x1 = '';
//   String rcdTest5Times = '';
//   String earthBondChassis = '';
//   String continuityTestGas = '';
//   String chargerVoltage = '';
//   String gasHoseExpiryDate = '';
//   // String regulatorAge = '';
//   String comments = '';

//   // Finalization Section
//    String serviceTechnicianName = '';
//   bool eicrOffered = false;
//   String customerSignature = '';
//   String signature = '';
//   String date = '';

//   // Final Checks
//   Map<String, bool> finalChecks = {
//     'Gas turned off': false,
//     'Roof lights latched': false,
//     'Windows locked': false,
//     'All cupboards closed/latched': false,
//     'Exterior lockers locked': false,
//     'Exterior door locked': false,
//     'Lights turned off': false,
//     'Water pump turned off': false,
//     '12V/main power switch turned off': false,
//     'Old parts left in tourer': false,
//     'All protective coverings removed': false,
//     'Service book stamped': false,
//   };
// }

import 'dart:io';

class ServiceFormModel {
  // Main Information
  File? attachment;
  String workshopName = '';
  String jobReference = '';
  
  // Customer Info
  String customerName = '';
  String makeModel = '';
  String crisVinNumber = '';
  
  // Underbody/Chassis Running Gear
  Map<String, String> chassisRunningGear = {
    'Select* Corner Steadies': '',
    'Select* Folding Steps': '',
    'Select* Under Slung Tanks & Pipes': '',
  };
  String underbodyComments = '';
  
  // Electrical System
  Map<String, String> electricalSystem = {
    '230V consumer unit load test RCD': '',
    'LV inlet plug & extension lead': '',
    'Earth bonding continuity test': '',
    '230V sockets': '',
    'Charge voltage': '',
    'Hob/Cooker Mains Test': '',
    'Water Heater Mains Test': '',
    'Room Heater Mains Test': '',
    '230V & 12V fridge operation': '',
    'Check all aftermarket items': '',
    'Leisure battery condition': '',
    'Road lights & reflectors': '',
    'Fuse box & fuse rating check': '',
    'Interior lighting & equipment': '',
    'Wiring on all ELV circuits': '',
    '12V fridge operation': '',
    'Check Blower System': '',
    '12V Charger': '',
  };
  String electricalSystemComments = '';
  
  // Gas System
  Map<String, String> gasSystem = {
    'Select* Regulator, Gas Hose, Pipe..': '',
    'Select* Gas Tightness Check': '',
    'Select* Gas Dispersal Vents': '',
    'Select* Security Of Gas Cylinder': '',
    'Select* Operation of Fridge & FF': '',
    'Check* Operation of Hob/Cooker & FF': '',
    'Check* Operation of Space Heater & FF': '',
    'Check* Operation of Water Heater & FF': '',
    'Select* CO Test': '',
  };
  String gasSystemComments = '';
  
  // Water System
  Map<String, String> waterSystem = {
    'Water Pump & Pressure': '',
    'Taps, Valve, Pipes & Tank': '',
    'Water Inlets': '',
    'Waste System': '',
    'Toilet': '',
  };
  String waterSystemComments = '';
  
  // Bodywork
  Map<String, String> bodywork = {
    'Doors & Windows': '',
    'General Roof Condition': '',
    'External Seals': '',
    'Floor': '',
    'Furniture': '',
    'Damp Test': '',
  };
  String bodyworkComments = '';
  
  // Ventilation
  Map<String, String> ventilation = {
    'Select* Fixed Ventilation': '',
    'Select* Roof Lights': '',
  };
  String ventilationComments = '';
  
  // Fire & Safety
  Map<String, String> fireSafety = {
    'Press Test Button On Smoke': '',
    'Press Test Button CO Alarm': '',
    'If A Fire Extinguisher is Fitted': '',
  };
  String fireSafetyComments = '';
  
  // Smoke/Carbon Monoxide
  String smokeAlarmExpiryDate = '';
  String carbonMonoxideAlarmExpiryDate = '';
  String fireExtinguisherExpiryDate = '';
  
  // Additional Information
  String additionalCustomerName = '';
  String additionalMakeModel = '';
  String additionalVinNumber = '';
  String additionalServiceInfo = '';
  String additionalComments = '';
  
  // Battery Info Section (from screenshot)
  String batteryRestVoltage = '';
  String rcdTest1x1 = '';
  String rcdTest5Times = '';
  String earthBondChassis = '';
  String continuityTestGas = '';
  String chargerVoltage = '';
  String gasHoseExpiryDate = '';
  String regulatorAge = '';
  String comments = '';
  
  // Finalization Section (from screenshot)
  String serviceTechnicianName = '';
  bool eicrOffered = false;
  String customerSignature = '';
  String signature = '';
  String date = '';
  
  // Final Checks (if still needed)
  Map<String, bool> finalChecks = {
    'Check 1': false,
    'Check 2': false,
    'Check 3': false,
    'Check 4': false,
  };

  // Methods
  void clearAll() {
    workshopName = '';
    jobReference = '';
    customerName = '';
    makeModel = '';
    crisVinNumber = '';
    
    // Clear all map entries
    chassisRunningGear.forEach((key, value) => chassisRunningGear[key] = '');
    underbodyComments = '';
    
    electricalSystem.forEach((key, value) => electricalSystem[key] = '');
    electricalSystemComments = '';
    
    gasSystem.forEach((key, value) => gasSystem[key] = '');
    gasSystemComments = '';
    
    waterSystem.forEach((key, value) => waterSystem[key] = '');
    waterSystemComments = '';
    
    bodywork.forEach((key, value) => bodywork[key] = '');
    bodyworkComments = '';
    
    ventilation.forEach((key, value) => ventilation[key] = '');
    ventilationComments = '';
    
    fireSafety.forEach((key, value) => fireSafety[key] = '');
    fireSafetyComments = '';
    
    smokeAlarmExpiryDate = '';
    carbonMonoxideAlarmExpiryDate = '';
    fireExtinguisherExpiryDate = '';
    
    additionalCustomerName = '';
    additionalMakeModel = '';
    additionalVinNumber = '';
    additionalServiceInfo = '';
    additionalComments = '';
    
    // Battery Info
    batteryRestVoltage = '';
    rcdTest1x1 = '';
    rcdTest5Times = '';
    earthBondChassis = '';
    continuityTestGas = '';
    chargerVoltage = '';
    gasHoseExpiryDate = '';
    regulatorAge = '';
    comments = '';
    
    // Finalization
    serviceTechnicianName = '';
    eicrOffered = false;
    customerSignature = '';
    signature = '';
    date = '';
    
    // Final Checks
    finalChecks.forEach((key, value) => finalChecks[key] = false);
  }

  Map<String, dynamic> toMap() {
    return {
      // Main Information
      'workshopName': workshopName,
      'jobReference': jobReference,
      
      // Customer Info
      'customerName': customerName,
      'makeModel': makeModel,
      'crisVinNumber': crisVinNumber,
      
      // Underbody
      'chassisRunningGear': chassisRunningGear,
      'underbodyComments': underbodyComments,
      
      // Electrical System
      'electricalSystem': electricalSystem,
      'electricalSystemComments': electricalSystemComments,
      
      // Gas System
      'gasSystem': gasSystem,
      'gasSystemComments': gasSystemComments,
      
      // Water System
      'waterSystem': waterSystem,
      'waterSystemComments': waterSystemComments,
      
      // Bodywork
      'bodywork': bodywork,
      'bodyworkComments': bodyworkComments,
      
      // Ventilation
      'ventilation': ventilation,
      'ventilationComments': ventilationComments,
      
      // Fire & Safety
      'fireSafety': fireSafety,
      'fireSafetyComments': fireSafetyComments,
      
      // Smoke/Carbon Monoxide
      'smokeAlarmExpiryDate': smokeAlarmExpiryDate,
      'carbonMonoxideAlarmExpiryDate': carbonMonoxideAlarmExpiryDate,
      'fireExtinguisherExpiryDate': fireExtinguisherExpiryDate,
      
      // Additional Information
      'additionalCustomerName': additionalCustomerName,
      'additionalMakeModel': additionalMakeModel,
      'additionalVinNumber': additionalVinNumber,
      'additionalServiceInfo': additionalServiceInfo,
      'additionalComments': additionalComments,
      
      // Battery Info
      'batteryRestVoltage': batteryRestVoltage,
      'rcdTest1x1': rcdTest1x1,
      'rcdTest5Times': rcdTest5Times,
      'earthBondChassis': earthBondChassis,
      'continuityTestGas': continuityTestGas,
      'chargerVoltage': chargerVoltage,
      'gasHoseExpiryDate': gasHoseExpiryDate,
      'regulatorAge': regulatorAge,
      'comments': comments,
      
      // Finalization
      'serviceTechnicianName': serviceTechnicianName,
      'eicrOffered': eicrOffered,
      'customerSignature': customerSignature,
      'signature': signature,
      'date': date,
      
      // Final Checks
      'finalChecks': finalChecks,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    workshopName = map['workshopName']?.toString() ?? '';
    jobReference = map['jobReference']?.toString() ?? '';
    
    customerName = map['customerName']?.toString() ?? '';
    makeModel = map['makeModel']?.toString() ?? '';
    crisVinNumber = map['crisVinNumber']?.toString() ?? '';
    
    if (map['chassisRunningGear'] != null) {
      Map<String, dynamic> chassisMap = Map<String, dynamic>.from(map['chassisRunningGear']);
      chassisRunningGear = chassisMap.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }
    underbodyComments = map['underbodyComments']?.toString() ?? '';
    
    if (map['electricalSystem'] != null) {
      Map<String, dynamic> electricalMap = Map<String, dynamic>.from(map['electricalSystem']);
      electricalSystem = electricalMap.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }
    electricalSystemComments = map['electricalSystemComments']?.toString() ?? '';
    
    if (map['gasSystem'] != null) {
      Map<String, dynamic> gasMap = Map<String, dynamic>.from(map['gasSystem']);
      gasSystem = gasMap.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }
    gasSystemComments = map['gasSystemComments']?.toString() ?? '';
    
    if (map['waterSystem'] != null) {
      Map<String, dynamic> waterMap = Map<String, dynamic>.from(map['waterSystem']);
      waterSystem = waterMap.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }
    waterSystemComments = map['waterSystemComments']?.toString() ?? '';
    
    if (map['bodywork'] != null) {
      Map<String, dynamic> bodyworkMap = Map<String, dynamic>.from(map['bodywork']);
      bodywork = bodyworkMap.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }
    bodyworkComments = map['bodyworkComments']?.toString() ?? '';
    
    if (map['ventilation'] != null) {
      Map<String, dynamic> ventilationMap = Map<String, dynamic>.from(map['ventilation']);
      ventilation = ventilationMap.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }
    ventilationComments = map['ventilationComments']?.toString() ?? '';
    
    if (map['fireSafety'] != null) {
      Map<String, dynamic> fireSafetyMap = Map<String, dynamic>.from(map['fireSafety']);
      fireSafety = fireSafetyMap.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }
    fireSafetyComments = map['fireSafetyComments']?.toString() ?? '';
    
    smokeAlarmExpiryDate = map['smokeAlarmExpiryDate']?.toString() ?? '';
    carbonMonoxideAlarmExpiryDate = map['carbonMonoxideAlarmExpiryDate']?.toString() ?? '';
    fireExtinguisherExpiryDate = map['fireExtinguisherExpiryDate']?.toString() ?? '';
    
    additionalCustomerName = map['additionalCustomerName']?.toString() ?? '';
    additionalMakeModel = map['additionalMakeModel']?.toString() ?? '';
    additionalVinNumber = map['additionalVinNumber']?.toString() ?? '';
    additionalServiceInfo = map['additionalServiceInfo']?.toString() ?? '';
    additionalComments = map['additionalComments']?.toString() ?? '';
    
    // Battery Info
    batteryRestVoltage = map['batteryRestVoltage']?.toString() ?? '';
    rcdTest1x1 = map['rcdTest1x1']?.toString() ?? '';
    rcdTest5Times = map['rcdTest5Times']?.toString() ?? '';
    earthBondChassis = map['earthBondChassis']?.toString() ?? '';
    continuityTestGas = map['continuityTestGas']?.toString() ?? '';
    chargerVoltage = map['chargerVoltage']?.toString() ?? '';
    gasHoseExpiryDate = map['gasHoseExpiryDate']?.toString() ?? '';
    regulatorAge = map['regulatorAge']?.toString() ?? '';
    comments = map['comments']?.toString() ?? '';
    
    // Finalization
    serviceTechnicianName = map['serviceTechnicianName']?.toString() ?? '';
    eicrOffered = map['eicrOffered'] as bool? ?? false;
    customerSignature = map['customerSignature']?.toString() ?? '';
    signature = map['signature']?.toString() ?? '';
    date = map['date']?.toString() ?? '';
    
    if (map['finalChecks'] != null) {
      Map<String, dynamic> checksMap = Map<String, dynamic>.from(map['finalChecks']);
      finalChecks = checksMap.map((key, value) => MapEntry(key, value as bool? ?? false));
    }
  }
}