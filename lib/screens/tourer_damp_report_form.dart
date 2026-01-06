import 'dart:typed_data';
import 'package:data/models/tourer_damp_report_model.dart';
import 'package:data/services/tourer_damp_report_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:printing/printing.dart';

// Updated controller for 10 steps total (0-9)
class TourerDampReportStepController extends GetxController {
  var currentStep = 0.obs;
  var stepStatus = <int, String>{}.obs;
  var isViewingFromSummary = false.obs;
  
  final int totalSteps = 10; // Total 10 steps (0-9)

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

class TourerDampReportForm extends StatefulWidget {
  const TourerDampReportForm({super.key});

  @override
  State<TourerDampReportForm> createState() => _TourerDampReportFormState();
}

class _TourerDampReportFormState extends State<TourerDampReportForm> {
  // Controllers
  final TourerDampReportStepController stepController = Get.put(
    TourerDampReportStepController(),
  );

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  // Data model
  final TourerDampModel formData = TourerDampModel();
  
  // For Step 0: Single image upload
  File? _selectedImage;
  bool _isUploading = false;
  
  // For Steps 3-8: Photo sections (Motorhome-style) - 6 sections now
  List<XFile?> sectionImages = List.generate(6, (_) => null);
  List<Uint8List?> sectionImageBytes = List.generate(6, (_) => null);
  List<TextEditingController> sectionCommentControllers = List.generate(
    6, 
    (_) => TextEditingController()
  );
  List<String> sectionComments = List.generate(6, (_) => '');

  // Form field controllers for Step 9
  final dampMeterCalibrationController = TextEditingController();
  final weatherConditionsController = TextEditingController();
  final ambientTemperatureController = TextEditingController();
  final dampMeterMakeModelController = TextEditingController();
  final serviceTechnicianNameController = TextEditingController();
  final technicianSignatureController = TextEditingController();
  final customerSignatureController = TextEditingController();
  
  // Step 0 controllers
  final workshopNameController = TextEditingController();
  final jobReferenceController = TextEditingController();
  
  // Step 1 controllers
  final customerNameController = TextEditingController();
  final makeModelController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final crisVinNumberController = TextEditingController();
  
  // Step 2 controller
  final commentsRecommendationsController = TextEditingController();

  // Constants
  static const _backgroundColor = Color(0xFFF8F8F8);
  static const _primaryColor = Color(0xff173EA6);
  static const _secondaryColor = Color(0xff091840);
  static const _fontFamily = 'PolySans';

  // Step titles - 10 steps total
  final List<String> stepTitles = [
    'Main Information',                // Step 0
    'Customer Information',            // Step 1
    'Damp Readings',                   // Step 2
    'Attach Nearside Photo',           // Step 3 (Motorhome-style)
    'Attach Offside Photo',            // Step 4 (Motorhome-style)
    'Attach Front Photo',              // Step 5 (Motorhome-style)
    'Attach Back Photo',               // Step 6 (Motorhome-style)
    'Attach Ceiling Photo',            // Step 7
    'Attach Floor Photo',              // Step 8
    'Finalization',                    // Step 9
  ];

  // Section data for photo steps (Steps 3-8) - Updated to match PDF service order
  final List<Map<String, String>> sectionInstructions = [
    {
      'title': 'Attach Front Photo',
      'image': 'assets/images/front2.png',
      'key': 'Front',
    },
    {
      'title': 'Attach Back Photo',
      'image': 'assets/images/back2.png',
      'key': 'Rear',
    },
    {
      'title': 'Attach Nearside Photo',
      'image': 'assets/images/nearside2.png',
      'key': 'Nearside',
    },
    {
      'title': 'Attach Offside Photo',
      'image': 'assets/images/offside2.png',
      'key': 'Offside',
    },
    {
      'title': 'Attach Ceiling Photo',
      'image': 'assets/images/ceiling2.png',
      'key': 'Ceiling',
    },
    {
      'title': 'Attach Floor Photo',
      'image': 'assets/images/floor2.png',
      'key': 'Floor',
    },
  ];

  @override
  void initState() {
    super.initState();
    stepController.initializeSteps();
  }

