// import 'dart:typed_data';
// import 'package:data/models/engine_vehicle_model.dart';
// import 'package:data/services/engine_vehicle_pdf.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:printing/printing.dart';
// import 'dart:io';

// class EngineVehicleStepController extends GetxController {
//   var currentStep = 0.obs;
//   var stepStatus = <int, String>{}.obs; // Track step status
//   var isViewingFromSummary = false.obs; // Track if viewing from summary

//   void nextStep() {
//     if (currentStep.value < 2) {
//       // Now 3 steps: 0, 1, 2 (summary)
//       currentStep.value++;
//     }
//   }

//   void previousStep() {
//     if (currentStep.value > 0) {
//       currentStep.value--;
//     }
//   }

//   void goToStep(int step) {
//     if (step >= 0 && step <= 2) {
//       currentStep.value = step;
//     }
//   }

//   void markStepAsFilled(int step) {
//     stepStatus[step] = "Filled";
//   }

//   void markStepAsSkipped(int step) {
//     stepStatus[step] = "Skipped";
//   }

//   String getStepStatus(int step) {
//     return stepStatus[step] ?? "Not Started";
//   }

//   void setViewingFromSummary(bool value) {
//     isViewingFromSummary.value = value;
//   }
// }

// class EngineVehicleServiceForm extends StatefulWidget {
//   @override
//   _EngineVehicleServiceFormState createState() =>
//       _EngineVehicleServiceFormState();
// }

// class _EngineVehicleServiceFormState extends State<EngineVehicleServiceForm> {
//   final EngineVehicleModel formData = EngineVehicleModel();
//   final EngineVehicleStepController stepController = Get.put(
//     EngineVehicleStepController(),
//   );

//   // Image picker instance
//   final ImagePicker _imagePicker = ImagePicker();

//   // For image uploads
//   List<File> _selectedImages = [];
//   bool _isUploading = false;

//   final List<String> stepTitles = ['Customer Information', 'Mini Service Form'];

//   Map<String, String> selectedValues = {};
//   List<String> dropdownOptions = ["P", "F", "N/A", "R"];

//   // // Store selected values for each field
//   // Map<String, String> selectedValues = {
//   //   'Parts Included': '',
//   //   'Top-ups Included': '',
//   //   'General Checks': '',
//   //   'Internal/Vision': '',
//   //   'Engine': '',
//   //   'Brake': '',
//   //   'Wheels & Tyres': '',
//   //   'Steering & Suspension': '',
//   //   'Exhaust': '',
//   //   'Drive System': '',
//   // };

//   // final List<String> dropdownOptions = ["P", "F", "N/A", "R"];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize steps as "Skipped"
//     for (int i = 0; i < stepTitles.length; i++) {
//       stepController.markStepAsSkipped(i);
//     }

//     // Setup error handler for GetX navigation
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // This ensures any pending snackbars are cleared
//       if (Get.isSnackbarOpen) {
//         Get.closeCurrentSnackbar();
//       }
//     });
//   }

//   // Safe navigation back method to handle snackbar issues
// void _safeNavigateBack() {
//   try {
//     // Close any open dialog first
//     if (Navigator.canPop(context)) {
//       Navigator.pop(context);
//     }
    
//     // Then check if we need to show exit confirmation
//     if (stepController.currentStep.value == 0) {
//       _showExitConfirmation();
//     } else {
//       stepController.previousStep();
//     }
//   } catch (e) {
//     print('Error in safeNavigateBack: $e');
//     Get.back();
//   }
// }

//   void _collectFormData() {
//     print('=== ENGINE VEHICLE SERVICE DATA ===');
//     print('Customer Name: ${formData.customerName}');
//     print('Vehicle Registration: ${formData.vehicleRegistration}');
//     print('Mileage: ${formData.mileage}');
//     print('Comments: ${formData.comments}');
//     print('Mini Service Data: ${formData.miniServiceData}');
//     print('Selected Values: $selectedValues');
//     print('Selected Images: ${_selectedImages.length}');
//     print('======================');
//   }

