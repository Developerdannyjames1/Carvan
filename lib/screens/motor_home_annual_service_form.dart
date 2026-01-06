import 'dart:typed_data';
import 'package:data/models/motor_home_annual_service_model.dart';
import 'package:data/services/motor_home_annual_service_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:image_picker/image_picker.dart';

// Controller class remains the same
class MotorHomeAnnualServiceStepController extends GetxController {
  var currentStep = 0.obs;
  var stepStatus = <int, String>{}.obs;
  var isViewingFromSummary = false.obs;
  
  final int totalSteps = 6;

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

class MotorHomeAnnualServiceForm extends StatefulWidget {
  const MotorHomeAnnualServiceForm({super.key});

  @override
  State<MotorHomeAnnualServiceForm> createState() => _MotorHomeAnnualServiceFormState();
}

class _MotorHomeAnnualServiceFormState extends State<MotorHomeAnnualServiceForm> {
  // Controllers
  final MotorHomeAnnualServiceStepController stepController = Get.put(
    MotorHomeAnnualServiceStepController(),
  );

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  // Data models
  final MotorHomeAnnualServiceModel formData = MotorHomeAnnualServiceModel();
  final List<PhotoSectionData> sectionData = List.generate(4, (_) => PhotoSectionData());
  final List<String> finalAttachments = [];
  String finalComments = '';

  // Track selected images for each section
  List<XFile?> sectionImages = List.generate(4, (_) => null);
  List<Uint8List?> sectionImageBytes = List.generate(4, (_) => null);

  // Track selected images for final attachments
  List<XFile> finalAttachmentImages = [];
  List<Uint8List> finalAttachmentImageBytes = [];

  // Text editing controllers for customer info fields
  late TextEditingController vehicleRegistrationController;
  late TextEditingController mileageController;
  late TextEditingController makeModelController;
  late TextEditingController dateOfInspectionController;
  late TextEditingController operatorController;
  
  // Text editing controllers for photo section comments (4 sections)
  late TextEditingController frontPhotoCommentsController;
  late TextEditingController rearPhotoCommentsController;
  late TextEditingController nearsidePhotoCommentsController;
  late TextEditingController offsidePhotoCommentsController;
  
  // Text editing controller for final comments
  late TextEditingController finalCommentsController;

  // Constants
  static const _backgroundColor = Color(0xFFF8F8F8);
  static const _primaryColor = Color(0xff173EA6);
  static const _secondaryColor = Color(0xff091840);
  static const _fontFamily = 'PolySans';

  // Step titles
  final List<String> stepTitles = [
    'Customer Information',
    'Attach Front Photo',
    'Attach Rear Photo',
    'Attach Nearside Photo',
    'Attach Offside Photo',
    'Attachments',
  ];

  // Section data with titles and image assets
  final List<Map<String, String>> sectionInstructions = [
    {
      'title': 'Attach Front Photo',
      'image': 'assets/images/img.png', 
    },
    {
      'title': 'Attach Rear Photo',
      'image': 'assets/images/img2.png', 
    },
    {
      'title': 'Attach Nearside Photo',
      'image': 'assets/images/img4.png', 
    },
    {
      'title': 'Attach Offside Photo',
      'image': 'assets/images/img3.png', 
    },
  ];

