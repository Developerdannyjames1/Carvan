import 'dart:io';
import 'dart:typed_data';
import 'package:data/models/service_form_model.dart';
import 'package:data/services/pdf_export_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';

class StepController extends GetxController {
  var currentStep = 0.obs;
  var stepStatus = <int, String>{}.obs; // Track step status
  var isViewingFromSummary = false.obs; // Track if viewing from summary

  void nextStep() {
    if (currentStep.value < 12) { // 13 steps total (0-12)
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 13) { // Allow step 13 for summary
      currentStep.value = step;
    }
  }

  void markStepAsFilled(int step) {
    stepStatus[step] = "Filled";
  }

  void markStepAsSkipped(int step) {
    stepStatus[step] = "Skipped";
  }

  String getStepStatus(int step) {
    return stepStatus[step] ?? "Not Started";
  }

  void setViewingFromSummary(bool value) {
    isViewingFromSummary.value = value;
  }
}

class MainFormScreen extends StatefulWidget {
  @override
  _MainFormScreenState createState() => _MainFormScreenState();
}

class _MainFormScreenState extends State<MainFormScreen> {
  final ServiceFormModel formData = ServiceFormModel();
  final List<String> statusOptions = ['P', 'F', 'N/A', 'R'];
  final StepController stepController = Get.put(StepController());

  // Image handling variables
  File? _selectedImage;
  Uint8List? _imageBytes;
  bool _isUploading = false;

  // Text editing controllers for all text fields
  // Main Information (Step 0)
  late TextEditingController mainWorkshopNameController;
  late TextEditingController mainJobReferenceController;
  
  // Customer Info (Step 1)
  late TextEditingController customerNameController;
  late TextEditingController makeModelController;
  late TextEditingController workshopNameController;
  late TextEditingController jobReferenceController;
  late TextEditingController crisVinNumberController;
  
  // Comments fields (Steps 2-8)
  late TextEditingController underbodyCommentsController;
  late TextEditingController electricalSystemCommentsController;
  late TextEditingController gasSystemCommentsController;
  late TextEditingController waterSystemCommentsController;
  late TextEditingController bodyworkCommentsController;
  late TextEditingController ventilationCommentsController;
  late TextEditingController fireSafetyCommentsController;
  
  // Smoke/CO Alarms (Step 9)
  late TextEditingController smokeAlarmExpiryDateController;
  late TextEditingController carbonMonoxideAlarmExpiryDateController;
  late TextEditingController fireExtinguisherExpiryDateController;
  
  // Additional Information (Step 10)
  late TextEditingController additionalCustomerNameController;
  late TextEditingController additionalMakeModelController;
  late TextEditingController additionalVinNumberController;
  late TextEditingController additionalServiceInfoController;
  late TextEditingController additionalCommentsController;
  
  // Battery Info (Step 11)
  late TextEditingController batteryRestVoltageController;
  late TextEditingController rcdTest1x1Controller;
  late TextEditingController rcdTest5TimesController;
  late TextEditingController earthBondChassisController;
  late TextEditingController continuityTestGasController;
  late TextEditingController chargerVoltageController;
  late TextEditingController gasHoseExpiryDateController;
  late TextEditingController regulatorAgeController;
  late TextEditingController batteryCommentsController;
  
  // Finalization (Step 12)
  late TextEditingController serviceTechnicianNameController;
  late TextEditingController customerSignatureController;
  late TextEditingController signatureController;
  late TextEditingController dateController;