  @override
  void dispose() {
    // Dispose all text controllers
    for (var controller in sectionCommentControllers) {
      controller.dispose();
    }
    dampMeterCalibrationController.dispose();
    weatherConditionsController.dispose();
    ambientTemperatureController.dispose();
    dampMeterMakeModelController.dispose();
    serviceTechnicianNameController.dispose();
    technicianSignatureController.dispose();
    customerSignatureController.dispose();
    workshopNameController.dispose();
    jobReferenceController.dispose();
    customerNameController.dispose();
    makeModelController.dispose();
    registrationNumberController.dispose();
    crisVinNumberController.dispose();
    commentsRecommendationsController.dispose();
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
            onPressed: () => Get.back(),
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
        return _buildCustomerInfoSection(isSmallScreen);
      case 2:
        return _buildDampReadingsSection(isSmallScreen);
      case 3:
        return _buildPhotoAttachmentSection(2, isSmallScreen); // Nearside
      case 4:
        return _buildPhotoAttachmentSection(3, isSmallScreen); // Offside     
      case 5:
        return _buildPhotoAttachmentSection(0, isSmallScreen); // Front
      case 6:
        return _buildPhotoAttachmentSection(1, isSmallScreen); // back  
      case 7:
        return _buildPhotoAttachmentSection(4, isSmallScreen); // Ceiling
      case 8:
        return _buildPhotoAttachmentSection(5, isSmallScreen); // Floor
      case 9:
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
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 25),

