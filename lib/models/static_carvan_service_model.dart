import 'dart:io';

class StaticCarvanServiceModel {
  // Main Information
  File? attachment;
  String workshopName = '';
  String jobReference = '';
  
  // Customer Info
  String customerName = '';
  String makeModel = '';
  // String crisVinNumber = '';
  String workShopName = '';
  String address = '';
  
  // Underbody/Chassis Running Gear
  Map<String, String> chassisRunningGear = {
    'Select* Corner Steadies': '',
    'Select* Under Slung Pipes': '',
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
    'Rising Roof': '',
  };
  String bodyworkComments = '';
  File? bodyworkAttachment; 
  
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
 String smokeCOAlarmComments = '';
  
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
}