  final List<String> stepTitles = [
    'Main Information',
    'Customer Info',
    'Underbody',
    'Electrical System',
    'Gas System',
    'Water System',
    'Bodywork',
    'Ventilation',
    'Fire & Safety',
    'Smoke/CO Alarms',
    'Additional Information',
    'Battery Info',
    'Finalization',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize all steps as "Skipped" by default
    for (int i = 0; i < stepTitles.length; i++) {
      stepController.markStepAsSkipped(i);
    }
    
    // Initialize text controllers with formData values
    // Main Information (Step 0)
    mainWorkshopNameController = TextEditingController(text: formData.workshopName);
    mainJobReferenceController = TextEditingController(text: formData.jobReference);
    
    // Customer Info (Step 1)
    customerNameController = TextEditingController(text: formData.customerName);
    makeModelController = TextEditingController(text: formData.makeModel);
    workshopNameController = TextEditingController(text: '');
    jobReferenceController = TextEditingController(text: '');
    crisVinNumberController = TextEditingController(text: formData.crisVinNumber);
    
    // Comments fields
    underbodyCommentsController = TextEditingController(text: formData.underbodyComments);
    electricalSystemCommentsController = TextEditingController(text: formData.electricalSystemComments);
    gasSystemCommentsController = TextEditingController(text: formData.gasSystemComments);
    waterSystemCommentsController = TextEditingController(text: formData.waterSystemComments);
    bodyworkCommentsController = TextEditingController(text: formData.bodyworkComments);
    ventilationCommentsController = TextEditingController(text: formData.ventilationComments);
    fireSafetyCommentsController = TextEditingController(text: formData.fireSafetyComments);
    
    // Smoke/CO Alarms
    smokeAlarmExpiryDateController = TextEditingController(text: formData.smokeAlarmExpiryDate);
    carbonMonoxideAlarmExpiryDateController = TextEditingController(text: formData.carbonMonoxideAlarmExpiryDate);
    fireExtinguisherExpiryDateController = TextEditingController(text: formData.fireExtinguisherExpiryDate);
    
    // Additional Information
    additionalCustomerNameController = TextEditingController(text: formData.additionalCustomerName);
    additionalMakeModelController = TextEditingController(text: formData.additionalMakeModel);
    additionalVinNumberController = TextEditingController(text: formData.additionalVinNumber);
    additionalServiceInfoController = TextEditingController(text: formData.additionalServiceInfo);
    additionalCommentsController = TextEditingController(text: formData.additionalComments);
    
    // Battery Info
    batteryRestVoltageController = TextEditingController(text: formData.batteryRestVoltage);
    rcdTest1x1Controller = TextEditingController(text: formData.rcdTest1x1);
    rcdTest5TimesController = TextEditingController(text: formData.rcdTest5Times);
    earthBondChassisController = TextEditingController(text: formData.earthBondChassis);
    continuityTestGasController = TextEditingController(text: formData.continuityTestGas);
    chargerVoltageController = TextEditingController(text: formData.chargerVoltage);
    gasHoseExpiryDateController = TextEditingController(text: formData.gasHoseExpiryDate);
    regulatorAgeController = TextEditingController(text: formData.regulatorAge);
    batteryCommentsController = TextEditingController(text: formData.comments);
    
    // // Finalization
    // serviceTechnicianNameController = TextEditingController(text: formData.serviceTechnicianName);
    // customerSignatureController = TextEditingController(text: formData.customerSignature);
    // signatureController = TextEditingController(text: formData.signature);
    // dateController = TextEditingController(text: formData.date);

      // Finalization - Update date controller initialization
  serviceTechnicianNameController = TextEditingController(text: formData.serviceTechnicianName);
  customerSignatureController = TextEditingController(text: formData.customerSignature);
  signatureController = TextEditingController(text: formData.signature);
  dateController = TextEditingController(text: formData.date ?? '');
    
    // Add listeners to update formData when text changes
    // Main Information (Step 0)
    mainWorkshopNameController.addListener(() => formData.workshopName = mainWorkshopNameController.text);
    mainJobReferenceController.addListener(() => formData.jobReference = mainJobReferenceController.text);
    
    // Customer Info (Step 1) - these fields don't update formData.workshopName/jobReference
    // They are separate fields for Customer Info section only
    customerNameController.addListener(() => formData.customerName = customerNameController.text);
    makeModelController.addListener(() => formData.makeModel = makeModelController.text);
    workshopNameController.addListener(() {
      // This is a separate field in Customer Info - don't update formData.workshopName
      // If you want to store this separately, you'd need a new field in the model
    });
    jobReferenceController.addListener(() {
      // This is a separate field in Customer Info - don't update formData.jobReference
      // If you want to store this separately, you'd need a new field in the model
    });
    crisVinNumberController.addListener(() => formData.crisVinNumber = crisVinNumberController.text);
    
    underbodyCommentsController.addListener(() => formData.underbodyComments = underbodyCommentsController.text);
    electricalSystemCommentsController.addListener(() => formData.electricalSystemComments = electricalSystemCommentsController.text);
    gasSystemCommentsController.addListener(() => formData.gasSystemComments = gasSystemCommentsController.text);
    waterSystemCommentsController.addListener(() => formData.waterSystemComments = waterSystemCommentsController.text);
    bodyworkCommentsController.addListener(() => formData.bodyworkComments = bodyworkCommentsController.text);
    ventilationCommentsController.addListener(() => formData.ventilationComments = ventilationCommentsController.text);
    fireSafetyCommentsController.addListener(() => formData.fireSafetyComments = fireSafetyCommentsController.text);
    
    smokeAlarmExpiryDateController.addListener(() => formData.smokeAlarmExpiryDate = smokeAlarmExpiryDateController.text);
    carbonMonoxideAlarmExpiryDateController.addListener(() => formData.carbonMonoxideAlarmExpiryDate = carbonMonoxideAlarmExpiryDateController.text);
    fireExtinguisherExpiryDateController.addListener(() => formData.fireExtinguisherExpiryDate = fireExtinguisherExpiryDateController.text);
    
    additionalCustomerNameController.addListener(() => formData.additionalCustomerName = additionalCustomerNameController.text);
    additionalMakeModelController.addListener(() => formData.additionalMakeModel = additionalMakeModelController.text);
    additionalVinNumberController.addListener(() => formData.additionalVinNumber = additionalVinNumberController.text);
    additionalServiceInfoController.addListener(() => formData.additionalServiceInfo = additionalServiceInfoController.text);
    additionalCommentsController.addListener(() => formData.additionalComments = additionalCommentsController.text);
    
    batteryRestVoltageController.addListener(() => formData.batteryRestVoltage = batteryRestVoltageController.text);
    rcdTest1x1Controller.addListener(() => formData.rcdTest1x1 = rcdTest1x1Controller.text);
    rcdTest5TimesController.addListener(() => formData.rcdTest5Times = rcdTest5TimesController.text);
    earthBondChassisController.addListener(() => formData.earthBondChassis = earthBondChassisController.text);
    continuityTestGasController.addListener(() => formData.continuityTestGas = continuityTestGasController.text);
    chargerVoltageController.addListener(() => formData.chargerVoltage = chargerVoltageController.text);
    gasHoseExpiryDateController.addListener(() => formData.gasHoseExpiryDate = gasHoseExpiryDateController.text);
    regulatorAgeController.addListener(() => formData.regulatorAge = regulatorAgeController.text);
    batteryCommentsController.addListener(() => formData.comments = batteryCommentsController.text);
    
    serviceTechnicianNameController.addListener(() => formData.serviceTechnicianName = serviceTechnicianNameController.text);
    customerSignatureController.addListener(() => formData.customerSignature = customerSignatureController.text);
    signatureController.addListener(() => formData.signature = signatureController.text);
    dateController.addListener(() => formData.date = dateController.text);
  }