  @override
  void initState() {
    super.initState();
    stepController.initializeSteps();
    
    // Initialize text controllers with formData values
    vehicleRegistrationController = TextEditingController(text: formData.vehicleRegistration);
    mileageController = TextEditingController(text: formData.mileage);
    makeModelController = TextEditingController(text: formData.makeModel);
    dateOfInspectionController = TextEditingController(text: formData.dateOfInspection);
    operatorController = TextEditingController(text: formData.operator);
    
    // Initialize comment controllers with sectionData values
    frontPhotoCommentsController = TextEditingController(text: sectionData[0].comments);
    rearPhotoCommentsController = TextEditingController(text: sectionData[1].comments);
    nearsidePhotoCommentsController = TextEditingController(text: sectionData[2].comments);
    offsidePhotoCommentsController = TextEditingController(text: sectionData[3].comments);
    
    // Initialize final comments controller
    finalCommentsController = TextEditingController(text: finalComments);
    
    // Add listeners to update formData when text changes
    vehicleRegistrationController.addListener(() {
      formData.vehicleRegistration = vehicleRegistrationController.text;
    });
    mileageController.addListener(() {
      formData.mileage = mileageController.text;
    });
    makeModelController.addListener(() {
      formData.makeModel = makeModelController.text;
    });
    dateOfInspectionController.addListener(() {
      formData.dateOfInspection = dateOfInspectionController.text;
    });
    operatorController.addListener(() {
      formData.operator = operatorController.text;
    });
    
    // Add listeners for comment fields
    frontPhotoCommentsController.addListener(() {
      sectionData[0].comments = frontPhotoCommentsController.text;
    });
    rearPhotoCommentsController.addListener(() {
      sectionData[1].comments = rearPhotoCommentsController.text;
    });
    nearsidePhotoCommentsController.addListener(() {
      sectionData[2].comments = nearsidePhotoCommentsController.text;
    });
    offsidePhotoCommentsController.addListener(() {
      sectionData[3].comments = offsidePhotoCommentsController.text;
    });
    
    // Add listener for final comments
    finalCommentsController.addListener(() {
      finalComments = finalCommentsController.text;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    vehicleRegistrationController.dispose();
    mileageController.dispose();
    makeModelController.dispose();
    dateOfInspectionController.dispose();
    operatorController.dispose();
    frontPhotoCommentsController.dispose();
    rearPhotoCommentsController.dispose();
    nearsidePhotoCommentsController.dispose();
    offsidePhotoCommentsController.dispose();
    finalCommentsController.dispose();
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
            onPressed: () {
                      Get.back();
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
        return _buildCustomerInfoSection(isSmallScreen);
      case 1:
        return _buildPhotoAttachmentSection(0, isSmallScreen);
      case 2:
        return _buildPhotoAttachmentSection(1, isSmallScreen);
      case 3:
        return _buildPhotoAttachmentSection(2, isSmallScreen);
      case 4:
        return _buildPhotoAttachmentSection(3, isSmallScreen);
      case 5:
        return _buildFinalAttachmentsSection(isSmallScreen);
      default:
        return Container();
    }
  }

  // ==================== STEP 0: CUSTOMER INFO ====================
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
          _buildTextFieldWithController(
            'Enter* Vehicle Registration',
            vehicleRegistrationController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Odometer Reading',
            mileageController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Make & Type',
            makeModelController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Date Of Inspection',
            dateOfInspectionController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Operator',
            operatorController,
            isSmallScreen,
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  // ==================== STEP 1-4: PHOTO ATTACHMENT ====================
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
          _buildSectionTitle(sectionTitle, isSmallScreen),
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

  Widget _buildSectionTitle(String title, bool isSmallScreen) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isSmallScreen ? 23 : 25,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: _fontFamily,
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
    // Get the appropriate controller for this section
    TextEditingController controller;
    switch (sectionIndex) {
      case 0:
        controller = frontPhotoCommentsController;
        break;
      case 1:
        controller = rearPhotoCommentsController;
        break;
      case 2:
        controller = nearsidePhotoCommentsController;
        break;
      case 3:
        controller = offsidePhotoCommentsController;
        break;
      default:
        controller = frontPhotoCommentsController;
    }
    
    return TextField(
      maxLines: 5,
      controller: controller,
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

  // ==================== STEP 5: FINAL ATTACHMENTS ====================
  Widget _buildFinalAttachmentsSection(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFinalAttachmentsContainer(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildFinalAttachmentsContainer(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttachmentsTitle(isSmallScreen),
          const SizedBox(height: 25),
          
          // Show attached images list
          if (finalAttachmentImages.isNotEmpty)
            _buildAttachedImagesList(isSmallScreen),
          
          _buildAttachmentsBox(isSmallScreen),
          
          // Show image count
          if (finalAttachmentImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                '${finalAttachmentImages.length} image(s) attached',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 14,
                  fontFamily: _fontFamily,
                ),
              ),
            ),
          
          const SizedBox(height: 30),
          _buildFinalCommentsField(isSmallScreen),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAttachedImagesList(bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: finalAttachmentImages.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: Icon(Icons.image, color: Colors.blue.shade700),
            ),
            title: Text(
              finalAttachmentImages[index].name,
              style: TextStyle(
                fontSize: 14,
                fontFamily: _fontFamily,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: () {
                setState(() {
                  finalAttachmentImages.removeAt(index);
                  finalAttachmentImageBytes.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttachmentsTitle(bool isSmallScreen) {
    return Text(
      "Attachments",
      style: TextStyle(
        fontSize: isSmallScreen ? 20 : 22,
        fontWeight: FontWeight.w700,
        fontFamily: _fontFamily,
      ),
    );
  }

  Widget _buildAttachmentsBox(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 28 : 32,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImagesFromGalleryForFinalAttachments,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_file, size: 22, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Add",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isSmallScreen ? 16 : 17,
                          fontFamily: _fontFamily,
                        ),
                      ),
                      const TextSpan(
                        text: "* ",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "Attachments",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isSmallScreen ? 16 : 17,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "File Type: JPEG, PNG, JPG",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: isSmallScreen ? 13 : 14,
              fontFamily: _fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalCommentsField(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
      ),
      child: TextField(
        maxLines: 6,
        controller: finalCommentsController,
        decoration: InputDecoration(
          hintText: "Enter* Comments (Optional)",
          hintStyle: TextStyle(
            fontFamily: _fontFamily,
            fontSize: isSmallScreen ? 15 : 16,
            color: Colors.grey.shade600,
          ),
          contentPadding: const EdgeInsets.all(18),
          border: InputBorder.none,
        ),
      ),
    );
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

  Widget _buildTextFieldWithController(
    String hint,
    TextEditingController controller,
    bool isSmallScreen,
  ) {
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
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  // ==================== ATTACHMENT METHODS ====================
  Future<void> _pickImageFromGalleryForSection(int sectionIndex) async {
  try {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,  // Reduce size for PDF
      maxHeight: 800,
      imageQuality: 70,  // Lower quality for smaller PDF
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        sectionImages[sectionIndex] = image;
        sectionImageBytes[sectionIndex] = bytes;
        sectionData[sectionIndex].attachedFile = image.name;
      });
      
      print('Image selected for section $sectionIndex: ${image.name}, bytes: ${bytes.length}');
      
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
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

  Future<void> _pickImagesFromGalleryForFinalAttachments() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        for (var image in images) {
          final bytes = await image.readAsBytes();
          setState(() {
            finalAttachmentImages.add(image);
            finalAttachmentImageBytes.add(bytes);
          });
        }
        Get.snackbar(
          'Success',
          '${images.length} image(s) added to attachments',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error picking images: $e');
      Get.snackbar(
        'Error',
        'Failed to select images',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
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

  Future<void> _exportToPdf() async {
  try {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Transfer ALL data to formData before generating PDF
    await _transferAllDataToFormData();

    // Debug: Print formData to see what's being passed
    print('Form Data for PDF: ${formData.toJson()}');
    print('Photo Data: ${formData.photoData}');
    print('Final Attachments: ${formData.finalAttachments}');
    print('Final Comments: ${formData.finalComments}');

    // Load logo
    final ByteData logoData = await rootBundle.load('assets/images/logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Generate PDF
    final pdfBytes = await MotorHomeAnnualServicePdfService.generatePdf(
      formData,
      logoImageBytes: logoBytes,
    );

    // Close loading dialog
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }

    // Share/Print the PDF
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'motorhome-service-${DateTime.now().millisecondsSinceEpoch}.pdf',
    );

    // Show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF created successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

  } catch (e) {
    print('PDF Export Error: $e');
    
    // Close loading dialog
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to generate PDF: ${e.toString()}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

Future<void> _transferAllDataToFormData() async {
  // Transfer photo section data
  final photoSectionTitles = ['Front', 'Rear', 'Nearside', 'Offside'];
  
  for (int i = 0; i < sectionData.length; i++) {
    final title = photoSectionTitles[i];
    final data = sectionData[i];
    
    // Get attached file name and bytes
    String? attachedFileName;
    Uint8List? attachedFileBytes;
    
    if (sectionImages[i] != null) {
      attachedFileName = sectionImages[i]!.name;
      // Get the image bytes
      if (sectionImageBytes[i] != null) {
        attachedFileBytes = sectionImageBytes[i];
      }
    }
    
    // Determine if O/S and N/S photos exist
    bool hasOSPhoto = data.osPhoto != null && (data.osPhoto as Uint8List).isNotEmpty;
    bool hasNSPhoto = data.nsPhoto != null && (data.nsPhoto as Uint8List).isNotEmpty;
    
    // Update formData.photoData with image bytes
    formData.photoData[title] = {
      'osPhoto': hasOSPhoto ? data.osPhoto : null,
      'nsPhoto': hasNSPhoto ? data.nsPhoto : null,
      'attachedFile': attachedFileName,
      'attachedFileBytes': attachedFileBytes, // Store image bytes
      'comments': data.comments,
    };
    
    print('Added to photoData[$title]: image bytes: ${attachedFileBytes != null ? 'YES' : 'NO'}');
  }

  // Transfer final attachments WITH bytes
  formData.finalAttachments.clear();
  formData.finalAttachmentBytes.clear();
  
  for (var image in finalAttachmentImages) {
    if (image.name.isNotEmpty) {
      formData.finalAttachments.add(image.name);
      
      // Get image bytes
      try {
        final bytes = await image.readAsBytes();
        formData.finalAttachmentBytes.add(bytes);
        print('Added final attachment with bytes: ${image.name}');
      } catch (e) {
        print('Error reading final attachment bytes: $e');
        formData.finalAttachmentBytes.add(null);
      }
    }
  }

  // Transfer final comments (always save, even if empty)
  formData.finalComments = finalComments;
}
}

// ==================== HELPER CLASSES ====================
class PhotoSectionData {
  Uint8List? osPhoto;
  Uint8List? nsPhoto;
  String? attachedFile;
  String comments = '';

  void setPhoto(String type, Uint8List photo) {
    if (type == 'osPhoto') {
      osPhoto = photo;
    } else if (type == 'nsPhoto') {
      nsPhoto = photo;
    }
  }
}
