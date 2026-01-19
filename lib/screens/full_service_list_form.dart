import 'dart:typed_data';
import 'package:data/models/full_service_list_model.dart';
import 'package:data/services/full_service_list_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:printing/printing.dart';

// Update the controller to have 9 total steps
class FullServiceListStepController extends GetxController {
  var currentStep = 0.obs;
  var stepStatus = <int, String>{}.obs;
  var isViewingFromSummary = false.obs;
  
  final int totalSteps = 9; // Updated to 9 steps (0-8)

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= totalSteps) {
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
  
  void initializeSteps() {
    for (int i = 0; i < totalSteps; i++) {
      markStepAsSkipped(i);
    }
  }
}

class FullServiceListForm extends StatefulWidget {
  const FullServiceListForm({super.key});

  @override
  State<FullServiceListForm> createState() => _FullServiceListFormState();
}

class _FullServiceListFormState extends State<FullServiceListForm> {
  // Controllers
  final FullServiceListStepController stepController = Get.put(
    FullServiceListStepController(),
  );

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  // Data model
  final FullServiceListModel formData = FullServiceListModel();
  
  // Text editing controllers for all text fields

  // Add text controllers for comments
  late TextEditingController vehicleOnFloorCommentsController;
  late TextEditingController vehicleRaisedCommentsController;
  late TextEditingController vehicleFullyRaisedCommentsController;
  late TextEditingController vehicleHalfRaisedCommentsController;
  late TextEditingController underBonetOperationsCommentsController;
  late TextEditingController finalItemsChecksCommentsController;
   late TextEditingController finalizationCommentsController;
  // Main Information (Step 0)
  late TextEditingController workshopNameController;
  late TextEditingController jobReferenceController;
  
  // Customer Information (Step 1)
  late TextEditingController customerNameController;
  late TextEditingController makeModelController;
  late TextEditingController registrationNumberController;
  late TextEditingController crisVinNumberController;
  
  // Finalization (Step 8)
  late TextEditingController technicianNameController;
  late TextEditingController technicianSignatureController;
  
  // For Step 0: Single image upload
  File? _selectedImage;
  bool _isUploading = false;
  
  // Constants
  static const _backgroundColor = Color(0xFFF8F8F8);
  static const _primaryColor = Color(0xff173EA6);
  static const _secondaryColor = Color(0xff091840);
  static const _fontFamily = 'PolySans';

  // Step titles - 9 steps total
  final List<String> stepTitles = [
    'Main Information',                // Step 0
    'Customer Information',            // Step 1
    'Vehicle On Floor',                // Step 2 - matches section title
    'Vehicle Raised',                  // Step 3 - matches section title
    'Vehicle Fully Raised',            // Step 4 - matches section title
    'Vehicle Half Raised',             // Step 5 - matches section title
    'Under Bonet Operations',          // Step 6 - matches section title
    'Final Items Checks',              // Step 7 - matches section title
    'Finalization',                    // Step 8 - matches section title
  ];