  @override
  void dispose() {
    // Dispose all controllers
    // Main Information (Step 0)
    mainWorkshopNameController.dispose();
    mainJobReferenceController.dispose();
    
    // Customer Info (Step 1)
    customerNameController.dispose();
    makeModelController.dispose();
    workshopNameController.dispose();
    jobReferenceController.dispose();
    crisVinNumberController.dispose();
    underbodyCommentsController.dispose();
    electricalSystemCommentsController.dispose();
    gasSystemCommentsController.dispose();
    waterSystemCommentsController.dispose();
    bodyworkCommentsController.dispose();
    ventilationCommentsController.dispose();
    fireSafetyCommentsController.dispose();
    smokeAlarmExpiryDateController.dispose();
    carbonMonoxideAlarmExpiryDateController.dispose();
    fireExtinguisherExpiryDateController.dispose();
    additionalCustomerNameController.dispose();
    additionalMakeModelController.dispose();
    additionalVinNumberController.dispose();
    additionalServiceInfoController.dispose();
    additionalCommentsController.dispose();
    batteryRestVoltageController.dispose();
    rcdTest1x1Controller.dispose();
    rcdTest5TimesController.dispose();
    earthBondChassisController.dispose();
    continuityTestGasController.dispose();
    chargerVoltageController.dispose();
    gasHoseExpiryDateController.dispose();
    regulatorAgeController.dispose();
    batteryCommentsController.dispose();
    serviceTechnicianNameController.dispose();
    customerSignatureController.dispose();
    signatureController.dispose();
    dateController.dispose();
    super.dispose();
  }

  // Image picker method
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (image != null) {
        setState(() {
          _isUploading = true;
        });

        final File imageFile = File(image.path);
        final Uint8List bytes = await imageFile.readAsBytes();

        setState(() {
          _selectedImage = imageFile;
          _imageBytes = bytes;
          _isUploading = false;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Remove image method
  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageBytes = null;
    });
  }