//   // ==================== IMAGE PICKING METHODS ====================
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         setState(() {
//           _selectedImages.add(File(image.path));
//         });
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }

//   void _removeImage(int index) {
//     setState(() {
//       _selectedImages.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     bool isSmallScreen = width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//                     onPressed: _safeNavigateBack,
//                   ),
//                   const Spacer(),
//                   Container(
//                     width: isSmallScreen ? 170 : 220,
//                     height: isSmallScreen ? 70 : 80,
//                     child: Image.asset(
//                       'assets/images/logo.png',
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const Spacer(),
//                 ],
//               ),
//             ),

//             Obx(
//               () => Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 25,
//                   horizontal: 20,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(child: Container(height: 1, color: Colors.black)),
//                     const SizedBox(width: 10),
//                     Text(
//                       stepController.currentStep.value == 2
//                           ? '(SUMMARY)'
//                           : '(STEP ${stepController.currentStep.value + 1} OF ${stepTitles.length})',
//                       style: TextStyle(
//                         fontFamily: 'PolySans',
//                         fontSize: isSmallScreen ? 15 : 17,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(child: Container(height: 1, color: Colors.black)),
//                   ],
//                 ),
//               ),
//             ),

//             Expanded(
//               child: Container(
//                 color: const Color(0xFFF8F8F8),
//                 child: Obx(() {
//                   int currentStep = stepController.currentStep.value;
//                   if (currentStep == 2) {
//                     return _buildSummaryScreen(isSmallScreen);
//                   }
//                   return _buildStepContent(currentStep, width);
//                 }),
//               ),
//             ),

//             Obx(() {
//               bool isViewingFromSummary =
//                   stepController.isViewingFromSummary.value;
//               int currentStep = stepController.currentStep.value;

//               // If viewing from summary, show simplified buttons
//               if (isViewingFromSummary && currentStep < 2) {
//                 return Container(
//                   padding: const EdgeInsets.all(20),
//                   color: const Color(0xFFF8F8F8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // GO BACK TO SUMMARY BUTTON
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () {
//                             stepController.setViewingFromSummary(false);
//                             stepController.goToStep(2);
//                           },
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.black,
//                             side: BorderSide(color: Colors.black),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: isSmallScreen ? 20 : 30,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.arrow_back,
//                                 size: 16,
//                                 color: Colors.black,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 'Go Back',
//                                 style: TextStyle(
//                                   fontSize: isSmallScreen ? 14 : 16,
//                                   color: Colors.black,
//                                   fontFamily: 'PolySans',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 16),

//                       // PROCEED TO SUMMARY BUTTON
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             stepController.markStepAsFilled(currentStep);
//                             stepController.setViewingFromSummary(false);
//                             stepController.goToStep(2);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xff173EA6),
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: isSmallScreen ? 20 : 30,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             'Proceed Next',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 14 : 16,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'PolySans',
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               // Normal flow buttons
//               return Container(
//                 padding: const EdgeInsets.all(20),
//                 color: const Color(0xFFF8F8F8),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         if (currentStep > 0 && currentStep < 2)
//                           OutlinedButton(
//                             onPressed: stepController.previousStep,
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.black,
//                               side: BorderSide(color: Colors.black),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: isSmallScreen ? 30 : 40,
//                                 vertical: 12,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.arrow_back,
//                                   size: 16,
//                                   color: Colors.black,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'Go Back',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 14 : 16,
//                                     color: Colors.black,
//                                     fontFamily: 'PolySans',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         else if (currentStep == 0)
//                           OutlinedButton(
//                             onPressed: _showExitConfirmation,
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.black,
//                               side: BorderSide(color: Colors.black),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: isSmallScreen ? 30 : 40,
//                                 vertical: 12,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.arrow_back,
//                                   size: 16,
//                                   color: Colors.black,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   'Go Back',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 14 : 16,
//                                     color: Colors.black,
//                                     fontFamily: 'PolySans',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         else
//                           Container(),

//                         if (currentStep < 1) // Skip only for first step
//                           OutlinedButton(
//                             onPressed: () {
//                               stepController.markStepAsSkipped(currentStep);
//                               stepController.goToStep(currentStep + 1);
//                             },
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: const Color(0xff173EA6),
//                               side: BorderSide(color: const Color(0xff173EA6)),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: isSmallScreen ? 30 : 40,
//                                 vertical: 12,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               'Skip To Next',
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 14 : 16,
//                                 color: const Color(0xff173EA6),
//                                 fontFamily: 'PolySans',
//                               ),
//                             ),
//                           )
//                         else
//                           Container(),
//                       ],
//                     ),

//                     const SizedBox(height: 12),

//                     if (currentStep < 1)
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             stepController.markStepAsFilled(currentStep);
//                             stepController.nextStep();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xff173EA6),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 16,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             'Proceed Next',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 16 : 18,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'PolySans',
//                             ),
//                           ),
//                         ),
//                       )
//                     else if (currentStep == 1)
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             stepController.markStepAsFilled(1);
//                             stepController.goToStep(2);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xff173EA6),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 16,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             'View Summary',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 16 : 18,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'PolySans',
//                             ),
//                           ),
//                         ),
//                       )
//                     else
//                       Container(),
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryScreen(bool isSmallScreen) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // ---- STEP LIST ----
//           Column(
//             children: [
//               for (int i = 0; i < stepTitles.length; i++)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: _buildStepTile(i, isSmallScreen),
//                 ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           // ---- BOTTOM BUTTONS ----
//           Column(
//             children: [
//               // GO BACK
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     stepController.setViewingFromSummary(false);
//                     stepController.goToStep(1);
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: Colors.black),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.arrow_back, color: Colors.black),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Go Back",
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 16 : 18,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w700,
//                           fontFamily: "PolySans",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               // CREATE PDF WITH GRADIENT
//               SizedBox(
//                 width: double.infinity,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xff173EA6), Color(0xff091840)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: ElevatedButton(
//                     onPressed: _exportToPdf,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shadowColor: Colors.transparent,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: Text(
//                       "Create A PDF",
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: "PolySans",
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStepTile(int index, bool isSmallScreen) {
//     bool isFilled = stepController.stepStatus[index] == "Filled";

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
//       decoration: BoxDecoration(
//         color: isFilled ? const Color(0xff173EA6) : Colors.white,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(
//           color: isFilled ? Colors.transparent : Colors.black,
//           width: isFilled ? 0 : 1.4,
//         ),
//       ),
//       child: Row(
//         children: [
//           // STEP TITLE
//           Expanded(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "STEP ${index + 1}",
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 16 : 17,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: "PolySans",
//                     color: isFilled ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(width: 50),
//                 Text(
//                   isFilled ? "(Filled)" : "(Skipped)",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: "PolySans",
//                     color: isFilled ? Colors.white70 : Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // VIEW + ICON
//           GestureDetector(
//             onTap: () {
//               stepController.setViewingFromSummary(true);
//               stepController.goToStep(index);
//             },
//             child: Row(
//               children: [
//                 Text(
//                   "VIEW",
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 15 : 16,
//                     fontWeight: FontWeight.w800,
//                     fontFamily: "PolySans",
//                     color: isFilled ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 Icon(
//                   Icons.remove_red_eye_outlined,
//                   size: 20,
//                   color: isFilled ? Colors.white : Colors.black,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStepContent(int step, double width) {
//     bool isSmallScreen = width < 600;

//     switch (step) {
//       case 0:
//         return _buildCustomerInfoSection(isSmallScreen);
//       case 1:
//         return _buildMiniServiceSection(isSmallScreen);
//       default:
//         return Container();
//     }
//   }

//   Widget _buildCustomerInfoSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Customer Information',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 25),

//           _buildTextFieldWithHint(
//             'Enter* Customer Name',
//             (value) => formData.customerName = value,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithHint(
//             'Enter* Vehicle Registration',
//             (value) => formData.vehicleRegistration = value,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithHint(
//             'Enter* Mileage',
//             (value) => formData.mileage = value,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithHint(
//             'Enter* Date Of Inspection',
//             (value) => formData.dateOfInspection = value,
//             isSmallScreen,
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildMiniServiceSection(bool isSmallScreen) {
//     final items = [
//       "Parts Included*",
//       "Top-ups Included*",
//       "General Checks*",
//       "Internal/Vision*",
//       "Engine*",
//       "Brake*",
//       "Wheels & Tyres*",
//       "Steering & Suspension*",
//       "Exhaust*",
//       "Drive System*",
//     ];

//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Mini Service',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 15),

//           ...List.generate(items.length, (index) {
//             String item = items[index];
//             String cleanKey = item.replaceAll('*', '').trim();

//             return Padding(
//               padding: const EdgeInsets.only(bottom: 14),
//               child: Container(
//                 height: 55,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Row(
//                   children: [
//                     // LEFT LABEL
//                     Expanded(
//                       flex: 3,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Text(
//                           item,
//                           style: TextStyle(
//                             fontFamily: 'PolySans',
//                             fontSize: isSmallScreen ? 14 : 15,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ),

//                     // DROPDOWN (P / F / N/A / R)
//                     Container(
//                       width: 100,
//                       height: 100,
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         // borderRadius: BorderRadius.circular(6),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           value:
//                               selectedValues[cleanKey]?.isEmpty ?? true
//                                   ? null
//                                   : selectedValues[cleanKey],
//                           icon: const Icon(Icons.keyboard_arrow_down, size: 18),
//                           isExpanded: true,
//                           items:
//                               dropdownOptions.map((val) {
//                                 return DropdownMenuItem(
//                                   value: val,
//                                   child: Center(
//                                     child: Text(
//                                       val,
//                                       style: const TextStyle(
//                                         fontFamily: "PolySans",
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                         // In your _buildMiniServiceSection method, update the dropdown onChanged:
// onChanged: (value) {
//   setState(() {
//     selectedValues[cleanKey] = value!;
//     // Also save to model immediately
//     formData.setMainDropdownValue(cleanKey, value);
//   });
// },
//                         ),
//                       ),
//                     ),

//                     // const SizedBox(width: 10),

//                     // BLUE ICON BUTTON
//                     Container(
//                       width: 55,
//                       height: 100,
//                       decoration: const BoxDecoration(
//                         color: Color(0xff173EA6),
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(10),
//                           bottomRight: Radius.circular(10),
//                         ),
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.open_in_new,
//                           size: 22,
//                           color: Colors.white,
//                         ),
//                         onPressed: () => _showSelectionPopup(item),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),

//           const SizedBox(height: 20),
//           // Upload Box with Multiple Image Preview
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child:
//                 _isUploading
//                     ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const CircularProgressIndicator(),
//                           const SizedBox(height: 12),
//                           Text(
//                             "Uploading...",
//                             style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontFamily: 'PolySans',
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                     : Column(
//                       children: [
//                         Expanded(
//                           child:
//                               _selectedImages.isEmpty
//                                   ? InkWell(
//                                     onTap: _pickImage,
//                                     child: Center(
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Icon(
//                                                 Icons.attach_file,
//                                                 color: Colors.grey.shade600,
//                                               ),
//                                               SizedBox(width: 8),
//                                               Text(
//                                                 "Add* Attachments",
//                                                 style: TextStyle(
//                                                   color: Colors.grey.shade600,
//                                                   fontFamily: 'PolySans',
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             "File Type: JPG, PNG, JPEG",
//                                             style: TextStyle(
//                                               color: Colors.grey.shade500,
//                                               fontSize: 11,
//                                               fontFamily: 'PolySans',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                   : GridView.builder(
//                                     padding: const EdgeInsets.all(8),
//                                     gridDelegate:
//                                         const SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 2,
//                                           crossAxisSpacing: 8,
//                                           mainAxisSpacing: 8,
//                                         ),
//                                     itemCount: _selectedImages.length + 1,
//                                     itemBuilder: (context, index) {
//                                       if (index < _selectedImages.length) {
//                                         return Stack(
//                                           children: [
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               child: Image.file(
//                                                 _selectedImages[index],
//                                                 fit: BoxFit.cover,
//                                                 width: double.infinity,
//                                                 height: double.infinity,
//                                               ),
//                                             ),
//                                             Positioned(
//                                               top: 4,
//                                               right: 4,
//                                               child: GestureDetector(
//                                                 onTap:
//                                                     () => _removeImage(index),
//                                                 child: Container(
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                         color: Colors.black54,
//                                                         shape: BoxShape.circle,
//                                                       ),
//                                                   child: const Icon(
//                                                     Icons.close,
//                                                     color: Colors.white,
//                                                     size: 16,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       } else {
//                                         return InkWell(
//                                           onTap: _pickImage,
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                 color: Colors.grey.shade300,
//                                                 width: 2,
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                             child: Center(
//                                               child: Icon(
//                                                 Icons.add,
//                                                 size: 30,
//                                                 color: Colors.grey.shade500,
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                     },
//                                   ),
//                         ),
//                         if (_selectedImages.isNotEmpty)
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               'photo(s) added',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                                 fontFamily: 'PolySans',
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//           ),
//           const SizedBox(height: 20),

//           // COMMENT FIELD
//           TextField(
//             maxLines: 6,
//             onChanged: (value) => formData.comments = value,
//             decoration: InputDecoration(
//               hintText: "Enter* Comments (Optional)",
//               hintStyle: TextStyle(
//                 fontFamily: "PolySans",
//                 fontSize: isSmallScreen ? 14 : 16,
//                 color: Colors.grey.shade600,
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: const EdgeInsets.all(12),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1.4),
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildFormContainer(Widget child, bool isSmallScreen) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//       child: Container(
//         margin: EdgeInsets.all(isSmallScreen ? 8 : 16),
//         padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: child,
//       ),
//     );
//   }

//   Widget _buildTextFieldWithHint(
//     String hint,
//     Function(String) onChanged,
//     bool isSmallScreen,
//   ) {
//     return Container(
//       height: isSmallScreen ? 50 : 55,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: TextFormField(
//         decoration: InputDecoration(
//           hintText: hint,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//           isDense: true,
//           hintStyle: TextStyle(
//             color: Colors.grey.shade600,
//             fontSize: isSmallScreen ? 14 : 16,
//             fontFamily: 'PolySans',
//           ),
//         ),
//         style: TextStyle(
//           fontSize: isSmallScreen ? 14 : 16,
//           fontFamily: 'PolySans',
//         ),
//         onChanged: onChanged,
//       ),
//     );
//   }

// void _showSelectionPopup(String fieldName) {
//   String cleanFieldName = fieldName.replaceAll('*', '').trim();

//   Map<String, List<String>> fieldOptions = {
//     'Parts Included': ['Engine Oil', 'Oil Filter'],
//     'Top-ups Included': [
//       'Windscreen Additive',
//       'Coolant',
//       'Brake Fluid',
//       'Power Steering Fluid',
//     ],
//     'General Checks': ['External Lights', 'Instrument warning'],
//     'Internal/Vision': ['Condition of Windscreen', 'Wiper and Washers'],
//     'Engine': ['General Oil Leaks', 'Antifreeze Strength', 'Timing Belt'],
//     'Brake': ['Visual Check of brake pads'],
//     'Wheels & Tyres': ['Tyre Condition', 'Tyre Pressure'],
//     'Steering & Suspension': ['Steering Rack condition'],
//     'Exhaust': ['Exhaust condition'],
//     'Drive System': ['Clutch Fluid level', 'Transmission oil'],
//   };

//   List<String> options = fieldOptions[cleanFieldName] ?? ['Check 1', 'Check 2', 'Check 3'];

//   Map<String, String> tempSelections = {};
//   final currentData = formData.miniServiceData[cleanFieldName] ?? {};
//   for (var option in options) {
//     if (currentData.containsKey(option)) {
//       tempSelections[option] = currentData[option]!;
//     }
//   }

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setModalState) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             insetPadding: const EdgeInsets.all(20),
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Select Options",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontFamily: "PolySans",
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.close, size: 22),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                   // const SizedBox(height: 10),
//                   // Text(
//                   //   "Select values for each item:",
//                   //   style: TextStyle(
//                   //     fontSize: 14,
//                   //     fontFamily: "PolySans",
//                   //     color: Colors.grey.shade700,
//                   //   ),
//                   // ),
//                   const SizedBox(height: 15),

//                   ...options.map((option) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               option,
//                               style: TextStyle(
//                                 fontFamily: "PolySans",
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Container(
//                             width: 80,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: tempSelections[option]?.isNotEmpty == true 
//                                     ? tempSelections[option] 
//                                     : null,
//                                 hint: Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 8),
//                                   child: Text(
//                                     "Select",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade600,
//                                       fontFamily: "PolySans",
//                                     ),
//                                   ),
//                                 ),
//                                 isExpanded: true,
//                                 items: dropdownOptions.map((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Center(
//                                       child: Text(
//                                         value,
//                                         style: TextStyle(
//                                           fontFamily: "PolySans",
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? newValue) {
//                                   setModalState(() {
//                                     if (newValue == null) {
//                                       tempSelections.remove(option);
//                                     } else {
//                                       tempSelections[option] = newValue;
//                                     }
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   const SizedBox(height: 18),

//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Save detailed items data (action button selections)
//                         formData.addMiniServiceData(
//                           cleanFieldName,
//                           Map.from(tempSelections),
//                         );
                        
//                         // DO NOT change the main dropdown value - keep what user selected
//                         // The main dropdown value is already stored in selectedValues[cleanFieldName]
//                         // and should be saved separately to formData.mainDropdownValues
                        
//                         // Save main dropdown value if it exists
//                         String mainDropdownValue = selectedValues[cleanFieldName] ?? "";
//                         if (mainDropdownValue.isNotEmpty) {
//                           formData.setMainDropdownValue(cleanFieldName, mainDropdownValue);
//                         }

//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xff173EA6),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         "Save",
//                         style: TextStyle(
//                           fontFamily: "PolySans",
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

//  void _showExitConfirmation() {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (context) => AlertDialog(
//       title: Text('Exit Form?', style: TextStyle(fontFamily: 'PolySans')),
//       content: Text(
//         'Are you sure you want to go back? Your progress may not be saved.',
//         style: TextStyle(fontFamily: 'PolySans'),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(
//             'Cancel',
//             style: TextStyle(
//               color: Colors.grey.shade600,
//               fontFamily: 'PolySans',
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//             Get.back();
//           },
//           child: Text(
//             'Exit',
//             style: TextStyle(
//               color: const Color(0xff173EA6),
//               fontFamily: 'PolySans',
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

//   void _exportToPdf() async {
//     try {
//       _collectFormData();

//       // Show loading
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(child: CircularProgressIndicator()),
//       );

//       // Add image bytes to formData
//       List<Uint8List> imageBytesList = [];
//       for (var image in _selectedImages) {
//         try {
//           final bytes = await image.readAsBytes();
//           imageBytesList.add(bytes);
//         } catch (e) {
//           print('Error reading image bytes: $e');
//         }
//       }

//       final ByteData byteData = await rootBundle.load('assets/images/logo.png');
//       final Uint8List logoBytes = byteData.buffer.asUint8List();

//       final pdfBytes = await EngineVehiclePdfService.generatePdf(
//         formData,
//         logoImageBytes: logoBytes,
//         images: imageBytesList,
//       );

//       // Close loading dialog
//       if (Navigator.canPop(context)) {
//         Navigator.of(context).pop();
//       }

//       await Printing.sharePdf(
//         bytes: pdfBytes,
//         filename:
//             'mini-vehicle-service.pdf',
//       );

//       Get.snackbar(
//         'Success',
//         'PDF exported successfully',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('PDF Export Error: $e');

//       // Close loading dialog if open
//       if (Navigator.canPop(context)) {
//         Navigator.of(context).pop();
//       }

//       showDialog(
//         context: context,
//         builder:
//             (context) => AlertDialog(
//               title: const Text('Export Error'),
//               content: Text('Failed to generate PDF: $e'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('OK'),
//                 ),
//               ],
//             ),
//       );
//     }
//   }
// }


import 'dart:typed_data';
import 'package:data/models/engine_vehicle_model.dart';
import 'package:data/services/engine_vehicle_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import 'dart:io';

class EngineVehicleStepController extends GetxController {
  var currentStep = 0.obs;
  var stepStatus = <int, String>{}.obs; // Track step status
  var isViewingFromSummary = false.obs; // Track if viewing from summary

  void nextStep() {
    if (currentStep.value < 2) {
      // Now 3 steps: 0, 1, 2 (summary)
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
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

class EngineVehicleServiceForm extends StatefulWidget {
  @override
  _EngineVehicleServiceFormState createState() =>
      _EngineVehicleServiceFormState();
}

class _EngineVehicleServiceFormState extends State<EngineVehicleServiceForm> {
  final EngineVehicleModel formData = EngineVehicleModel();
  final EngineVehicleStepController stepController = Get.put(
    EngineVehicleStepController(),
  );

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  // For image uploads
  List<File> _selectedImages = [];
  bool _isUploading = false;

  final List<String> stepTitles = ['Customer Information', 'Mini Service Form'];

  Map<String, String> selectedValues = {};
  List<String> dropdownOptions = ["P", "F", "N/A", "R"];

  // Text editing controllers for all text fields
  // Customer Information (Step 0)
  late TextEditingController customerNameController;
  late TextEditingController vehicleRegistrationController;
  late TextEditingController mileageController;
  late TextEditingController dateOfInspectionController;
  
  // Comments field (Step 1)
  late TextEditingController commentsController;

  @override
  void initState() {
    super.initState();
    // Initialize steps as "Skipped"
    for (int i = 0; i < stepTitles.length; i++) {
      stepController.markStepAsSkipped(i);
    }

    // Initialize text controllers with formData values
    // Customer Information (Step 0)
    customerNameController = TextEditingController(text: formData.customerName);
    vehicleRegistrationController = TextEditingController(text: formData.vehicleRegistration);
    mileageController = TextEditingController(text: formData.mileage);
    dateOfInspectionController = TextEditingController(text: formData.dateOfInspection);
    
    // Comments field (Step 1)
    commentsController = TextEditingController(text: formData.comments);
    
    // Add listeners to update formData when text changes
    // Customer Information (Step 0)
    customerNameController.addListener(() => formData.customerName = customerNameController.text);
    vehicleRegistrationController.addListener(() => formData.vehicleRegistration = vehicleRegistrationController.text);
    mileageController.addListener(() => formData.mileage = mileageController.text);
    dateOfInspectionController.addListener(() => formData.dateOfInspection = dateOfInspectionController.text);
    
    // Comments field (Step 1)
    commentsController.addListener(() => formData.comments = commentsController.text);

    // Setup error handler for GetX navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This ensures any pending snackbars are cleared
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    customerNameController.dispose();
    vehicleRegistrationController.dispose();
    mileageController.dispose();
    dateOfInspectionController.dispose();
    commentsController.dispose();
    super.dispose();
  }

  // Safe navigation back method to handle snackbar issues
  void _safeNavigateBack() {
    try {
      // Close any open dialog first
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Then check if we need to show exit confirmation
      if (stepController.currentStep.value == 0) {
        _showExitConfirmation();
      } else {
        stepController.previousStep();
      }
    } catch (e) {
      print('Error in safeNavigateBack: $e');
   
                      Get.back();
    }
  }

  void _collectFormData() {
    print('=== ENGINE VEHICLE SERVICE DATA ===');
    print('Customer Name: ${formData.customerName}');
    print('Vehicle Registration: ${formData.vehicleRegistration}');
    print('Mileage: ${formData.mileage}');
    print('Date of Inspection: ${formData.dateOfInspection}');
    print('Comments: ${formData.comments}');
    print('Mini Service Data: ${formData.miniServiceData}');
    print('Selected Values: $selectedValues');
    print('Selected Images: ${_selectedImages.length}');
    print('======================');
  }

  // ==================== IMAGE PICKING METHODS ====================
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
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
 // Update your IconButton in the build method:
IconButton(
  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
  onPressed: _showExitConfirmation, // Always show exit confirmation
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
                      stepController.currentStep.value == 2
                          ? '(SUMMARY)'
                          : '(STEP ${stepController.currentStep.value + 1} OF ${stepTitles.length})',
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
                  if (currentStep == 2) {
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
              if (isViewingFromSummary && currentStep < 2) {
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
                            stepController.goToStep(2);
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
                            stepController.goToStep(2);
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
                        if (currentStep > 0 && currentStep < 2)
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

                        if (currentStep < 1) // Skip only for first step
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

                    if (currentStep < 1)
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
                    else if (currentStep == 1)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            stepController.markStepAsFilled(1);
                            stepController.goToStep(2);
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
                      Container(),
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
                    stepController.goToStep(1);
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

              const SizedBox(height: 18),

              // CREATE PDF WITH GRADIENT
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff173EA6), Color(0xff091840)],
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
                        fontFamily: "PolySans",
                        color: Colors.white,
                      ),
                    ),
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
                  "STEP ${index + 1}",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: "PolySans",
                    color: isFilled ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 50),
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

  Widget _buildStepContent(int step, double width) {
    bool isSmallScreen = width < 600;

    switch (step) {
      case 0:
        return _buildCustomerInfoSection(isSmallScreen);
      case 1:
        return _buildMiniServiceSection(isSmallScreen);
      default:
        return Container();
    }
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

          _buildTextFieldWithHint(
            'Enter* Customer Name',
            customerNameController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithHint(
            'Enter* Vehicle Registration',
            vehicleRegistrationController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithHint(
            'Enter* Mileage',
            mileageController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithHint(
            'Enter* Date Of Inspection',
            dateOfInspectionController,
            isSmallScreen,
          ),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildMiniServiceSection(bool isSmallScreen) {
    final items = [
      "Parts Included*",
      "Top-ups Included*",
      "General Checks*",
      "Internal/Vision*",
      "Engine*",
      "Brake*",
      "Wheels & Tyres*",
      "Steering & Suspension*",
      "Exhaust*",
      "Drive System*",
    ];

    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mini Service',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 15),

          ...List.generate(items.length, (index) {
            String item = items[index];
            String cleanKey = item.replaceAll('*', '').trim();

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    // LEFT LABEL
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontFamily: 'PolySans',
                            fontSize: isSmallScreen ? 14 : 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    // DROPDOWN (P / F / N/A / R)
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedValues[cleanKey]?.isEmpty ?? true
                              ? null
                              : selectedValues[cleanKey],
                          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                          isExpanded: true,
                          items: dropdownOptions.map((val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Center(
                                child: Text(
                                  val,
                                  style: const TextStyle(
                                    fontFamily: "PolySans",
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedValues[cleanKey] = value!;
                              // Also save to model immediately
                              formData.setMainDropdownValue(cleanKey, value);
                            });
                          },
                        ),
                      ),
                    ),

                    // const SizedBox(width: 10),

                    // BLUE ICON BUTTON
                    Container(
                      width: 55,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xff173EA6),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.open_in_new,
                          size: 22,
                          color: Colors.white,
                        ),
                        onPressed: () => _showSelectionPopup(item),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),
          // Upload Box with Multiple Image Preview
          Container(
            height: 200,
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
                : Column(
                    children: [
                      Expanded(
                        child: _selectedImages.isEmpty
                            ? InkWell(
                                onTap: _pickImage,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      const SizedBox(height: 4),
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
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: _selectedImages.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < _selectedImages.length) {
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            _selectedImages[index],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () => _removeImage(index),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: _pickImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            size: 30,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                      if (_selectedImages.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'photo(s) added',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'PolySans',
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 20),

          // COMMENT FIELD
          TextField(
            controller: commentsController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: "Enter* Comments (Optional)",
              hintStyle: TextStyle(
                fontFamily: "PolySans",
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.grey.shade600,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.4),
              ),
            ),
          ),

          const SizedBox(height: 20),
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

  Widget _buildTextFieldWithHint(
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
    );
  }

  void _showSelectionPopup(String fieldName) {
    String cleanFieldName = fieldName.replaceAll('*', '').trim();

    Map<String, List<String>> fieldOptions = {
      'Parts Included': ['Engine Oil', 'Oil Filter'],
      'Top-ups Included': [
        'Windscreen Additive',
        'Coolant',
        'Brake Fluid',
        'Power Steering Fluid',
      ],
      'General Checks': ['External Lights', 'Instrument warning'],
      'Internal/Vision': ['Condition of Windscreen', 'Wiper and Washers'],
      'Engine': ['General Oil Leaks', 'Antifreeze Strength', 'Timing Belt'],
      'Brake': ['Visual Check of brake pads'],
      'Wheels & Tyres': ['Tyre Condition', 'Tyre Pressure'],
      'Steering & Suspension': ['Steering Rack condition'],
      'Exhaust': ['Exhaust condition'],
      'Drive System': ['Clutch Fluid level', 'Transmission oil'],
    };

    List<String> options = fieldOptions[cleanFieldName] ?? ['Check 1', 'Check 2', 'Check 3'];

    Map<String, String> tempSelections = {};
    final currentData = formData.miniServiceData[cleanFieldName] ?? {};
    for (var option in options) {
      if (currentData.containsKey(option)) {
        tempSelections[option] = currentData[option]!;
      }
    }

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
                          "Select Options",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "PolySans",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   "Select values for each item:",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontFamily: "PolySans",
                    //     color: Colors.grey.shade700,
                    //   ),
                    // ),
                    const SizedBox(height: 15),

                    ...options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontFamily: "PolySans",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: tempSelections[option]?.isNotEmpty == true 
                                      ? tempSelections[option] 
                                      : null,
                                  hint: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontFamily: "PolySans",
                                      ),
                                    ),
                                  ),
                                  isExpanded: true,
                                  items: dropdownOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Center(
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            fontFamily: "PolySans",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setModalState(() {
                                      if (newValue == null) {
                                        tempSelections.remove(option);
                                      } else {
                                        tempSelections[option] = newValue;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Save detailed items data (action button selections)
                          formData.addMiniServiceData(
                            cleanFieldName,
                            Map.from(tempSelections),
                          );
                          
                          // DO NOT change the main dropdown value - keep what user selected
                          // The main dropdown value is already stored in selectedValues[cleanFieldName]
                          // and should be saved separately to formData.mainDropdownValues
                          
                          // Save main dropdown value if it exists
                          String mainDropdownValue = selectedValues[cleanFieldName] ?? "";
                          if (mainDropdownValue.isNotEmpty) {
                            formData.setMainDropdownValue(cleanFieldName, mainDropdownValue);
                          }

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

  void _showExitConfirmation() {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: Text('Exit Form?', style: TextStyle(fontFamily: 'PolySans')),
      content: const Text(
        'Are you sure you want to go back? Your progress may not be saved.',
        style: TextStyle(fontFamily: 'PolySans'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Just close dialog
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
            // First close the dialog
            Navigator.pop(context);
            // Then exit the form page
            Navigator.pop(context);
          },
          child: Text(
            'Exit',
            style: TextStyle(
              color: const Color(0xff173EA6),
              fontFamily: 'PolySans',
            ),
          ),
        ),
      ],
    ),
  );
}

  void _exportToPdf() async {
    try {
      _collectFormData();

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Add image bytes to formData
      List<Uint8List> imageBytesList = [];
      for (var image in _selectedImages) {
        try {
          final bytes = await image.readAsBytes();
          imageBytesList.add(bytes);
        } catch (e) {
          print('Error reading image bytes: $e');
        }
      }

      final ByteData byteData = await rootBundle.load('assets/images/logo.png');
      final Uint8List logoBytes = byteData.buffer.asUint8List();

      final pdfBytes = await EngineVehiclePdfService.generatePdf(
        formData,
        logoImageBytes: logoBytes,
        images: imageBytesList,
      );

      // Close loading dialog
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'mini-vehicle-service.pdf',
      );

      Get.snackbar(
        'Success',
        'PDF exported successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('PDF Export Error: $e');

      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Error'),
          content: Text('Failed to generate PDF: $e'),
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
}