  @override
  void initState() {
    super.initState();
    stepController.initializeSteps();
    
    // Initialize text controllers with formData values
        vehicleOnFloorCommentsController = TextEditingController(text: formData.vehicleOnFloorComments);
    vehicleRaisedCommentsController = TextEditingController(text: formData.vehicleRaisedComments);
    vehicleFullyRaisedCommentsController = TextEditingController(text: formData.vehicleFullyRaisedComments);
    vehicleHalfRaisedCommentsController = TextEditingController(text: formData.vehicleHalfRaisedComments);
    underBonetOperationsCommentsController = TextEditingController(text: formData.underBonetOperationsComments);
    finalItemsChecksCommentsController = TextEditingController(text: formData.finalItemsChecksComments);
      finalizationCommentsController = TextEditingController(text: formData.finalizationComments);
    // Main Information (Step 0)
    workshopNameController = TextEditingController(text: formData.workshopName);
    jobReferenceController = TextEditingController(text: formData.jobReference);
    
    // Customer Information (Step 1)
    customerNameController = TextEditingController(text: formData.customerName);
    makeModelController = TextEditingController(text: formData.makeModel);
    registrationNumberController = TextEditingController(text: formData.registrationNumber);
    crisVinNumberController = TextEditingController(text: formData.crisVinNumber);
    
    // Finalization (Step 8)
    technicianNameController = TextEditingController(text: formData.technicianName);
    technicianSignatureController = TextEditingController(text: formData.technicianSignature);
    
    // Add listeners to update formData when text changes
        // Add listeners for comments
    vehicleOnFloorCommentsController.addListener(() => formData.vehicleOnFloorComments = vehicleOnFloorCommentsController.text);
    vehicleRaisedCommentsController.addListener(() => formData.vehicleRaisedComments = vehicleRaisedCommentsController.text);
    vehicleFullyRaisedCommentsController.addListener(() => formData.vehicleFullyRaisedComments = vehicleFullyRaisedCommentsController.text);
    vehicleHalfRaisedCommentsController.addListener(() => formData.vehicleHalfRaisedComments = vehicleHalfRaisedCommentsController.text);
    underBonetOperationsCommentsController.addListener(() => formData.underBonetOperationsComments = underBonetOperationsCommentsController.text);
    finalItemsChecksCommentsController.addListener(() => formData.finalItemsChecksComments = finalItemsChecksCommentsController.text);
    finalizationCommentsController.addListener(() => formData.finalizationComments = finalizationCommentsController.text);
  
  
    // Main Information (Step 0)
    workshopNameController.addListener(() => formData.workshopName = workshopNameController.text);
    jobReferenceController.addListener(() => formData.jobReference = jobReferenceController.text);
    
    // Customer Information (Step 1)
    customerNameController.addListener(() => formData.customerName = customerNameController.text);
    makeModelController.addListener(() => formData.makeModel = makeModelController.text);
    registrationNumberController.addListener(() => formData.registrationNumber = registrationNumberController.text);
    crisVinNumberController.addListener(() => formData.crisVinNumber = crisVinNumberController.text);
    
    // Finalization (Step 8)
    technicianNameController.addListener(() => formData.technicianName = technicianNameController.text);
    technicianSignatureController.addListener(() => formData.technicianSignature = technicianSignatureController.text);
  }