  // Updated PDF export method
  void _exportToPdf() async {
    try {
      setState(() {
        _isUploading = true;
      });

      final pdfBytes = await PdfExportService.generatePdf(
        formData,
        logoImageBytes: _imageBytes,
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'motorhome-annual-habitation-service.pdf',
      );

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error generating PDF: $e');
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Show 240V Appliances Dialog
  void _show240VAppliancesDialog(BuildContext context, bool isSmallScreen) {
    Map<String, String> tempSelections = {};
    
    // Initialize temp selections with current data
    tempSelections['230V consumer unit load test RCD'] = 
        formData.electricalSystem['230V consumer unit load test RCD'] ?? '';
    tempSelections['LV inlet plug & extension lead'] = 
        formData.electricalSystem['LV inlet plug & extension lead'] ?? '';
    tempSelections['Earth bonding continuity test'] = 
        formData.electricalSystem['Earth bonding continuity test'] ?? '';
    tempSelections['230V sockets'] = 
        formData.electricalSystem['230V sockets'] ?? '';
    tempSelections['Charge voltage'] = 
        formData.electricalSystem['Charge voltage'] ?? '';
    tempSelections['Hob/Cooker Mains Test'] = 
        formData.electricalSystem['Hob/Cooker Mains Test'] ?? '';
    tempSelections['Water Heater Mains Test'] = 
        formData.electricalSystem['Water Heater Mains Test'] ?? '';
    tempSelections['Room Heater Mains Test'] = 
        formData.electricalSystem['Room Heater Mains Test'] ?? '';
    tempSelections['230V & 12V fridge operation'] = 
        formData.electricalSystem['230V & 12V fridge operation'] ?? '';
    tempSelections['Check all aftermarket items'] = 
        formData.electricalSystem['Check all aftermarket items'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "240 V Appliances",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "PolySans",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const SizedBox(height: 15),

                    // 230V RCD Load Test
                    _buildDialogDropdownField(
                      label: 'Select* 230V RCD Load Test',
                      value: tempSelections['230V consumer unit load test RCD']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['230V consumer unit load test RCD'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // LV inlet plug & extension lead
                    _buildDialogDropdownField(
                      label: 'Select* LV inlet plug & extension lead',
                      value: tempSelections['LV inlet plug & extension lead']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['LV inlet plug & extension lead'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Earth bonding continuity test
                    _buildDialogDropdownField(
                      label: 'Select* Earth bonding continuity test',
                      value: tempSelections['Earth bonding continuity test']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Earth bonding continuity test'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // 230V sockets
                    _buildDialogDropdownField(
                      label: 'Select* 230V sockets',
                      value: tempSelections['230V sockets']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['230V sockets'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 20),

                    // 240 V Charger
                    _buildDialogDropdownField(
                      label: 'Select* 240 V Charger',
                      value: tempSelections['Charge voltage']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Charge voltage'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Hob/Cooker Mains Test
                    _buildDialogDropdownField(
                      label: 'Select* Hob/Cooker Mains Test',
                      value: tempSelections['Hob/Cooker Mains Test']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Hob/Cooker Mains Test'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Water Heater Mains Test
                    _buildDialogDropdownField(
                      label: 'Select* Water Heater Mains Test',
                      value: tempSelections['Water Heater Mains Test']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Water Heater Mains Test'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Room Heater Mains Test
                    _buildDialogDropdownField(
                      label: 'Select* Room Heater Mains Test',
                      value: tempSelections['Room Heater Mains Test']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Room Heater Mains Test'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // 230V fridge operation
                    _buildDialogDropdownField(
                      label: 'Select* 230V fridge operation',
                      value: tempSelections['230V & 12V fridge operation']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['230V & 12V fridge operation'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 20),

                    // Aftermarket Items
                    _buildDialogDropdownField(
                      label: 'Select* Aftermarket Items',
                      value: tempSelections['Check all aftermarket items']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Check all aftermarket items'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Save all selections back to formData
                            formData.electricalSystem['230V consumer unit load test RCD'] = 
                                tempSelections['230V consumer unit load test RCD']!;
                            formData.electricalSystem['LV inlet plug & extension lead'] = 
                                tempSelections['LV inlet plug & extension lead']!;
                            formData.electricalSystem['Earth bonding continuity test'] = 
                                tempSelections['Earth bonding continuity test']!;
                            formData.electricalSystem['230V sockets'] = 
                                tempSelections['230V sockets']!;
                            formData.electricalSystem['Charge voltage'] = 
                                tempSelections['Charge voltage']!;
                            formData.electricalSystem['Hob/Cooker Mains Test'] = 
                                tempSelections['Hob/Cooker Mains Test']!;
                            formData.electricalSystem['Water Heater Mains Test'] = 
                                tempSelections['Water Heater Mains Test']!;
                            formData.electricalSystem['Room Heater Mains Test'] = 
                                tempSelections['Room Heater Mains Test']!;
                            formData.electricalSystem['230V & 12V fridge operation'] = 
                                tempSelections['230V & 12V fridge operation']!;
                            formData.electricalSystem['Check all aftermarket items'] = 
                                tempSelections['Check all aftermarket items']!;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff173EA6),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontFamily: "PolySans",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show 12V Appliances Dialog
  void _show12VAppliancesDialog(BuildContext context, bool isSmallScreen) {
    Map<String, String> tempSelections = {};
    
    // Initialize temp selections with current data
    tempSelections['Leisure battery condition'] = 
        formData.electricalSystem['Leisure battery condition'] ?? '';
    tempSelections['Road lights & reflectors'] = 
        formData.electricalSystem['Road lights & reflectors'] ?? '';
    tempSelections['Fuse box & fuse rating check'] = 
        formData.electricalSystem['Fuse box & fuse rating check'] ?? '';
    tempSelections['Interior lighting & equipment'] = 
        formData.electricalSystem['Interior lighting & equipment'] ?? '';
    tempSelections['Wiring on all ELV circuits'] = 
        formData.electricalSystem['Wiring on all ELV circuits'] ?? '';
    tempSelections['12V fridge operation'] = 
        formData.electricalSystem['12V fridge operation'] ?? '';
    tempSelections['Check Blower System'] = 
        formData.electricalSystem['Check Blower System'] ?? '';
    tempSelections['12V Charger'] = 
        formData.electricalSystem['12V Charger'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "12 V Appliances",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "PolySans",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const SizedBox(height: 15),

                    // Leisure battery condition
                    _buildDialogDropdownField(
                      label: 'Select* Leisure battery condition',
                      value: tempSelections['Leisure battery condition']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Leisure battery condition'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Road lights & reflectors
                    _buildDialogDropdownField(
                      label: 'Select* Road lights & reflectors',
                      value: tempSelections['Road lights & reflectors']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Road lights & reflectors'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Fuse box & fuse rating check
                    _buildDialogDropdownField(
                      label: 'Select* Fuse box & fuse rating check',
                      value: tempSelections['Fuse box & fuse rating check']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Fuse box & fuse rating check'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Interior lighting & equipment
                    _buildDialogDropdownField(
                      label: 'Select* Interior lighting & equipment',
                      value: tempSelections['Interior lighting & equipment']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Interior lighting & equipment'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Wiring on all ELV circuits
                    _buildDialogDropdownField(
                      label: 'Select* Wiring on all ELV circuits',
                      value: tempSelections['Wiring on all ELV circuits']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Wiring on all ELV circuits'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // 12V fridge operation
                    _buildDialogDropdownField(
                      label: 'Select* 12V fridge operation',
                      value: tempSelections['12V fridge operation']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['12V fridge operation'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 12),

                    // Check Blower System
                    _buildDialogDropdownField(
                      label: 'Select* Check Blower System',
                      value: tempSelections['Check Blower System']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['Check Blower System'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),

                    const SizedBox(height: 12),

                    // 12V Charger
                    _buildDialogDropdownField(
                      label: 'Select* 12V Charger',
                      value: tempSelections['12V Charger']!,
                      onChanged: (newValue) {
                        setModalState(() {
                          tempSelections['12V Charger'] = newValue!;
                        });
                      },
                      isSmallScreen: isSmallScreen,
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Save all selections back to formData
                            formData.electricalSystem['Leisure battery condition'] = 
                                tempSelections['Leisure battery condition']!;
                            formData.electricalSystem['Road lights & reflectors'] = 
                                tempSelections['Road lights & reflectors']!;
                            formData.electricalSystem['Fuse box & fuse rating check'] = 
                                tempSelections['Fuse box & fuse rating check']!;
                            formData.electricalSystem['Interior lighting & equipment'] = 
                                tempSelections['Interior lighting & equipment']!;
                            formData.electricalSystem['Wiring on all ELV circuits'] = 
                                tempSelections['Wiring on all ELV circuits']!;
                            formData.electricalSystem['12V fridge operation'] = 
                                tempSelections['12V fridge operation']!;
                            formData.electricalSystem['Check Blower System'] = 
                                tempSelections['Check Blower System']!;
                            formData.electricalSystem['12V Charger'] = 
                                tempSelections['12V Charger']!;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff173EA6),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontFamily: "PolySans",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Build Dialog Dropdown Field
  Widget _buildDialogDropdownField({
    required String label,
    required String value,
    required Function(String?) onChanged,
    required bool isSmallScreen,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: "PolySans",
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              alignment: Alignment.center,
              isExpanded: true,
              items: statusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: "PolySans",
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isSmallScreen = width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                // In the build method, replace the IconButton with this:

IconButton(
  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
  onPressed: () {
    // Always show exit confirmation to go back to home screen
    _showExitConfirmation();
  },
),
                  const Spacer(),
                  Container(
                    width: isSmallScreen ? 170 : 220,
                    height: isSmallScreen ? 70 : 80,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Expanded(child: Container(height: 1, color: Colors.black)),
                    const SizedBox(width: 10),
                    Text(
                      stepController.currentStep.value == 13
                          ? '(SUMMARY)'
                          : '(STEP ${stepController.currentStep.value + 1} OF 13)',
                      style: TextStyle(
                        fontFamily: 'PolySans',
                        fontSize: isSmallScreen ? 15 : 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Container(height: 1, color: Colors.black)),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                color: const Color(0xFFF8F8F8),
                child: Obx(() {
                  int currentStep = stepController.currentStep.value;
                  if (currentStep == 13) {
                    return _buildSummaryScreen(isSmallScreen);
                  }
                  return _buildStepContent(currentStep, width);
                }),
              ),
            ),

            Obx(() {
              bool isViewingFromSummary =
                  stepController.isViewingFromSummary.value;
              int currentStep = stepController.currentStep.value;

              // If viewing from summary, show simplified buttons
              if (isViewingFromSummary && currentStep < 13) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFFF8F8F8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // GO BACK TO SUMMARY BUTTON
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            stepController.setViewingFromSummary(false);
                            stepController.goToStep(13);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.black),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 20 : 30,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                size: 16,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Go Back',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Colors.black,
                                  fontFamily: 'PolySans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // PROCEED TO SUMMARY BUTTON
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            stepController.markStepAsFilled(currentStep);
                            stepController.setViewingFromSummary(false);
                            stepController.goToStep(13);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff173EA6),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 20 : 30,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Proceed Next',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PolySans',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Normal flow buttons
              return Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFFF8F8F8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentStep > 0 && currentStep < 13)
                          OutlinedButton(
                            onPressed: stepController.previousStep,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.black),
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 30 : 40,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_back,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Go Back',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.black,
                                    fontFamily: 'PolySans',
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (currentStep == 0)
                          OutlinedButton(
                            onPressed: _showExitConfirmation,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.black),
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 30 : 40,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_back,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Go Back',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.black,
                                    fontFamily: 'PolySans',
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(),

                        if (currentStep < 12)
                          OutlinedButton(
                            onPressed: () {
                              stepController.markStepAsSkipped(currentStep);
                              stepController.goToStep(currentStep + 1);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xff173EA6),
                              side: BorderSide(color: const Color(0xff173EA6)),
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 30 : 40,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Skip To Next',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: const Color(0xff173EA6),
                                fontFamily: 'PolySans',
                              ),
                            ),
                          )
                        else
                          Container(),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (currentStep < 12)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            stepController.markStepAsFilled(currentStep);
                            stepController.nextStep();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff173EA6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Proceed Next',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PolySans',
                            ),
                          ),
                        ),
                      )
                    else if (currentStep == 12)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            stepController.markStepAsFilled(12);
                            stepController.goToStep(13);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff173EA6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'View Summary',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PolySans',
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xff173EA6), Color(0xff091840)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            onPressed: _exportToPdf,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Create A PDF',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'PolySans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryScreen(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---- STEP LIST ----
          Column(
            children: [
              for (int i = 0; i < stepTitles.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildStepTile(i, isSmallScreen),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // ---- BOTTOM BUTTONS ----
          Column(
            children: [
              // GO BACK
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    stepController.setViewingFromSummary(false);
                    stepController.goToStep(12);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "Go Back",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontFamily: "PolySans",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepTile(int index, bool isSmallScreen) {
    bool isFilled = stepController.stepStatus[index] == "Filled";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: isFilled ? const Color(0xff173EA6) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isFilled ? Colors.transparent : Colors.black,
          width: isFilled ? 0 : 1.4,
        ),
      ),
      child: Row(
        children: [
          // STEP TITLE
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  stepTitles[index],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: "PolySans",
                    color: isFilled ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  isFilled ? "(Filled)" : "(Skipped)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "PolySans",
                    color: isFilled ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // VIEW + ICON
          GestureDetector(
            onTap: () {
              stepController.setViewingFromSummary(true);
              stepController.goToStep(index);
            },
            child: Row(
              children: [
                Text(
                  "VIEW",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15 : 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: "PolySans",
                    color: isFilled ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.remove_red_eye_outlined,
                  size: 20,
                  color: isFilled ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer(Widget child, bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 430),
        child: Container(
          margin: EdgeInsets.all(isSmallScreen ? 8 : 16),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStepContent(int step, double width) {
    bool isSmallScreen = width < 600;

    switch (step) {
      case 0:
        return _buildMainInformationSection(isSmallScreen);
      case 1:
        return _buildCustomerInfoSection(isSmallScreen);
      case 2:
        return _buildChassisRunningGearSection(isSmallScreen);
      case 3:
        return _buildElectricalSystemSection(isSmallScreen);
      case 4:
        return _buildGasSystemSection(isSmallScreen);
      case 5:
        return _buildWaterSystemSection(isSmallScreen);
      case 6:
        return _buildBodyworkSection(isSmallScreen);  
      case 7:
        return _buildVentilationSection(isSmallScreen);
      case 8:
        return _buildFireAndSafetySection(isSmallScreen);
      case 9:
        return _buildSmokeCarbonMonoxideSection(isSmallScreen);
      case 10:
        return _buildAdditionalInformationSection(isSmallScreen);
      case 11:
        return _buildBatteryInfoSection(isSmallScreen);
      case 12:
        return _buildFinalizationSection(isSmallScreen);
      default:
        return Container();
    }
  }

  Widget _buildBatteryInfoSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Battery Info',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 20),
          
          // Battery Rest Voltage
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Battery Rest Voltage',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: batteryRestVoltageController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // RCD Test 1x1
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* RCD Test 1x1',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: rcdTest1x1Controller,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // RCD Test 5 Times
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* RCD Test 5 Times',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: rcdTest5TimesController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Earth Bond Chassis
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Earth Bond Chassis',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: earthBondChassisController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Continuity Test Gas
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Continuity Test Gas',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: continuityTestGasController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Charger Voltage
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Charger Voltage',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: chargerVoltageController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Gas Hose Expiry Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Gas Hose Expiry Date',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: gasHoseExpiryDateController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Regulator Age
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Regulator Age',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: regulatorAgeController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Comments (Optional)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 120 : 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Comments (Optional)',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: batteryCommentsController,
                ),
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildMainInformationSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Main Information',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 25),

          // Upload Box with Image Preview
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _isUploading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          "Uploading...",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'PolySans',
                          ),
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: _selectedImage != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      onPressed: _removeImage,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 24,
                                        minHeight: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.attach_file,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Add* Attachments",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontFamily: 'PolySans',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "File Type: JPG, PNG, JPEG",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11,
                                    fontFamily: 'PolySans',
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          // Workshop Name & Address
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 50 : 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter* Approved Workshop Name & Address',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    isDense: true,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 12 : 14,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontFamily: 'PolySans',
                  ),
                  controller: mainWorkshopNameController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Job Reference/Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 50 : 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter* Job Reference/Date',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    isDense: true,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: mainJobReferenceController,
                ),
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildCustomerInfoSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 25),

          // Customer Name
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: customerNameController,
              decoration: InputDecoration(
                hintText: 'Enter* Customer Name',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                isDense: true,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'PolySans',
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Make & Model
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: makeModelController,
              decoration: InputDecoration(
                hintText: 'Enter* Make & Model',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                isDense: true,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'PolySans',
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Workshop Name
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: workshopNameController,
              decoration: InputDecoration(
                hintText: 'Enter* Workshop Name',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                isDense: true,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'PolySans',
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Job Reference
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: jobReferenceController,
              decoration: InputDecoration(
                hintText: 'Enter* Job Reference',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                isDense: true,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'PolySans',
              ),
            ),
          ),
          const SizedBox(height: 16),

          // CRIS/Vin Number
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: crisVinNumberController,
              decoration: InputDecoration(
                hintText: 'Enter* CRIS/Vin Number',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                isDense: true,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'PolySans',
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildChassisRunningGearSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Underbody',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 20),

          // Status fields
          ...formData.chassisRunningGear.entries.map(
            (entry) => _buildStatusField(entry.key, entry.value, (value) {
              setState(() {
                formData.chassisRunningGear[entry.key] = value;
              });
            }, isSmallScreen),
          ),

          const SizedBox(height: 24),

          // Comments field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 120 : 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter* Comments (Optional)',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  maxLines: 3,
                  controller: underbodyCommentsController,
                ),
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildElectricalSystemSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Electrical System',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 20),

          /// 240V Appliances Row
          _buildVoltageRow(
            label: '240 V*',
            hint: 'Appliances',
            isSmallScreen: isSmallScreen,
            onTap: () {
              _show240VAppliancesDialog(context, isSmallScreen);
            },
          ),

          const SizedBox(height: 16),

          /// 12V Appliances Row
          _buildVoltageRow(
            label: '12 V*',
            hint: 'Appliances',
            isSmallScreen: isSmallScreen,
            onTap: () {
              _show12VAppliancesDialog(context, isSmallScreen);
            },
          ),

          const SizedBox(height: 24),

          /// Comments
          Container(
            height: isSmallScreen ? 140 : 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter* Comments (Optional)',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                hintStyle: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey.shade600,
                  fontFamily: 'PolySans',
                ),
              ),
              controller: electricalSystemCommentsController,
            ),
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildVoltageRow({
    required String label,
    required String hint,
    required bool isSmallScreen,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: isSmallScreen ? 48 : 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: '$label ',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: hint,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'PolySans',
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        /// Blue action button
        InkWell(
          onTap: onTap,
          child: Container(
            height: isSmallScreen ? 48 : 56,
            width: isSmallScreen ? 48 : 56,
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: const Icon(Icons.open_in_new, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterSystemSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Water System',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 20),
          
          // Water Pump & Pressure
          _buildStatusField(
            'Select* Water Pump & Pressure',
            formData.waterSystem['Water Pump & Pressure'] ?? '',
            (value) {
              setState(() {
                formData.waterSystem['Water Pump & Pressure'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Taps, Valve, Pipes & Tank
          _buildStatusField(
            'Select* Taps, Valve, Pipes & Tank',
            formData.waterSystem['Taps, Valve, Pipes & Tank'] ?? '',
            (value) {
              setState(() {
                formData.waterSystem['Taps, Valve, Pipes & Tank'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Water Inlets
          _buildStatusField(
            'Select* Water Inlets',
            formData.waterSystem['Water Inlets'] ?? '',
            (value) {
              setState(() {
                formData.waterSystem['Water Inlets'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Waste System
          _buildStatusField(
            'Select* Waste System',
            formData.waterSystem['Waste System'] ?? '',
            (value) {
              setState(() {
                formData.waterSystem['Waste System'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Toilet
          _buildStatusField(
            'Select* Toilet',
            formData.waterSystem['Toilet'] ?? '',
            (value) {
              setState(() {
                formData.waterSystem['Toilet'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Comments (Optional)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 120 : 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Enter* Comments (Optional)',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  maxLines: 4,
                  controller: waterSystemCommentsController,
                ),
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildBodyworkSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Work', 
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 20),
          
          // Doors & Windows
          _buildStatusField(
            'Select* Doors & Windows',
            formData.bodywork['Doors & Windows'] ?? '',
            (value) {
              setState(() {
                formData.bodywork['Doors & Windows'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // General Roof Condition
          _buildStatusField(
            'Select* General Roof Condition',
            formData.bodywork['General Roof Condition'] ?? '',
            (value) {
              setState(() {
                formData.bodywork['General Roof Condition'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // External Seals
          _buildStatusField(
            'Select* External Seals',
            formData.bodywork['External Seals'] ?? '',
            (value) {
              setState(() {
                formData.bodywork['External Seals'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Floor
          _buildStatusField(
            'Select* Floor',
            formData.bodywork['Floor'] ?? '',
            (value) {
              setState(() {
                formData.bodywork['Floor'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Furniture
          _buildStatusField(
            'Select* Furniture',
            formData.bodywork['Furniture'] ?? '',
            (value) {
              setState(() {
                formData.bodywork['Furniture'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Damp Test
          _buildStatusField(
            'Select* Damp Test',
            formData.bodywork['Damp Test'] ?? '',
            (value) {
              setState(() {
                formData.bodywork['Damp Test'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          
          // Comments (Optional)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 120 : 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Enter* Comments (Optional)',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  maxLines: 4,
                  controller: bodyworkCommentsController,
                ),
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildVentilationSection(bool isSmallScreen) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFormContainer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ventilation',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'PolySans',
                  ),
                ),
                const SizedBox(height: 20),
                ...formData.ventilation.entries.map(
                  (entry) => _buildStatusField(entry.key, entry.value, (value) {
                    setState(() {
                      formData.ventilation[entry.key] = value;
                    });
                  }, isSmallScreen),
                ),
                 const SizedBox(height: 10),
                // Comments (Optional)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: isSmallScreen ? 140 : 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Enter* Comments (Optional)',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontFamily: 'PolySans',
                          ),
                        ),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'PolySans',
                        ),
                        maxLines: 4,
                        controller: ventilationCommentsController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isSmallScreen,
          ),      
        ],
      ),
    );
  }

  Widget _buildFireAndSafetySection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fire & Safety',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
          ),
        ),
        const SizedBox(height: 20),
        
        // Press Test Button On Smoke
        _buildStatusField(
          'Select* Press Test Button On Smoke',
          formData.fireSafety['Press Test Button On Smoke'] ?? '',
          (value) {
            setState(() {
              formData.fireSafety['Press Test Button On Smoke'] = value;
            });
          },
          isSmallScreen,
        ),
        const SizedBox(height: 10),
        
        // Press Test Button CO Alarm
        _buildStatusField(
          'Select* Press Test Button CO Alarm',
          formData.fireSafety['Press Test Button CO Alarm'] ?? '',
          (value) {
            setState(() {
              formData.fireSafety['Press Test Button CO Alarm'] = value;
            });
          },
          isSmallScreen,
        ),
        const SizedBox(height: 10),
        
        // If A Fire Extinguisher is Fitted
        _buildStatusField(
          'Select* If A Fire Extinguisher is Fitted',
          formData.fireSafety['If A Fire Extinguisher is Fitted'] ?? '',
          (value) {
            setState(() {
              formData.fireSafety['If A Fire Extinguisher is Fitted'] = value;
            });
          },
          isSmallScreen,
        ),
        const SizedBox(height: 10),
        
        // Comments (Optional)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: isSmallScreen ? 120 : 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  hintText: 'Enter* Comments (Optional)',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                ),
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
                maxLines: 4,
                controller: fireSafetyCommentsController,
              ),
            ),
          ],
        ),
      ],
    ),
    isSmallScreen,
  );
}

  Widget _buildGasSystemSection(bool isSmallScreen) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFormContainer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LPG Gas System',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'PolySans',
                  ),
                ),
                const SizedBox(height: 20),
                
                // Regulator, Gas Hose, Pipe
                _buildStatusField(
                  'Select* Regulator, Gas Hose, Pipe..',
                  formData.gasSystem['Select* Regulator, Gas Hose, Pipe..'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Select* Regulator, Gas Hose, Pipe..'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // Gas Tightness Check
                _buildStatusField(
                  'Select* Gas Tightness Check',
                  formData.gasSystem['Select* Gas Tightness Check'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Select* Gas Tightness Check'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // Gas Dispersal Vents
                _buildStatusField(
                  'Select* Gas Dispersal Vents',
                  formData.gasSystem['Select* Gas Dispersal Vents'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Select* Gas Dispersal Vents'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // Security Of Gas Cylinder
                _buildStatusField(
                  'Select* Security Of Gas Cylinder',
                  formData.gasSystem['Select* Security Of Gas Cylinder'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Select* Security Of Gas Cylinder'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // Operation of Fridge & FF
                _buildStatusField(
                  'Select* Operation of Fridge & FF',
                  formData.gasSystem['Select* Operation of Fridge & FF'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Select* Operation of Fridge & FF'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // Operation of Hob/Cooker & FF
                _buildStatusField(
                  'Check* Operation of Hob/Cooker & FF',
                  formData.gasSystem['Check* Operation of Hob/Cooker & FF'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Check* Operation of Hob/Cooker & FF'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // Operation of Space Heater & FF
                _buildStatusField(
                  'Check* Operation of Space Heater & FF',
                  formData.gasSystem['Check* Operation of Space Heater & FF'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Check* Operation of Space Heater & FF'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // Operation of Water Heater & FF
                _buildStatusField(
                  'Check* Operation of Water Heater & FF',
                  formData.gasSystem['Check* Operation of Water Heater & FF'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Check* Operation of Water Heater & FF'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // CO Test
                _buildStatusField(
                  'Select* CO Test',
                  formData.gasSystem['Select* CO Test'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Select* CO Test'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                
                // Comments (Optional)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: isSmallScreen ? 120 : 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Enter* Comments (Optional)',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontFamily: 'PolySans',
                          ),
                        ),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'PolySans',
                        ),
                        maxLines: 4,
                        controller: gasSystemCommentsController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isSmallScreen,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSmokeCarbonMonoxideSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Smoke/Carbon Monoxide',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 20),
          
          // Smoke Alarm Expiry Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Smoke Alarm Expiry Date',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: smokeAlarmExpiryDateController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Carbon Monoxide Alarm Expiry Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Carbon Monoxide Alarm Expiry Date',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: carbonMonoxideAlarmExpiryDateController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Fire Extinguisher Expiry Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Fire Extinguisher Expiry Date',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: fireExtinguisherExpiryDateController,
                ),
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildAdditionalInformationSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 20),
          
          // Customer Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Customer Name',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: additionalCustomerNameController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Make & Model
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Make & Model',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: additionalMakeModelController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Vin Number
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 45 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: 'Enter* Vin Number',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  controller: additionalVinNumberController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Service Information
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 100 : 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Enter* Service Information:',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  maxLines: 4,
                  controller: additionalServiceInfoController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Comments (Optional)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallScreen ? 120 : 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Enter* Comments (Optional)',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'PolySans',
                    ),
                  ),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                  maxLines: 4,
                  controller: additionalCommentsController,
                ),
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

//  Widget _buildFinalizationSection(bool isSmallScreen) {
//   return _buildFormContainer(
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Finalization',
//           style: TextStyle(
//             fontSize: isSmallScreen ? 20 : 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//             fontFamily: 'PolySans',
//           ),
//         ),
//         const SizedBox(height: 20),
        
//         // Service Technician Name
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: isSmallScreen ? 45 : 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade400),
//               ),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   hintText: 'Enter* Service Technician Name',
//                   hintStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 14 : 16,
//                   fontFamily: 'PolySans',
//                 ),
//                 controller: serviceTechnicianNameController,
//               ),
//             ),
//           ],
//         ),
        
//         const SizedBox(height: 16),
        
//         // EICR Offered
//         Row(
//           children: [
//             Text(
//               'EICR Offered:',
//               style: TextStyle(
//                 fontSize: isSmallScreen ? 14 : 16,
//                 fontFamily: 'PolySans',
//               ),
//             ),
//             Checkbox(
//               value: formData.eicrOffered,
//               onChanged: (value) =>
//                   setState(() => formData.eicrOffered = value ?? false),
//             ),
//           ],
//         ),
        
//         const SizedBox(height: 16),
        
//         // Customer Signature
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: isSmallScreen ? 45 : 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade400),
//               ),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   hintText: 'Enter* Customer Signature',
//                   hintStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 14 : 16,
//                   fontFamily: 'PolySans',
//                 ),
//                 controller: customerSignatureController,
//               ),
//             ),
//           ],
//         ),
        
//         const SizedBox(height: 16),
        
//         // Signature
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: isSmallScreen ? 45 : 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade400),
//               ),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   hintText: 'Enter* Signature',
//                   hintStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 14 : 16,
//                   fontFamily: 'PolySans',
//                 ),
//                 controller: signatureController,
//               ),
//             ),
//           ],
//         ),
        
//         const SizedBox(height: 16),
        
//         // Date
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: isSmallScreen ? 45 : 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade400),
//               ),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   hintText: 'Enter* Date',
//                   hintStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 14 : 16,
//                   fontFamily: 'PolySans',
//                 ),
//                 controller: dateController,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//     isSmallScreen,
//   );
// }

Widget _buildFinalizationSection(bool isSmallScreen) {
  return _buildFormContainer(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Finalization',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'PolySans',
          ),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: isSmallScreen ? 45 : 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextFormField(
                controller: serviceTechnicianNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: 'Enter* Service Technician Name',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                ),
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'EICR Offered:',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'PolySans',
              ),
            ),
            Checkbox(
              value: formData.eicrOffered,
              onChanged: (value) =>
                  setState(() => formData.eicrOffered = value ?? false),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: isSmallScreen ? 45 : 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextFormField(
                controller: customerSignatureController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: 'Enter* Customer Signature',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                ),
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: isSmallScreen ? 45 : 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextFormField(
                controller: signatureController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: 'Enter* Signature',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'PolySans',
                  ),
                ),
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: 'PolySans',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Date field with date picker
        _buildDateField(isSmallScreen),
      ],
    ),
    isSmallScreen,
  );
}

Widget _buildDateField(bool isSmallScreen) {
  return Container(
    height: isSmallScreen ? 50 : 55,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: InkWell(
      onTap: () => _selectDate(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formData.date != null && formData.date!.isNotEmpty
                ? formData.date!
                : 'Enter* Date',
              style: TextStyle(
                color: formData.date != null && formData.date!.isNotEmpty
                    ? Colors.black
                    : Colors.grey.shade600,
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'PolySans',
              ),
            ),
            Icon(Icons.calendar_today,
                color: Colors.grey.shade600, size: 20),
          ],
        ),
      ),
    ),
  );
}

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  
  if (picked != null) {
    final formattedDate = '${picked.day}/${picked.month}/${picked.year}';
    setState(() {
      formData.date = formattedDate;
      dateController.text = formattedDate;
    });
  }
}

  Widget _buildStatusField(
    String label,
    String value,
    Function(String) onChanged,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
                fontFamily: 'PolySans',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Container(
              height: isSmallScreen ? 45 : 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value.isEmpty ? null : value,
                  alignment: Alignment.center,
                  isExpanded: true,
                  items: statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Center(
                        child: Text(
                          status,
                          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) => onChanged(newValue ?? ''),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 void _showExitConfirmation() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Exit Form?', style: TextStyle(fontFamily: 'PolySans')),
      content: const Text(
        'Are you sure you want to exit? Your progress may not be saved.',
        style: TextStyle(fontFamily: 'PolySans'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontFamily: 'PolySans',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Navigate back to home screen
          },
          child: const Text(
            'Exit',
            style: TextStyle(
              color: Color(0xff173EA6),
              fontFamily: 'PolySans',
            ),
          ),
        ),
      ],
    ),
  );
}
}