          // Upload Box with Single Image Preview
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
                            fontFamily: _fontFamily,
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
                                        fontFamily: _fontFamily,
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
                                    fontFamily: _fontFamily,
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
                  fontFamily: _fontFamily,
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                fontFamily: _fontFamily,
              ),
              onChanged: (value) => formData.workshopName = value,
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
                  fontFamily: _fontFamily,
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: _fontFamily,
              ),
              onChanged: (value) => formData.jobReference = value,
            ),
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 1: CUSTOMER INFORMATION ====================
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
              fontFamily: _fontFamily,
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
                  fontFamily: _fontFamily,
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: _fontFamily,
              ),
              onChanged: (value) => formData.customerName = value,
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
                  fontFamily: _fontFamily,
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: _fontFamily,
              ),
              onChanged: (value) => formData.makeModel = value,
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
                hintText: 'Enter* Registeration Number',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                isDense: true,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: _fontFamily,
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: _fontFamily,
              ),
              onChanged: (value) => formData.registrationNumber = value,
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
                  fontFamily: _fontFamily,
                ),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: _fontFamily,
              ),
              onChanged: (value) => formData.crisVinNumber = value,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 2: DAMP READINGS ====================
  Widget _buildDampReadingsSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Guidance Notes',
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 20),

          // BLUE Guidance Note Button
          GestureDetector(
            onTap: () => _showGuidanceNoteDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xff173EA6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'View* Guidance Note',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.open_in_new, color: Colors.white),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Comments & Recommendations Text Area
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
            ),
            child: TextFormField(
              controller: commentsRecommendationsController,
              maxLines: 5,
              onChanged: (value) => formData.commentsRecommendations = value,
              decoration: const InputDecoration(
                hintText: 'Enter* Comments & Recommendations',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: _fontFamily,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: _fontFamily,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // BLACK Precaution Note Button
          GestureDetector(
            onTap: () => _showPrecautionNoteDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'View* Precaution Note',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.open_in_new, color: Colors.white),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 9: FINALIZATION ====================
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
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 25),

          // Damp Meter Calibration Check Figure
          _buildFinalizationTextField(
            controller: dampMeterCalibrationController,
            hintText: 'Enter* Damp Meter Calibration Check Figure',
            isSmallScreen: isSmallScreen,
            onChanged: (value) => formData.dampMeterCalibration = value,
          ),
          const SizedBox(height: 16),

          // Weather Conditions
          _buildFinalizationTextField(
            controller: weatherConditionsController,
            hintText: 'Enter* Weather Conditions',
            isSmallScreen: isSmallScreen,
            onChanged: (value) => formData.weatherConditions = value,
          ),
          const SizedBox(height: 16),

          // Ambient Temperature
          _buildFinalizationTextField(
            controller: ambientTemperatureController,
            hintText: 'Enter* Ambient Temperature',
            isSmallScreen: isSmallScreen,
            onChanged: (value) => formData.ambientTemperature = value,
          ),
          const SizedBox(height: 16),

          // Damp Meter Make & Model
          _buildFinalizationTextField(
            controller: dampMeterMakeModelController,
            hintText: 'Enter* Damp Meter Make & Model',
            isSmallScreen: isSmallScreen,
            onChanged: (value) => formData.dampMeterMakeModel = value,
          ),
          const SizedBox(height: 16),

          // Service Technician Name
          _buildFinalizationTextField(
            controller: serviceTechnicianNameController,
            hintText: 'Enter* Service Technician Name',
            isSmallScreen: isSmallScreen,
            onChanged: (value) => formData.serviceTechnicianName = value,
          ),
          const SizedBox(height: 16),

          // Technician Signature
          _buildFinalizationTextField(
            controller: technicianSignatureController,
            hintText: 'Enter* Signature',
            isSmallScreen: isSmallScreen,
            onChanged: (value) => formData.technicianSignatureText = value,
          ),
          const SizedBox(height: 16),

          // Customer Signature
          _buildFinalizationTextField(
            controller: customerSignatureController,
            hintText: 'Enter* Customer Signature',
            isSmallScreen: isSmallScreen,
            onChanged: (value) => formData.customerSignatureText = value,
          ),
          const SizedBox(height: 16),

          // Date
          _buildDateField(isSmallScreen),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildFinalizationTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isSmallScreen,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: isSmallScreen ? 50 : 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          isDense: true,
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: isSmallScreen ? 14 : 16,
            fontFamily: _fontFamily,
          ),
        ),
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          fontFamily: _fontFamily,
        ),
        onChanged: onChanged,
      ),
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
                formData.date?.toIso8601String().split('T')[0] ??
                    'Enter* Date',
                style: TextStyle(
                  color: formData.date != null
                      ? Colors.black
                      : Colors.grey.shade600,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontFamily: _fontFamily,
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
      setState(() {
        formData.date = picked;
      });
    }
  }

  // ==================== MOTORHOME-LIKE PHOTO SECTIONS (Steps 3-8) ====================
  Widget _buildPhotoAttachmentSection(int sectionIndex, bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhotoSectionContainer(sectionIndex, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildPhotoSectionContainer(int sectionIndex, bool isSmallScreen) {
    final sectionInfo = sectionInstructions[sectionIndex];
    final sectionTitle = sectionInfo['title']!;
    final sectionImage = sectionInfo['image']!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: TextStyle(
              fontSize: isSmallScreen ? 23 : 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 25),
          
          // Show selected image if exists, otherwise show placeholder
          sectionImageBytes[sectionIndex] != null
              ? _buildSelectedImageContainer(sectionIndex, isSmallScreen)
              : _buildPhotoContainer(sectionImage, isSmallScreen),
          
          const SizedBox(height: 30),
          _buildAttachFileSection(sectionIndex),
          const SizedBox(height: 30),
          _buildCommentsField(sectionIndex, isSmallScreen),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPhotoContainer(String imagePath, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: isSmallScreen ? 180 : 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      height: 110,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/img.png",
                          height: 110,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImageContainer(int sectionIndex, bool isSmallScreen) {
    return Container(
      height: isSmallScreen ? 180 : 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.green.shade400,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.memory(
              sectionImageBytes[sectionIndex]!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Container(
            color: Colors.green.shade50,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    sectionImages[sectionIndex]?.name ?? 'Selected Image',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade800,
                      fontFamily: _fontFamily,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: Colors.red.shade600),
                  onPressed: () {
                    setState(() {
                      sectionImages[sectionIndex] = null;
                      sectionImageBytes[sectionIndex] = null;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachFileSection(int sectionIndex) {
    return GestureDetector(
      onTap: () => _pickImageFromGalleryForSection(sectionIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_file, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: sectionImages[sectionIndex] != null 
                            ? "Image Attached" 
                            : "Attach File",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PolySans',
                        ),
                      ),
                      if (sectionImages[sectionIndex] == null)
                        const TextSpan(
                          text: " *",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "File Type: JPEG, PNG, JPG",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
                fontFamily: _fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsField(int sectionIndex, bool isSmallScreen) {
    return TextField(
      maxLines: 5,
      controller: sectionCommentControllers[sectionIndex],
      onChanged: (value) {
        setState(() {
          sectionComments[sectionIndex] = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Enter* Comments (Optional)",
        hintStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: isSmallScreen ? 15 : 17,
          color: Colors.grey.shade600,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.8,
          ),
        ),
      ),
    );
  }

  // ==================== DIALOG METHODS ====================
  void _showGuidanceNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // Header Row (Bullet + Title + Close)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "• ",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Guidance Note",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: "PolySans",
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 26),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Divider line
                Container(
                  height: 1.2,
                  color: Colors.grey.shade300,
                ),

                const SizedBox(height: 12),

                // Scrollable text
                SizedBox(
                  height: 380,
                  child: SingleChildScrollView(
                    child: Text(
                      """
Moisture levels between 0-15% - no cause for concern, only readings of over 15% are recorded. Moisture levels between 15-20% - may require further investigation. Compare with average readings and consider a recheck after 3 months.

Moisture levels between 20-30% - will require further investigations to look for other possible indications of water ingress. Possible resealing required to avoid further degrading.

Moisture levels 30% and above – may indicate that structural damage or deterioration is occurring. Possible resealing required to avoid further degrading followed by immediate rectification action, as necessary.
                      """,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey.shade700,
                        fontFamily: "PolySans",
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
  }

  void _showPrecautionNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "• ",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Precaution Note",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: "PolySans",
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 26),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  height: 1.2,
                  color: Colors.grey.shade300,
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 380,
                  child: SingleChildScrollView(
                    child: Text(
                      """
We would emphasise that the above report accurately reflects the condition of your motorhome at the date stated. These readings may be subject to atmospheric conditions and the company cannot accept any liability for damp, which may become apparent at a future date. Completed in line with the latest AWS Damp Testing Matrix and carried out in accordance with the latest AWS service technician's handbook and manufacturers guidance in relation to areas required to test. Only the inside of the habitation unit is tested. Personal belongings will not be removed from lockers and storage areas, which therefore, may limit the scope of the damp report.
                      """,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey.shade700,
                        fontFamily: "PolySans",
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
  }

  // ==================== IMAGE PICKING METHODS ====================
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

  Future<void> _pickImageFromGalleryForSection(int sectionIndex) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          sectionImages[sectionIndex] = image;
          sectionImageBytes[sectionIndex] = bytes;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image "${image.name}" selected'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to select image'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // ==================== COMMON WIDGETS ====================
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
                Text(
                    stepTitles[index],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: _fontFamily,
                    color: isFilled ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
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
              onPressed: _exportToPdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
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
          'Are you sure you want to go back? Your progress may not be saved.',
          style: TextStyle(fontFamily: _fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
              Navigator.pop(context);
              Navigator.pop(context);
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

  // ==================== PDF EXPORT METHODS ====================
  Future<void> _exportToPdf() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Transfer all data to formData
      await _transferAllDataToFormData();
      
      // Get logo image bytes - use uploaded image if available, otherwise default
      final logoBytes = await _getLogoBytes();

      // Debug: Print what's being transferred
      print('=== GENERATING PDF WITH DATA ===');
      print('Customer Name: ${formData.customerName}');
      print('Registration: ${formData.registrationNumber}');
      print('Make & Model: ${formData.makeModel}');
      print('Workshop: ${formData.workshopName}');
      print('Job Reference: ${formData.jobReference}');
      print('Comments & Recommendations: ${formData.commentsRecommendations}');
      print('Uploaded Images: ${formData.uploadedImages.length}');
      print('Using uploaded image as logo: ${logoBytes != null && _selectedImage != null}');
      
      // Generate PDF with all collected data
      final pdfBytes = await TourerDampReportPdfService.generatePdf(
        formData,
        logoImageBytes: logoBytes,
      );
      
      // Save and share the PDF
      await _saveOrSharePdf(pdfBytes, formData);

      // Close loading dialog
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF generated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

    } catch (e, stackTrace) {
      print('PDF Export Error: $e');
      print('Stack Trace: $stackTrace');
      
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('PDF Generation Failed'),
          content: Text('Error: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveOrSharePdf(Uint8List pdfBytes, TourerDampModel formData) async {
    try {
      // Use the printing package to share the PDF
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'tourer-damp-report.pdf',
      );
      
      print('PDF shared successfully: ${pdfBytes.length} bytes');
      
    } catch (e) {
      print('Error sharing PDF: $e');
      throw Exception('Failed to share PDF: $e');
    }
  }

  Future<Uint8List?> _getLogoBytes() async {
    try {
      // Check if user uploaded an image in Step 0
      if (_selectedImage != null) {
        // Use the uploaded image as logo
        return await _selectedImage!.readAsBytes();
      } else {
        // Fall back to default logo
        final byteData = await rootBundle.load('assets/images/logo.png');
        return byteData.buffer.asUint8List();
      }
    } catch (e) {
      print('Error getting logo bytes: $e');
      return null;
    }
  }

  Future<void> _transferAllDataToFormData() async {
    // Transfer Step 0 data
    formData.workshopName = workshopNameController.text;
    formData.jobReference = jobReferenceController.text;
    
    // Clear existing uploaded images and add the single image
    formData.uploadedImages.clear();
    if (_selectedImage != null) {
      try {
        final bytes = await _selectedImage!.readAsBytes();
        formData.uploadedImages.add(bytes);
      } catch (e) {
        print('Error reading image bytes: $e');
      }
    }

    // Transfer Step 1 data
    formData.customerName = customerNameController.text;
    formData.makeModel = makeModelController.text;
    formData.registrationNumber = registrationNumberController.text;
    formData.crisVinNumber = crisVinNumberController.text;
    
    // Transfer Step 2 data
    formData.commentsRecommendations = commentsRecommendationsController.text;

    // Transfer Step 9 data
    formData.dampMeterCalibration = dampMeterCalibrationController.text;
    formData.weatherConditions = weatherConditionsController.text;
    formData.ambientTemperature = ambientTemperatureController.text;
    formData.dampMeterMakeModel = dampMeterMakeModelController.text;
    formData.serviceTechnicianName = serviceTechnicianNameController.text;
    formData.technicianSignatureText = technicianSignatureController.text;
    formData.customerSignatureText = customerSignatureController.text;

    // Initialize photoData structure
    formData.photoData = {
      'Front': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
      'Rear': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
      'Nearside': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
      'Offside': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
      'Ceiling': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
      'Floor': {'attachedFile': '', 'attachedFileBytes': null, 'comments': ''},
    };
    
    // Transfer photo section data (Steps 3-8) with COMMENTS
    for (int i = 0; i < sectionInstructions.length; i++) {
      final sectionKey = sectionInstructions[i]['key']!;
      final sectionComment = sectionCommentControllers[i].text;
      
      // Always update comments
      formData.photoData[sectionKey]!['comments'] = sectionComment;
      
      // Update image if exists
      if (sectionImages[i] != null && sectionImageBytes[i] != null) {
        formData.photoData[sectionKey]!['attachedFile'] = sectionImages[i]!.name;
        formData.photoData[sectionKey]!['attachedFileBytes'] = sectionImageBytes[i];
      }
    }
    
    // Debug: Print what's being transferred
    print('=== DATA TRANSFER COMPLETE ===');
    print('Comments & Recommendations: ${formData.commentsRecommendations}');
    print('Uploaded Images: ${formData.uploadedImages.length}');
    print('Photo Sections Data with Comments:');
    for (var entry in formData.photoData.entries) {
      final hasImage = entry.value['attachedFileBytes'] != null;
      final fileName = entry.value['attachedFile'] ?? 'No file';
      final comments = entry.value['comments'] ?? 'No comments';
      print('  ${entry.key}:');
      print('    Has Image: $hasImage');
      print('    File: "$fileName"');
      print('    Comments: "$comments"');
    }
  }
}