  @override
  void dispose() {
     // Dispose comment controllers
    vehicleOnFloorCommentsController.dispose();
    vehicleRaisedCommentsController.dispose();
    vehicleFullyRaisedCommentsController.dispose();
    vehicleHalfRaisedCommentsController.dispose();
    underBonetOperationsCommentsController.dispose();
    finalItemsChecksCommentsController.dispose();
     finalizationCommentsController.dispose();
    // Dispose all controllers
    workshopNameController.dispose();
    jobReferenceController.dispose();
    customerNameController.dispose();
    makeModelController.dispose();
    registrationNumberController.dispose();
    crisVinNumberController.dispose();
    technicianNameController.dispose();
    technicianSignatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 600;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isSmallScreen),
            _buildStepIndicator(isSmallScreen),
            Expanded(child: _buildContentArea(isSmallScreen, width)),
            Obx(() => _buildBottomButtons(isSmallScreen)),
          ],
        ),
      ),
    );
  }

  // ==================== HEADER SECTION ====================
  Widget _buildHeader(bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: _showExitConfirmation, // Fixed: Use exit confirmation
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
    );
  }

  // ==================== STEP INDICATOR ====================
  Widget _buildStepIndicator(bool isSmallScreen) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Row(
          children: [
            Expanded(child: Container(height: 1, color: Colors.black)),
            const SizedBox(width: 10),
            Text(
              stepController.currentStep.value == stepTitles.length
                  ? '(SUMMARY)'
                  : '(STEP ${stepController.currentStep.value + 1} OF ${stepTitles.length})',
              style: TextStyle(
                fontFamily: _fontFamily,
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
    );
  }

  // ==================== CONTENT AREA ====================
  Widget _buildContentArea(bool isSmallScreen, double width) {
    return Container(
      color: _backgroundColor,
      child: Obx(() {
        final currentStep = stepController.currentStep.value;
        if (currentStep == stepTitles.length) {
          return _buildSummaryScreen(isSmallScreen);
        }
        return _buildStepContent(currentStep, width);
      }),
    );
  }

  Widget _buildStepContent(int step, double width) {
    final isSmallScreen = width < 600;

    switch (step) {
      case 0:
        return _buildMainInformationSection(isSmallScreen);
      case 1:
        return _buildCustomerInformationSection(isSmallScreen);
      case 2:
        return _buildVehicleOnFloorSection(isSmallScreen);
      case 3:
        return _buildVehicleRaisedSection(isSmallScreen);
      case 4:
        return _buildVehicleFullyRaisedSection(isSmallScreen);
      case 5:
        return _buildVehicleHalfRaisedSection(isSmallScreen);
      case 6:
        return _buildUnderBonetOperationsSection(isSmallScreen);
      case 7:
        return _buildFinalItemsChecksSection(isSmallScreen);
      case 8:
        return _buildFinalizationSection(isSmallScreen);
      default:
        return Container();
    }
  }

  // ==================== STEP 0: MAIN INFORMATION (SINGLE IMAGE) ====================
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

          // Upload Box with SINGLE Image Preview
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
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
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
                    onTap: _pickSingleImage,
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
                                      onPressed: _removeSingleImage,
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
                                    const SizedBox(width: 8),
                                    Text(
                                      "Add* Attachments",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontFamily: 'PolySans',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
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
            ),
          ),
          const SizedBox(height: 20),

          // Job Reference/Date
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
            ),
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 1: CUSTOMER INFORMATION ====================
  Widget _buildCustomerInformationSection(bool isSmallScreen) {
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

          // Registration Number
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: registrationNumberController,
              decoration: InputDecoration(
                hintText: 'Enter* Registration Number',
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

  // ==================== STEP 2: SERVICE CHECKLIST ====================
  // ==================== STEP 2: VEHICLE ON FLOOR (WITH COMMENTS) ====================
  Widget _buildVehicleOnFloorSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outer Card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Row(
                children: [
                  Text("•", style: TextStyle(fontSize: 22, color: Colors.black)),
                  SizedBox(width: 8),
                  Text(
                    "Vehicle On Floor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'PolySans',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
          
              const SizedBox(height: 20),
          
              /// 1️⃣ Checkbox only - Fit Protective Covers
              _buildCheckOnlyItem(
                title: 'Fit Protective Covers',
                value: formData.serviceChecklist['Fit Protective Covers'] ?? false,
                onChanged: (v) {
                  setState(() {
                    formData.serviceChecklist['Fit Protective Covers'] = v ?? false;
                  });
                },
                isSmallScreen: isSmallScreen,
              ),
          
              const SizedBox(height: 12),
          
              /// 2️⃣ Checkbox + Dropdown - Instruments
              _buildCheckWithDropdownItem(
                title: 'Instruments',
                value: formData.serviceChecklist['Instruments'] ?? false,
                selectedStatus: formData.serviceStatus['Instruments'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.serviceChecklist['Instruments'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.serviceStatus['Instruments'] = status;
                  });
                },
              ),
          
              const SizedBox(height: 12),
          
              /// 3️⃣ Checkbox + Dropdown - Switches
              _buildCheckWithDropdownItem(
                title: 'Switches',
                value: formData.serviceChecklist['Switches'] ?? false,
                selectedStatus: formData.serviceStatus['Switches'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.serviceChecklist['Switches'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.serviceStatus['Switches'] = status;
                  });
                },
              ),
          
              const SizedBox(height: 12),
          
              /// 4️⃣ Checkbox + Dropdown - Horn
              _buildCheckWithDropdownItem(
                title: 'Horn',
                value: formData.serviceChecklist['Horn'] ?? false,
                selectedStatus: formData.serviceStatus['Horn'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.serviceChecklist['Horn'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.serviceStatus['Horn'] = status;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Comments Box for Vehicle On Floor
              _buildCommentsField(
                'Vehicle On Floor Comments',
                vehicleOnFloorCommentsController,
                isSmallScreen,
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  // Helper widget for checkbox-only items
  Widget _buildCheckOnlyItem({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required bool isSmallScreen,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE6DCDC)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: _fontFamily,
                  ),
                  children: [
                    TextSpan(
                      text: "Check ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const TextSpan(
                      text: "* ",
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text: title,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: _primaryColor,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // Helper widget for checkbox + dropdown items
  Widget _buildCheckWithDropdownItem({
    required String title,
    required bool value,
    required String? selectedStatus,
    required bool isSmallScreen,
    required ValueChanged<bool?> onCheckChanged,
    required ValueChanged<String> onStatusChanged,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE6DCDC)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: _fontFamily,
                  ),
                  children: [
                    TextSpan(
                      text: "Check ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const TextSpan(
                      text: "* ",
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text: title,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Checkbox(
            value: value,
            onChanged: onCheckChanged,
            activeColor: _primaryColor,
          ),
          
          // Vertical divider
          Container(
            height: 28,
            width: 1,
            color: Colors.grey.shade300,
          ),
          
          // Dropdown/PopupMenuButton
          Container(
            width: 120,
            child: PopupMenuButton<String>(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              icon: Row(
                children: [
                  if (selectedStatus != null) 
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(selectedStatus),
                        shape: BoxShape.circle,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      selectedStatus ?? "Select",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                ],
              ),
              onSelected: onStatusChanged,
              itemBuilder: (_) => [
                _buildStatusItem("O.K", Colors.green),
                _buildStatusItem("Advisory", Colors.orange),
                _buildStatusItem("Need Attention", Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case "O.K":
        return Colors.green;
      case "Advisory":
        return Colors.orange;
      case "Need Attention":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper for dropdown menu items
  PopupMenuItem<String> _buildStatusItem(String status, Color color) {
    return PopupMenuItem<String>(
      value: status,
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              fontFamily: _fontFamily,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STEP 3: SAFETY CHECKS ====================
   Widget _buildVehicleRaisedSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Row(
                children: [
                  Text("•", style: TextStyle(fontSize: 22, color: Colors.black)),
                  SizedBox(width: 8),
                  Text(
                    "Vehicle Raised",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'PolySans',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
        
              /// 1️⃣ Checkbox + Dropdown - Oil Leaks (First row)
              _buildCheckWithDropdownItem(
                title: 'Oil Leaks',
                value: formData.safetyChecks['Oil Leaks'] ?? false,
                selectedStatus: formData.safetyStatus['Oil Leaks'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.safetyChecks['Oil Leaks'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.safetyStatus['Oil Leaks'] = status;
                  });
                },
              ),
        
              const SizedBox(height: 12),
        
              /// 2️⃣ Checkbox only - Engine Oil (Second row)
              _buildCheckOnlyItem(
                title: 'Engine Oil',
                value: formData.safetyChecks['Engine Oil'] ?? false,
                onChanged: (v) {
                  setState(() {
                    formData.safetyChecks['Engine Oil'] = v ?? false;
                  });
                },
                isSmallScreen: isSmallScreen,
              ),
        
              const SizedBox(height: 12),
        
              /// 3️⃣ Checkbox only - Engine Oil Filter (Third row)
              _buildCheckOnlyItem(
                title: 'Engine Oil Filter',
                value: formData.safetyChecks['Engine Oil Filter'] ?? false,
                onChanged: (v) {
                  setState(() {
                    formData.safetyChecks['Engine Oil Filter'] = v ?? false;
                  });
                },
                isSmallScreen: isSmallScreen,
              ),
        
              const SizedBox(height: 12),
        
              /// 4️⃣ Checkbox + Dropdown - Gear Oil (Fourth row)
              _buildCheckWithDropdownItem(
                title: 'Gear Oil',
                value: formData.safetyChecks['Gear Oil'] ?? false,
                selectedStatus: formData.safetyStatus['Gear Oil'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.safetyChecks['Gear Oil'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.safetyStatus['Gear Oil'] = status;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Comments Box for Vehicle Raised
              _buildCommentsField(
                'Vehicle Raised Comments',
                vehicleRaisedCommentsController,
                isSmallScreen,
              ),
            ],
          ),       
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 4: HABITATION CHECKS ====================
   Widget _buildVehicleFullyRaisedSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outer Card for Vehicle Fully Raised section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Row(
                children: [
                  Text("•", style: TextStyle(fontSize: 22, color: Colors.black)),
                  SizedBox(width: 8),
                  Text(
                    "Vehicle Fully Raised",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'PolySans',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
        
              /// 1️⃣ Checkbox + Dropdown - Oil Leaks (First row)
              _buildCheckWithDropdownItem(
                title: 'Oil Leaks',
                value: formData.habitationChecks['Oil Leaks'] ?? false,
                selectedStatus: formData.habitationStatus['Oil Leaks'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.habitationChecks['Oil Leaks'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.habitationStatus['Oil Leaks'] = status;
                  });
                },
              ),
        
              const SizedBox(height: 12),
        
              /// 2️⃣ Checkbox only - Engine Oil (Second row)
              _buildCheckOnlyItem(
                title: 'Engine Oil',
                value: formData.habitationChecks['Engine Oil'] ?? false,
                onChanged: (v) {
                  setState(() {
                    formData.habitationChecks['Engine Oil'] = v ?? false;
                  });
                },
                isSmallScreen: isSmallScreen,
              ),
        
              const SizedBox(height: 12),
        
              /// 3️⃣ Checkbox only - Engine Oil Filter (Third row)
              _buildCheckOnlyItem(
                title: 'Engine Oil Filter',
                value: formData.habitationChecks['Engine Oil Filter'] ?? false,
                onChanged: (v) {
                  setState(() {
                    formData.habitationChecks['Engine Oil Filter'] = v ?? false;
                  });
                },
                isSmallScreen: isSmallScreen,
              ),
        
              const SizedBox(height: 12),
        
              /// 4️⃣ Checkbox + Dropdown - Gear Oil (Fourth row)
              _buildCheckWithDropdownItem(
                title: 'Gear Oil',
                value: formData.habitationChecks['Gear Oil'] ?? false,
                selectedStatus: formData.habitationStatus['Gear Oil'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.habitationChecks['Gear Oil'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.habitationStatus['Gear Oil'] = status;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Comments Box for Vehicle Fully Raised
              _buildCommentsField(
                'Vehicle Fully Raised Comments',
                vehicleFullyRaisedCommentsController,
                isSmallScreen,
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 5: ELECTRICAL CHECKS ====================
 Widget _buildVehicleHalfRaisedSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outer Card for Vehicle Half Raised section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Row(
                children: [
                  Text("•", style: TextStyle(fontSize: 22, color: Colors.black)),
                  SizedBox(width: 8),
                  Text(
                    "Vehicle Half Raised",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'PolySans',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
        
              /// 1️⃣ Checkbox + Dropdown - Front Brake (First row)
              _buildCheckWithDropdownItem(
                title: 'Front Brake',
                value: formData.electricalChecks['Front Brake'] ?? false,
                selectedStatus: formData.electricalStatus['Front Brake'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.electricalChecks['Front Brake'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.electricalStatus['Front Brake'] = status;
                  });
                },
              ),
        
              const SizedBox(height: 12),
        
              /// 2️⃣ Checkbox + Dropdown - Rear Brake (Second row)
              _buildCheckWithDropdownItem(
                title: 'Rear Brake',
                value: formData.electricalChecks['Rear Brake'] ?? false,
                selectedStatus: formData.electricalStatus['Rear Brake'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.electricalChecks['Rear Brake'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.electricalStatus['Rear Brake'] = status;
                  });
                },
              ),
        
              const SizedBox(height: 12),
        
              /// 3️⃣ Checkbox + Dropdown - Drum Shoes (Third row)
              _buildCheckWithDropdownItem(
                title: 'Drum Shoes',
                value: formData.electricalChecks['Drum Shoes'] ?? false,
                selectedStatus: formData.electricalStatus['Drum Shoes'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.electricalChecks['Drum Shoes'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.electricalStatus['Drum Shoes'] = status;
                  });
                },
              ),
        
              const SizedBox(height: 12),
        
              /// 4️⃣ Checkbox + Dropdown - Wheel Bearing (Fourth row)
              _buildCheckWithDropdownItem(
                title: 'Wheel Bearing',
                value: formData.electricalChecks['Wheel Bearing'] ?? false,
                selectedStatus: formData.electricalStatus['Wheel Bearing'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.electricalChecks['Wheel Bearing'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.electricalStatus['Wheel Bearing'] = status;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Comments Box for Vehicle Half Raised
              _buildCommentsField(
                'Vehicle Half Raised Comments',
                vehicleHalfRaisedCommentsController,
                isSmallScreen,
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 6: WATER & GAS CHECKS ====================
 Widget _buildUnderBonetOperationsSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Row(
                children: [
                  Text("•", style: TextStyle(fontSize: 22, color: Colors.black)),
                  SizedBox(width: 8),
                  Text(
                    "Under Bonet Operations",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'PolySans',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
        
              /// 1️⃣ Checkbox + Dropdown - Spark Plugs (First row)
              _buildCheckWithDropdownItem(
                title: 'Spark Plugs',
                value: formData.waterGasChecks['Spark Plugs'] ?? false,
                selectedStatus: formData.waterGasStatus['Spark Plugs'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.waterGasChecks['Spark Plugs'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.waterGasStatus['Spark Plugs'] = status;
                  });
                },
              ),
        
              const SizedBox(height: 12),
        
              /// 2️⃣ Checkbox + Dropdown - Drive Belts (Second row)
              _buildCheckWithDropdownItem(
                title: 'Drive Belts',
                value: formData.waterGasChecks['Drive Belts'] ?? false,
                selectedStatus: formData.waterGasStatus['Drive Belts'],
                isSmallScreen: isSmallScreen,
                onCheckChanged: (v) {
                  setState(() {
                    formData.waterGasChecks['Drive Belts'] = v ?? false;
                  });
                },
                onStatusChanged: (status) {
                  setState(() {
                    formData.waterGasStatus['Drive Belts'] = status;
                  });
                },
              ),
        
              const SizedBox(height: 12),
        
              /// 3️⃣ Checkbox only - Air Filters (Third row)
              _buildCheckOnlyItem(
                title: 'Air Filters',
                value: formData.waterGasChecks['Air Filters'] ?? false,
                onChanged: (v) {
                  setState(() {
                    formData.waterGasChecks['Air Filters'] = v ?? false;
                  });
                },
                isSmallScreen: isSmallScreen,
              ),
        
              const SizedBox(height: 12),
        
              /// 4️⃣ Checkbox only - Pollen Filter (Fourth row)
              _buildCheckOnlyItem(
                title: 'Pollen Filter',
                value: formData.waterGasChecks['Pollen Filter'] ?? false,
                onChanged: (v) {
                  setState(() {
                    formData.waterGasChecks['Pollen Filter'] = v ?? false;
                  });
                },
                isSmallScreen: isSmallScreen,
              ),
              
              const SizedBox(height: 20),
              
              // Comments Box for Under Bonet Operations
              _buildCommentsField(
                'Under Bonet Operations Comments',
                underBonetOperationsCommentsController,
                isSmallScreen,
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 7: FINAL ITEMS CHECKS ====================
  Widget _buildFinalItemsChecksSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Row(
            children: [
              Text("•", style: TextStyle(fontSize: 22, color: Colors.black)),
              SizedBox(width: 8),
              Text(
                "Final Items Checks",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PolySans',
                  color: Colors.black,
                ),
              ),
            ],
          ),
    
          const SizedBox(height: 20),
    
          /// 1️⃣ Checkbox + Dropdown - Reset Fault (First row)
          _buildCheckWithDropdownItem(
            title: 'Reset Fault',
            value: formData.finalItemsChecks['Reset Fault'] ?? false,
            selectedStatus: formData.finalItemsStatus['Reset Fault'],
            isSmallScreen: isSmallScreen,
            onCheckChanged: (v) {
              setState(() {
                formData.finalItemsChecks['Reset Fault'] = v ?? false;
              });
            },
            onStatusChanged: (status) {
              setState(() {
                formData.finalItemsStatus['Reset Fault'] = status;
              });
            },
          ),
    
          const SizedBox(height: 12),
    
          /// 2️⃣ Checkbox + Dropdown - Vehicle Locks (Second row)
          _buildCheckWithDropdownItem(
            title: 'Vehicle Locks',
            value: formData.finalItemsChecks['Vehicle Locks'] ?? false,
            selectedStatus: formData.finalItemsStatus['Vehicle Locks'],
            isSmallScreen: isSmallScreen,
            onCheckChanged: (v) {
              setState(() {
                formData.finalItemsChecks['Vehicle Locks'] = v ?? false;
              });
            },
            onStatusChanged: (status) {
              setState(() {
                formData.finalItemsStatus['Vehicle Locks'] = status;
              });
            },
          ),
    
          const SizedBox(height: 12),
    
          /// 3️⃣ Checkbox + Dropdown - Road Wheels (Third row)
          _buildCheckWithDropdownItem(
            title: 'Road Wheels',
            value: formData.finalItemsChecks['Road Wheels'] ?? false,
            selectedStatus: formData.finalItemsStatus['Road Wheels'],
            isSmallScreen: isSmallScreen,
            onCheckChanged: (v) {
              setState(() {
                formData.finalItemsChecks['Road Wheels'] = v ?? false;
              });
            },
            onStatusChanged: (status) {
              setState(() {
                formData.finalItemsStatus['Road Wheels'] = status;
              });
            },
          ),
    
          const SizedBox(height: 12),
    
          /// 4️⃣ Checkbox + Dropdown - Service Lights (Fourth row)
          _buildCheckWithDropdownItem(
            title: 'Service Lights',
            value: formData.finalItemsChecks['Service Lights'] ?? false,
            selectedStatus: formData.finalItemsStatus['Service Lights'],
            isSmallScreen: isSmallScreen,
            onCheckChanged: (v) {
              setState(() {
                formData.finalItemsChecks['Service Lights'] = v ?? false;
              });
            },
            onStatusChanged: (status) {
              setState(() {
                formData.finalItemsStatus['Service Lights'] = status;
              });
            },
          ),
    
          const SizedBox(height: 12),
    
          /// 5️⃣ Checkbox + Dropdown - Road Tests (Fifth row)
          _buildCheckWithDropdownItem(
            title: 'Road Tests',
            value: formData.finalItemsChecks['Road Tests'] ?? false,
            selectedStatus: formData.finalItemsStatus['Road Tests'],
            isSmallScreen: isSmallScreen,
            onCheckChanged: (v) {
              setState(() {
                formData.finalItemsChecks['Road Tests'] = v ?? false;
              });
            },
            onStatusChanged: (status) {
              setState(() {
                formData.finalItemsStatus['Road Tests'] = status;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // Comments Box for Final Items Checks
          _buildCommentsField(
            'Final Items Checks Comments',
            finalItemsChecksCommentsController,
            isSmallScreen,
          ),
        ],
      ),
      isSmallScreen,
    );
  }

   // Helper method to build comments field
  Widget _buildCommentsField(String label, TextEditingController controller, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'PolySans',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter* Comments (Optional)",
              hintStyle: TextStyle(
                fontFamily: 'PolySans',
                color: Colors.grey.shade600,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontFamily: 'PolySans',
            ),
          ),
        ),
      ],
    );
  }

  // ==================== STEP 8: FINALIZATION ====================
  Widget _buildFinalizationSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Row(
            children: [
              Text("•", style: TextStyle(fontSize: 22, color: Colors.black)),
              SizedBox(width: 8),
              Text(
                "Finalization",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PolySans',
                  color: Colors.black,
                ),
              ),
            ],
          ),
    
          const SizedBox(height: 20),
    
          /// 1️⃣ First row - Technician Name
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: technicianNameController,
              decoration: InputDecoration(
                hintText: 'Enter* Technician Name',
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
                   
    
          const SizedBox(height: 12),
    
          /// 2️⃣ Second row - Signature
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: technicianSignatureController,
              decoration: InputDecoration(
                hintText: 'Enter* Signature',
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
          
          const SizedBox(height: 20),
          
          // Comments Box for Finalization
          _buildCommentsField(
            'Finalization Comments',
            finalizationCommentsController,
            isSmallScreen,
          ),
          
          const SizedBox(height: 24),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildFormContainer(Widget child, bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
    );
  }

  // ==================== IMAGE PICKING METHODS (SINGLE IMAGE) ====================
  Future<void> _pickSingleImage() async {
    try {
      setState(() {
        _isUploading = true;
      });

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isUploading = false;
        });
      } else {
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      print('Error picking single image: $e');
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

  void _removeSingleImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // ==================== SUMMARY SCREEN ====================
  Widget _buildSummaryScreen(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: List.generate(stepTitles.length, (index) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildStepTile(index, isSmallScreen),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryButtons(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildStepTile(int index, bool isSmallScreen) {
    final isFilled = stepController.stepStatus[index] == "Filled";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: isFilled ? _primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isFilled ? Colors.transparent : Colors.black,
          width: isFilled ? 0 : 1.4,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Show step name instead of "STEP X"
                Expanded(
                  child: Text(
                    stepTitles[index], // Show the actual step name
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: _fontFamily,
                      color: isFilled ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Text(
                  isFilled ? "(Filled)" : "(Skipped)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: _fontFamily,
                    color: isFilled ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _buildViewButton(isFilled, index, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildViewButton(bool isFilled, int index, bool isSmallScreen) {
    return GestureDetector(
      onTap: () {
        stepController.setViewingFromSummary(true);
        stepController.goToStep(index);
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 50),
        child: Row(
          children: [
            Text(
              "VIEW",
              style: TextStyle(
                fontSize: isSmallScreen ? 15 : 16,
                fontWeight: FontWeight.w800,
                fontFamily: _fontFamily,
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
    );
  }

  Widget _buildSummaryButtons(bool isSmallScreen) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              stepController.setViewingFromSummary(false);
              stepController.goToStep(stepTitles.length - 1);
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
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ElevatedButton(
              onPressed: _isUploading ? null : _exportToPdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: _isUploading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Generating PDF...",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: _fontFamily,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      "Create A PDF",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: _fontFamily,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _exportToPdf() async {
  try {
    setState(() {
      _isUploading = true;
    });

    // Get logo image bytes - PRIORITY: uploaded image > default logo
    Uint8List? logoBytes;
    
    // First try to get uploaded image
    if (_selectedImage != null) {
      try {
        logoBytes = await _selectedImage!.readAsBytes();
      } catch (e) {
        print('Error reading uploaded image: $e');
      }
    }
    
    // If no uploaded image, try default logo
    if (logoBytes == null) {
      try {
        final byteData = await rootBundle.load('assets/images/logo.png');
        logoBytes = byteData.buffer.asUint8List();
      } catch (e) {
        print('Error loading default logo: $e');
      }
    }

    // Prepare uploaded images for the "Uploaded Attachments" section
    List<Uint8List> uploadedImagesForPdf = [];
    if (_selectedImage != null) {
      try {
        final imageBytes = await _selectedImage!.readAsBytes();
        uploadedImagesForPdf.add(imageBytes);
      } catch (e) {
        print('Error preparing image for PDF: $e');
      }
    }

    // Debug print
    print('PDF Generation - Logo available: ${logoBytes != null}');
    print('PDF Generation - Uploaded images: ${uploadedImagesForPdf.length}');

    // Generate PDF
    final pdfBytes = await FullServiceListPdfExport.generatePdf(
      formData,
      logoImageBytes: logoBytes,  // This will be used as header logo
      uploadedImages: uploadedImagesForPdf,  // This will be shown in Main Information section
    );

    // Save and share the PDF
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'full-service-list.pdf',
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

  } catch (e, stackTrace) {
    print('Error generating PDF: $e');
    print('Stack Trace: $stackTrace');
    
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

  // ==================== BOTTOM BUTTONS ====================
  Widget _buildBottomButtons(bool isSmallScreen) {
    final isViewingFromSummary = stepController.isViewingFromSummary.value;
    final currentStep = stepController.currentStep.value;
    final totalSteps = stepTitles.length;

    if (isViewingFromSummary && currentStep < totalSteps) {
      return _buildViewingFromSummaryButtons(isSmallScreen, currentStep, totalSteps);
    }

    return _buildNormalBottomButtons(isSmallScreen, currentStep, totalSteps);
  }

  Widget _buildViewingFromSummaryButtons(bool isSmallScreen, int currentStep, int totalSteps) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: _backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGoBackButton(isSmallScreen, totalSteps),
          const SizedBox(width: 16),
          _buildProceedNextButton(isSmallScreen, currentStep, totalSteps),
        ],
      ),
    );
  }

  Widget _buildNormalBottomButtons(bool isSmallScreen, int currentStep, int totalSteps) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: _backgroundColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLeftButton(isSmallScreen, currentStep, totalSteps),
              if (currentStep < totalSteps - 1) _buildSkipToNextButton(isSmallScreen, currentStep),
            ],
          ),
          const SizedBox(height: 12),
          if (currentStep < totalSteps - 1) _buildProceedNextButtonLarge(isSmallScreen, currentStep)
          else if (currentStep == totalSteps - 1) _buildViewSummaryButton(isSmallScreen),
        ],
      ),
    );
  }

  // ==================== BOTTOM BUTTON COMPONENTS ====================
  Widget _buildGoBackButton(bool isSmallScreen, int totalSteps) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          stepController.setViewingFromSummary(false);
          stepController.goToStep(totalSteps);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
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
            const Icon(Icons.arrow_back, size: 16, color: Colors.black),
            const SizedBox(width: 4),
            Text(
              'Go Back',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.black,
                fontFamily: _fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProceedNextButton(bool isSmallScreen, int currentStep, int totalSteps) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          stepController.markStepAsFilled(currentStep);
          stepController.setViewingFromSummary(false);
          stepController.goToStep(totalSteps);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
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
            fontFamily: _fontFamily,
          ),
        ),
      ),
    );
  }

  Widget _buildLeftButton(bool isSmallScreen, int currentStep, int totalSteps) {
    if (currentStep > 0 && currentStep < totalSteps) {
      return OutlinedButton(
        onPressed: stepController.previousStep,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
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
            const Icon(Icons.arrow_back, size: 16, color: Colors.black),
            const SizedBox(width: 4),
            Text(
              'Go Back',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.black,
                fontFamily: _fontFamily,
              ),
            ),
          ],
        ),
      );
    } else if (currentStep == 0) {
      return OutlinedButton(
        onPressed: _showExitConfirmation,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
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
            const Icon(Icons.arrow_back, size: 16, color: Colors.black),
            const SizedBox(width: 4),
            Text(
              'Go Back',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.black,
                fontFamily: _fontFamily,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildSkipToNextButton(bool isSmallScreen, int currentStep) {
    return OutlinedButton(
      onPressed: () {
        stepController.markStepAsSkipped(currentStep);
        stepController.goToStep(currentStep + 1);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        side: const BorderSide(color: _primaryColor),
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
          color: _primaryColor,
          fontFamily: _fontFamily,
        ),
      ),
    );
  }

  Widget _buildProceedNextButtonLarge(bool isSmallScreen, int currentStep) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          stepController.markStepAsFilled(currentStep);
          stepController.nextStep();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            fontFamily: _fontFamily,
          ),
        ),
      ),
    );
  }

  Widget _buildViewSummaryButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          stepController.markStepAsFilled(stepTitles.length - 1);
          stepController.goToStep(stepTitles.length);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            fontFamily: _fontFamily,
          ),
        ),
      ),
    );
  }

  // ==================== HELPER METHODS ====================
  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Form?', style: TextStyle(fontFamily: _fontFamily)),
        content: const Text(
          'Are you sure you want to exit? Your progress may not be saved.',
          style: TextStyle(fontFamily: _fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: _fontFamily,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Navigate back to home screen
            },
            child: Text(
              'Exit',
              style: TextStyle(
                color: _primaryColor,
                fontFamily: _fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}