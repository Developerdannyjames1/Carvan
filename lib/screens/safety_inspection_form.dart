// import 'package:data/models/safety_inspection_model.dart';
// import 'package:data/services/safety_inspection_pdf.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:printing/printing.dart';

// class SafetyInspectionStepController extends GetxController {
//   var currentStep = 0.obs;
//   var stepStatus = <int, String>{}.obs;
//   var isViewingFromSummary = false.obs; // Track if viewing from summary

//   void nextStep() {
//     if (currentStep.value < 8) {
//       currentStep.value++;
//     }
//   }

//   void previousStep() {
//     if (currentStep.value > 0) {
//       currentStep.value--;
//     }
//   }

//   void goToStep(int step) {
//     if (step >= 0 && step <= 9) {
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

// class SafetyInspectionForm extends StatefulWidget {
//   const SafetyInspectionForm({super.key});

//   @override
//   State<SafetyInspectionForm> createState() => _SafetyInspectionFormState();
// }

// class _SafetyInspectionFormState extends State<SafetyInspectionForm> {
//   final SafetyInspectionModel formData = SafetyInspectionModel();
//   final SafetyInspectionStepController stepController = Get.put(
//     SafetyInspectionStepController(),
//   );

//   // Text editing controllers for all text fields
//   late TextEditingController vehicleRegistrationController;
//   late TextEditingController mileageController;
//   late TextEditingController makeModelController;
//   late TextEditingController jobReferenceController;
//   late TextEditingController operatorNameController;
//   late TextEditingController insiderCabCommentsController;
//   late TextEditingController vehicleGroundLevelCommentsController;
//   late TextEditingController brakePerformanceCommentsController;
//   late TextEditingController generalServicingCommentsController;
//   late TextEditingController seenOnController;
//   late TextEditingController signedByController;
//   late TextEditingController tmOperatorController;
//   late TextEditingController checkNumberController;
//   late TextEditingController faultDetailsController;
//   late TextEditingController signatureOfInspectorController;
//   late TextEditingController nameOfInspectorController;
//   late TextEditingController actionTakenOnFaultController;
//   late TextEditingController rectifiedByController;
//   late TextEditingController rectifiedSatisfactorilyController;
//   late TextEditingController needsMoreWorkDoneController;
//   late TextEditingController signatureOfMechanicController;
//   late TextEditingController dateController;

//   // Store selected values for each individual item
//   Map<String, String> selectedValues = {};

//   // Store detailed inspection data for each individual item
//   Map<String, Map<String, String>> inspectionData = {};

//   final List<String> stepTitles = [
//     'Customer Information',
//     'Insider Cab',
//     'Vehicle Ground Level',
//     'Brake Performance',
//     'General Servicing',
//     'Inspection Report',
//     'Comments on faults found',
//     'Action taken on faults found',
//     'Consider defects have',
//   ];

//   final List<String> mainDropdownOptions = ["P", "F", "N/A", "R"]; // Main dropdown options
//   final List<String> actionButtonDropdownOptions = ["V", "R", "X", "N/A"]; // Action button popup dropdown options

//   @override
//   void initState() {
//     super.initState();
//     // Initialize all steps as "Skipped" by default
//     for (int i = 0; i < stepTitles.length; i++) {
//       stepController.markStepAsSkipped(i);
//     }
    
//     // Initialize text controllers with formData values
//     vehicleRegistrationController = TextEditingController(text: formData.vehicleRegistration);
//     mileageController = TextEditingController(text: formData.mileage);
//     makeModelController = TextEditingController(text: formData.makeModel);
//     jobReferenceController = TextEditingController(text: formData.jobReference);
//     operatorNameController = TextEditingController(text: formData.operator);
//     insiderCabCommentsController = TextEditingController(text: formData.insiderCabComments);
//     vehicleGroundLevelCommentsController = TextEditingController(text: formData.vehicleGroundLevelComments);
//     brakePerformanceCommentsController = TextEditingController(text: formData.brakePerformanceComments);
//     generalServicingCommentsController = TextEditingController(text: formData.generalServicingComments);
//     seenOnController = TextEditingController(text: formData.seenOn);
//     signedByController = TextEditingController(text: formData.signedBy);
//     tmOperatorController = TextEditingController(text: formData.tmOperator);
//     checkNumberController = TextEditingController(text: formData.checkNumber);
//     faultDetailsController = TextEditingController(text: formData.faultDetails);
//     signatureOfInspectorController = TextEditingController(text: formData.signatureOfInspector);
//     nameOfInspectorController = TextEditingController(text: formData.nameOfInspector);
//     actionTakenOnFaultController = TextEditingController(text: formData.actionTakenOnFault);
//     rectifiedByController = TextEditingController(text: formData.rectifiedBy);
//     rectifiedSatisfactorilyController = TextEditingController(text: formData.rectifiedSatisfactorily);
//     needsMoreWorkDoneController = TextEditingController(text: formData.needsMoreWorkDone);
//     signatureOfMechanicController = TextEditingController(text: formData.signatureOfMechanic);
//     dateController = TextEditingController(text: formData.date);
    
//     // Add listeners to update formData when text changes
//     vehicleRegistrationController.addListener(() => formData.vehicleRegistration = vehicleRegistrationController.text);
//     mileageController.addListener(() => formData.mileage = mileageController.text);
//     makeModelController.addListener(() => formData.makeModel = makeModelController.text);
//     jobReferenceController.addListener(() => formData.jobReference = jobReferenceController.text);
//     operatorNameController.addListener(() => formData.operator = operatorNameController.text);
//     insiderCabCommentsController.addListener(() => formData.insiderCabComments = insiderCabCommentsController.text);
//     vehicleGroundLevelCommentsController.addListener(() => formData.vehicleGroundLevelComments = vehicleGroundLevelCommentsController.text);
//     brakePerformanceCommentsController.addListener(() => formData.brakePerformanceComments = brakePerformanceCommentsController.text);
//     generalServicingCommentsController.addListener(() => formData.generalServicingComments = generalServicingCommentsController.text);
//     seenOnController.addListener(() => formData.seenOn = seenOnController.text);
//     signedByController.addListener(() => formData.signedBy = signedByController.text);
//     tmOperatorController.addListener(() => formData.tmOperator = tmOperatorController.text);
//     checkNumberController.addListener(() => formData.checkNumber = checkNumberController.text);
//     faultDetailsController.addListener(() => formData.faultDetails = faultDetailsController.text);
//     signatureOfInspectorController.addListener(() => formData.signatureOfInspector = signatureOfInspectorController.text);
//     nameOfInspectorController.addListener(() => formData.nameOfInspector = nameOfInspectorController.text);
//     actionTakenOnFaultController.addListener(() => formData.actionTakenOnFault = actionTakenOnFaultController.text);
//     rectifiedByController.addListener(() => formData.rectifiedBy = rectifiedByController.text);
//     rectifiedSatisfactorilyController.addListener(() => formData.rectifiedSatisfactorily = rectifiedSatisfactorilyController.text);
//     needsMoreWorkDoneController.addListener(() => formData.needsMoreWorkDone = needsMoreWorkDoneController.text);
//     signatureOfMechanicController.addListener(() => formData.signatureOfMechanic = signatureOfMechanicController.text);
//     dateController.addListener(() => formData.date = dateController.text);
    
//     // Setup error handler for GetX navigation
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // This ensures any pending snackbars are cleared
//       if (Get.isSnackbarOpen) {
//         Get.closeCurrentSnackbar();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // Dispose all controllers
//     vehicleRegistrationController.dispose();
//     mileageController.dispose();
//     makeModelController.dispose();
//     jobReferenceController.dispose();
//     operatorNameController.dispose();
//     insiderCabCommentsController.dispose();
//     vehicleGroundLevelCommentsController.dispose();
//     brakePerformanceCommentsController.dispose();
//     generalServicingCommentsController.dispose();
//     seenOnController.dispose();
//     signedByController.dispose();
//     tmOperatorController.dispose();
//     checkNumberController.dispose();
//     faultDetailsController.dispose();
//     signatureOfInspectorController.dispose();
//     nameOfInspectorController.dispose();
//     actionTakenOnFaultController.dispose();
//     rectifiedByController.dispose();
//     rectifiedSatisfactorilyController.dispose();
//     needsMoreWorkDoneController.dispose();
//     signatureOfMechanicController.dispose();
//     dateController.dispose();
//     super.dispose();
//   }

//   // Safe navigation back method to handle snackbar issues
//   void _safeNavigateBack() {
//     try {
//       // First check if there's any snackbar open
//       if (Get.isSnackbarOpen) {
//         // Close the snackbar first with a small delay
//         Get.closeCurrentSnackbar();
//         // Wait a bit before navigating back
//         Future.delayed(const Duration(milliseconds: 300), () {
//           Get.back();
//         });
//       } else {
//         // No snackbar, just navigate back
//         Get.back();
//       }
//     } catch (e) {
//       // If anything goes wrong, just navigate back
//       print('Error in safeNavigateBack: $e');
//       Get.back();
//     }
//   }

//   void _collectFormData() {
//     print('=== SAFETY INSPECTION DATA ===');
//     print('Vehicle Registration: ${formData.vehicleRegistration}');
//     print('Mileage: ${formData.mileage}');
//     print('Make & Model: ${formData.makeModel}');
//     print('Job Reference: ${formData.jobReference}');
//     print('Operator: ${formData.operator}');
//     print('Insider Cab Comments: ${formData.insiderCabComments}');
//     print('Vehicle Ground Level Comments: ${formData.vehicleGroundLevelComments}');
//     print('Brake Performance Comments: ${formData.brakePerformanceComments}');
//     print('General Servicing Comments: ${formData.generalServicingComments}');
//     print('Inspection Data: $inspectionData');
//     print('Inspection Report - Seen On: ${formData.seenOn}');
//     print('Inspection Report - Signed By: ${formData.signedBy}');
//     print('Inspection Report - TM Operator: ${formData.tmOperator}');
//     print('Comments on faults found - Check Number: ${formData.checkNumber}');
//     print('Comments on faults found - Fault Details: ${formData.faultDetails}');
//     print('Comments on faults found - Signature Of Inspector: ${formData.signatureOfInspector}');
//     print('Comments on faults found - Name Of Inspector: ${formData.nameOfInspector}');
//     print('Action taken on faults found - Action taken on fault: ${formData.actionTakenOnFault}');
//     print('Action taken on faults found - Rectified by: ${formData.rectifiedBy}');
//     print('Consider defects have - Rectified satisfactorily: ${formData.rectifiedSatisfactorily}');
//     print('Consider defects have - Needs more work done: ${formData.needsMoreWorkDone}');
//     print('Consider defects have - Signature Of Mechanic: ${formData.signatureOfMechanic}');
//     print('Consider defects have - Date: ${formData.date}');
//     print('Main Dropdown Values: ${formData.mainDropdownValues}');
//     print('======================');
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
// IconButton(
//   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//   onPressed: () {
//     // Always show exit confirmation to go back to home screen
//     _showExitConfirmation();
//   },
// ),
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
//                       stepController.currentStep.value == 9
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
//                   if (currentStep == 9) {
//                     return _buildSummaryScreen(isSmallScreen);
//                   }
//                   return _buildStepContent(currentStep, width);
//                 }),
//               ),
//             ),

//             // BOTTOM BUTTONS SECTION
//             Obx(() {
//               bool isViewingFromSummary =
//                   stepController.isViewingFromSummary.value;
//               int currentStep = stepController.currentStep.value;

//               // If viewing from summary, show simplified buttons
//               if (isViewingFromSummary && currentStep < 9) {
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
//                             stepController.goToStep(9);
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
//                             stepController.goToStep(9);
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
//                         if (currentStep > 0 && currentStep < 9)
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

//                         if (currentStep < 8)
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

//                     if (currentStep < 8)
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
//                     else if (currentStep == 8)
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             stepController.markStepAsFilled(8);
//                             stepController.goToStep(9);
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
//                     stepController.goToStep(8);
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
//                   stepTitles[index],
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 15,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: "PolySans",
//                     color: isFilled ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Text(
//                   isFilled ? "(Filled)" : "(Skipped)",
//                   style: TextStyle(
//                     fontSize: 13,
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
//                     fontSize: isSmallScreen ? 13 : 14,
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
//         return _buildInspectionSection('Insider Cab', isSmallScreen);
//       case 2:
//         return _buildInspectionSection('Vehicle Ground Level', isSmallScreen);
//       case 3:
//         return _buildInspectionSection('Brake Performance', isSmallScreen);
//       case 4:
//         return _buildInspectionSection('General Servicing', isSmallScreen);
//       case 5:
//         return _buildInspectionReportSection(isSmallScreen);
//       case 6:
//         return _buildCommentsOnFaultsFoundSection(isSmallScreen);
//       case 7:
//         return _buildActionTakenOnFaultsFoundSection(isSmallScreen);
//       case 8:
//         return _buildConsiderDefectsHaveSection(isSmallScreen);
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

//           _buildTextFieldWithController(
//             'Enter* Vehicle Registration',
//             vehicleRegistrationController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Odometer Reading',
//             mileageController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Make & Type',
//             makeModelController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Date Of Inspection',
//             jobReferenceController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Operator',
//             operatorNameController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildInspectionReportSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Inspection Report',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 25),

//           _buildTextFieldWithController(
//             'Enter* Seen on',
//             seenOnController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Signed by',
//             signedByController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* TM Operator',
//             tmOperatorController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildCommentsOnFaultsFoundSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Comments on faults found',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 25),

//           _buildTextFieldWithController(
//             'Enter* Check Number',
//             checkNumberController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Fault Details',
//             faultDetailsController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Signature Of Inspector',
//             signatureOfInspectorController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Name Of Inspector',
//             nameOfInspectorController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildActionTakenOnFaultsFoundSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Action taken on faults found',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 25),

//           _buildTextFieldWithController(
//             'Enter* Action taken on fault',
//             actionTakenOnFaultController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* Rectified by',
//             rectifiedByController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildConsiderDefectsHaveSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Consider defects have',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 25),

//           _buildTextFieldWithController(
//             'Enter* (IF) Rectified satisfactorily',
//             rectifiedSatisfactorilyController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* (IF) Needs more work done',
//             needsMoreWorkDoneController,
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//           _buildTextFieldWithController(
//             'Enter* (IF) Signature Of Mechanic',
//             signatureOfMechanicController,
//             isSmallScreen,
//           ),
//           // const SizedBox(height: 16),
//           // _buildTextFieldWithController(
//           //   'Enter* Date',
//           //   dateController,
//           //   isSmallScreen,
//           // ),
//           const SizedBox(height: 16),
//           _buildDateField(isSmallScreen),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildDateField(bool isSmallScreen) {
//   return Container(
//     height: isSmallScreen ? 50 : 55,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(color: Colors.grey.shade300),
//     ),
//     child: InkWell(
//       onTap: () => _selectDate(context),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               formData.date != null && formData.date!.isNotEmpty
//                 ? formData.date!
//                 : 'Enter* Date',
//               style: TextStyle(
//                 color: formData.date != null && formData.date!.isNotEmpty
//                     ? Colors.black
//                     : Colors.grey.shade600,
//                 fontSize: isSmallScreen ? 14 : 16,
//                 fontFamily: 'PolySans',
//               ),
//             ),
//             Icon(Icons.calendar_today,
//                 color: Colors.grey.shade600, size: 20),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Future<void> _selectDate(BuildContext context) async {
//   final DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2000),
//     lastDate: DateTime(2100),
//   );
  
//   if (picked != null) {
//     final formattedDate = '${picked.day}/${picked.month}/${picked.year}';
//     setState(() {
//       formData.date = formattedDate;
//       dateController.text = formattedDate; // Use underscore
//     });
//   }
// }

//  Widget _buildInspectionSection(String sectionTitle, bool isSmallScreen) {
//   Map<String, List<String>> sectionItems = {
//     'Insider Cab': [
//       'Drivers seat*',
//       'Seat belts*',
//       'Mirrors*',
//       'Glass & Road View*',
//       'Accessibility Features*',
//       'Horn*',
//     ],
//     'Vehicle Ground Level': [
//       'Security of body*',
//       'Exhaust emission*',
//       'Road wheels & hubs*',
//       'Size & types of tyres*',
//       'Condition of tyres*',
//       'Bumper bars*',
//     ],
//     'Brake Performance': [
//       'Service Brake Performance*',
//       'Brake Performance*',
//       'Parking Brake Performance*',
//     ],
//     'General Servicing': [
//       'Vehicle excise duty*',
//       'PSV*',
//       'Technograph calibration*',
//     ],
//   };

//   List<String> items = sectionItems[sectionTitle] ?? [];

//   return _buildFormContainer(
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           sectionTitle,
//           style: TextStyle(
//             fontSize: isSmallScreen ? 20 : 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//             fontFamily: 'PolySans',
//           ),
//         ),
//         const SizedBox(height: 15),

//         // ---------------------- LOOP ITEMS ----------------------
//         ...items.map((item) {
//           String cleanKey = item.replaceAll('*', '').trim();
          
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 14),
//             child: Container(
//               height: 55,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Row(
//                 children: [
//                   // LEFT LABEL
//                   Expanded(
//                     flex: 3,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         item,
//                         style: TextStyle(
//                           fontFamily: 'PolySans',
//                           fontSize: isSmallScreen ? 14 : 15,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ),
                  
//                   // DROPDOWN (P / F / N/A / R)
//                   Container(
//                     width: 100,
//                     height: 100,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: selectedValues[cleanKey]?.isEmpty ?? true
//                             ? null
//                             : selectedValues[cleanKey],
//                         icon: const Icon(Icons.keyboard_arrow_down, size: 18),
//                         isExpanded: true,
//                         items: mainDropdownOptions.map((val) {
//                           return DropdownMenuItem(
//                             value: val,
//                             child: Center(
//                               child: Text(
//                                 val,
//                                 style: const TextStyle(
//                                   fontFamily: "PolySans",
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedValues[cleanKey] = value!;
//                             // Also save to model immediately - use item (with asterisk) to match PDF expectations
//                             formData.setMainDropdownValue(item, value);
//                           });
//                         },
//                       ),
//                     ),
//                   ),
                  
//                   // BLUE ICON BUTTON
//                   Container(
//                     width: 55,
//                     height: 100,
//                     decoration: const BoxDecoration(
//                       color: Color(0xff173EA6),
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                     ),
//                     child: IconButton(
//                       icon: const Icon(
//                         Icons.open_in_new,
//                         size: 22,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         _showIndividualSelectionPopup(item, sectionTitle);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),

//         const SizedBox(height: 14),

//         // ---------------------- COMMENTS FIELD ----------------------
//         _buildCommentsField(sectionTitle, isSmallScreen),

//         const SizedBox(height: 20),
//       ],
//     ),
//     isSmallScreen,
//   );
// }


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

//   Widget _buildTextFieldWithController(
//     String hint,
//     TextEditingController controller,
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
//         controller: controller,
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
//       ),
//     );
//   }

//   Widget _buildCommentsField(String sectionTitle, bool isSmallScreen) {
//     TextEditingController? controller;
//     if (sectionTitle == 'Insider Cab') {
//       controller = insiderCabCommentsController;
//     } else if (sectionTitle == 'Vehicle Ground Level') {
//       controller = vehicleGroundLevelCommentsController;
//     } else if (sectionTitle == 'Brake Performance') {
//       controller = brakePerformanceCommentsController;
//     } else if (sectionTitle == 'General Servicing') {
//       controller = generalServicingCommentsController;
//     }

//     if (controller == null) return const SizedBox.shrink();

//     return TextField(
//       controller: controller,
//       maxLines: 4,
//       decoration: InputDecoration(
//         hintText: "Enter* Comments (Optional)",
//         hintStyle: TextStyle(
//           fontFamily: "PolySans",
//           color: Colors.grey.shade600,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.all(12),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.grey.shade300, width: 1.4),
//         ),
//       ),
//     );
//   }

//   void _showIndividualSelectionPopup(String itemName, String sectionTitle) {
//     String cleanItemName = itemName.replaceAll('*', '').trim();

//     // Define sub-items for each inspection item (similar to mini service)
//     Map<String, List<String>> itemOptions = {
//       'Drivers seat': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Seat belts': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Mirrors': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Glass & Road View': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Accessibility Features': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Horn': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Security of body': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Exhaust emission': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Road wheels & hubs': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Size & types of tyres': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Condition of tyres': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Bumper bars': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
//       'Service Brake Performance': ['Item inspected', '% Percent'],
//       'Brake Performance': ['Item inspected', '% Percent'],
//       'Parking Brake Performance': ['Item inspected', '% Percent'],
//       'Vehicle excise duty': ['Item inspected', 'Due Date'],
//       'PSV': ['Item inspected', 'Due Date'],
//       'Technograph calibration': ['Item inspected', 'Due Date'],
//     };

//     List<String> options = itemOptions[cleanItemName] ?? ['Check 1', 'Check 2', 'Check 3'];

//     Map<String, String> initialSelections = {};
//     final currentData = inspectionData[itemName] ?? {};
//     for (var option in options) {
//       if (currentData.containsKey(option)) {
//         initialSelections[option] = currentData[option]!;
//       }
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return _IndividualSelectionDialog(
//           itemName: itemName,
//           cleanItemName: cleanItemName,
//           options: options,
//           initialSelections: initialSelections,
//           inspectionData: inspectionData,
//           selectedValues: selectedValues,
//           formData: formData,
//           actionButtonDropdownOptions: actionButtonDropdownOptions,
//           onSave: (Map<String, String> selections) {
//             setState(() {
//               inspectionData[itemName] = selections;
//               formData.addInspectionData(itemName, selections);
              
//               String mainDropdownValue = selectedValues[cleanItemName] ?? "";
//               if (mainDropdownValue.isNotEmpty) {
//                 formData.setMainDropdownValue(itemName, mainDropdownValue);
//               }
//             });
//           },
//         );
//       },
//     );
//   }

//    void _showExitConfirmation() {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Exit Form?', style: TextStyle(fontFamily: 'PolySans')),
//       content: const Text(
//         'Are you sure you want to exit? Your progress may not be saved.',
//         style: TextStyle(fontFamily: 'PolySans'),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
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
//             Navigator.of(context).pop(); // Close dialog
//             Navigator.of(context).pop(); // Navigate back to home screen
//           },
//           child: const Text(
//             'Exit',
//             style: TextStyle(
//               color: Color(0xff173EA6),
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

//       // All form data is already updated via controller listeners
//       // Just ensure inspectionData is saved
//       formData.inspectionData = inspectionData;

//       // Save selected values to mainDropdownValues
//       // Need to map cleanKey back to original item name with asterisk for PDF
//       Map<String, List<String>> sectionItems = {
//         'Insider Cab': [
//           'Drivers seat*',
//           'Seat belts*',
//           'Mirrors*',
//           'Glass & Road View*',
//           'Accessibility Features*',
//           'Horn*',
//         ],
//         'Vehicle Ground Level': [
//           'Security of body*',
//           'Exhaust emission*',
//           'Road wheels & hubs*',
//           'Size & types of tyres*',
//           'Condition of tyres*',
//           'Bumper bars*',
//         ],
//         'Brake Performance': [
//           'Service Brake Performance*',
//           'Brake Performance*',
//           'Parking Brake Performance*',
//         ],
//         'General Servicing': [
//           'Vehicle excise duty*',
//           'PSV*',
//           'Technograph calibration*',
//         ],
//       };
      
//       // Map all items from all sections
//       List<String> allItems = [];
//       sectionItems.values.forEach((items) => allItems.addAll(items));
      
//       // Save selected values - map cleanKey to original item name
//       for (var entry in selectedValues.entries) {
//         if (entry.value.isNotEmpty) {
//           // Find the original item name with asterisk
//           String originalItem = allItems.firstWhere(
//             (item) => item.replaceAll('*', '').trim() == entry.key,
//             orElse: () => entry.key,
//           );
//           formData.setMainDropdownValue(originalItem, entry.value);
//         }
//       }

//       final ByteData byteData = await rootBundle.load('assets/images/logo.png');
//       final Uint8List logoBytes = byteData.buffer.asUint8List();

//       final pdfBytes = await SafetyInspectionPdfService.generatePdf(
//         formData,
//         logoImageBytes: logoBytes,
//       );

//       await Printing.sharePdf(
//         bytes: pdfBytes,
//         filename:
//             'safety-inspection-report.pdf',
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
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Export Error'),
//           content: Text('Failed to generate PDF: $e'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

// // Separate StatefulWidget for dialog to manage controller lifecycle
// class _IndividualSelectionDialog extends StatefulWidget {
//   final String itemName;
//   final String cleanItemName;
//   final List<String> options;
//   final Map<String, String> initialSelections;
//   final Map<String, Map<String, String>> inspectionData;
//   final Map<String, String> selectedValues;
//   final SafetyInspectionModel formData;
//   final List<String> actionButtonDropdownOptions;
//   final Function(Map<String, String>) onSave;

//   const _IndividualSelectionDialog({
//     required this.itemName,
//     required this.cleanItemName,
//     required this.options,
//     required this.initialSelections,
//     required this.inspectionData,
//     required this.selectedValues,
//     required this.formData,
//     required this.actionButtonDropdownOptions,
//     required this.onSave,
//   });

//   @override
//   State<_IndividualSelectionDialog> createState() => _IndividualSelectionDialogState();
// }

// class _IndividualSelectionDialogState extends State<_IndividualSelectionDialog> {
//   late Map<String, String> tempSelections;
//   late Map<String, TextEditingController> textControllers;

//   @override
//   void initState() {
//     super.initState();
//     tempSelections = Map.from(widget.initialSelections);
    
//     // Create text controllers for text fields
//     textControllers = {};
//     for (var option in widget.options) {
//       bool isTextField = option == '% Percent' || 
//                         option == 'Due Date' || 
//                         (option == 'Item inspected' && 
//                          (widget.cleanItemName == 'Service Brake Performance' || 
//                           widget.cleanItemName == 'Brake Performance' || 
//                           widget.cleanItemName == 'Parking Brake Performance' ||
//                           widget.cleanItemName == 'Vehicle excise duty' ||
//                           widget.cleanItemName == 'PSV' ||
//                           widget.cleanItemName == 'Technograph calibration'));
//       if (isTextField) {
//         textControllers[option] = TextEditingController(text: tempSelections[option] ?? '');
//       }
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose all text controllers when widget is disposed
//     for (var controller in textControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _handleSave() {
//     // Update tempSelections with text field values before saving
//     for (var entry in textControllers.entries) {
//       if (entry.value.text.isNotEmpty) {
//         tempSelections[entry.key] = entry.value.text;
//       } else {
//         tempSelections.remove(entry.key);
//       }
//     }
    
//     widget.onSave(tempSelections);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       insetPadding: const EdgeInsets.all(20),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Select Options",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontFamily: "PolySans",
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close, size: 22),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 15),

//             ...widget.options.map((option) {
//               // Check if this option should be a text field
//               bool isTextField = option == '% Percent' || 
//                                 option == 'Due Date' || 
//                                 (option == 'Item inspected' && 
//                                  (widget.cleanItemName == 'Service Brake Performance' || 
//                                   widget.cleanItemName == 'Brake Performance' || 
//                                   widget.cleanItemName == 'Parking Brake Performance' ||
//                                   widget.cleanItemName == 'Vehicle excise duty' ||
//                                   widget.cleanItemName == 'PSV' ||
//                                   widget.cleanItemName == 'Technograph calibration'));
              
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         option,
//                         style: const TextStyle(
//                           fontFamily: "PolySans",
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Container(
//                       width: 80,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: isTextField
//                           ? TextField(
//                               controller: textControllers[option],
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (value.isEmpty) {
//                                     tempSelections.remove(option);
//                                   } else {
//                                     tempSelections[option] = value;
//                                   }
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 hintText: "Enter",
//                                 hintStyle: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey.shade600,
//                                   fontFamily: "PolySans",
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 10,
//                                 ),
//                                 isDense: true,
//                               ),
//                               style: const TextStyle(
//                                 fontFamily: "PolySans",
//                                 fontSize: 12,
//                               ),
//                             )
//                           : DropdownButtonHideUnderline(
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
//                                 items: widget.actionButtonDropdownOptions.map((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Center(
//                                       child: Text(
//                                         value,
//                                         style: const TextStyle(
//                                           fontFamily: "PolySans",
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     if (newValue == null) {
//                                       tempSelections.remove(option);
//                                     } else {
//                                       tempSelections[option] = newValue;
//                                     }
//                                   });
//                                 },
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),

//             const SizedBox(height: 18),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _handleSave,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff173EA6),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   "Save",
//                   style: TextStyle(
//                     fontFamily: "PolySans",
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:data/models/safety_inspection_model.dart';
import 'package:data/services/safety_inspection_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SafetyInspectionStepController extends GetxController {
  var currentStep = 0.obs;
  var stepStatus = <int, String>{}.obs;
  var isViewingFromSummary = false.obs;

  void nextStep() {
    if (currentStep.value < 9) { // Changed from 8 to 9
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 10) { // Changed from 9 to 10
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

class SafetyInspectionForm extends StatefulWidget {
  const SafetyInspectionForm({super.key});

  @override
  State<SafetyInspectionForm> createState() => _SafetyInspectionFormState();
}

class _SafetyInspectionFormState extends State<SafetyInspectionForm> {
  final SafetyInspectionModel formData = SafetyInspectionModel();
  final SafetyInspectionStepController stepController = Get.put(
    SafetyInspectionStepController(),
  );

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();
  
  // For Step 0: Single image upload (Main Information)
  File? _selectedImage;
  bool _isUploading = false;

  // Text editing controllers for all text fields
  // Main Information (Step 0)
  late TextEditingController workShopNameController;
  late TextEditingController JobReferenceController;
  
  // Customer Information (Step 1)
  late TextEditingController vehicleRegistrationController;
  late TextEditingController mileageController;
  late TextEditingController makeModelController;
  late TextEditingController dateOfInspectionController;
  late TextEditingController operatorNameController;
  late TextEditingController insiderCabCommentsController;
  late TextEditingController vehicleGroundLevelCommentsController;
  late TextEditingController brakePerformanceCommentsController;
  late TextEditingController generalServicingCommentsController;
  late TextEditingController seenOnController;
  late TextEditingController signedByController;
  late TextEditingController tmOperatorController;
  late TextEditingController checkNumberController;
  late TextEditingController faultDetailsController;
  late TextEditingController signatureOfInspectorController;
  late TextEditingController nameOfInspectorController;
  late TextEditingController actionTakenOnFaultController;
  late TextEditingController rectifiedByController;
  late TextEditingController rectifiedSatisfactorilyController;
  late TextEditingController needsMoreWorkDoneController;
  late TextEditingController signatureOfMechanicController;
  late TextEditingController dateController;

  // Store selected values for each individual item
  Map<String, String> selectedValues = {};

  // Store detailed inspection data for each individual item
  Map<String, Map<String, String>> inspectionData = {};

  final List<String> stepTitles = [
    'Main Information',           // Step 0 (new)
    'Customer Information',       // Step 1 (was 0)
    'Insider Cab',                // Step 2 (was 1)
    'Vehicle Ground Level',       // Step 3 (was 2)
    'Brake Performance',         // Step 4 (was 3)
    'General Servicing',         // Step 5 (was 4)
    'Inspection Report',         // Step 6 (was 5)
    'Comments on faults found',  // Step 7 (was 6)
    'Action taken on faults found', // Step 8 (was 7)
    'Consider defects have',     // Step 9 (was 8)
  ];

  final List<String> mainDropdownOptions = ["P", "F", "N/A", "R"];
  final List<String> actionButtonDropdownOptions = ["V", "R", "X", "N/A"];

  @override
  void initState() {
    super.initState();
    // Initialize all steps as "Skipped" by default
    for (int i = 0; i < stepTitles.length; i++) {
      stepController.markStepAsSkipped(i);
    }
    
    // Initialize text controllers with formData values
    // Main Information (Step 0)
    workShopNameController = TextEditingController(text: formData.workshopName);
    JobReferenceController = TextEditingController(text: formData.jobReference);
    
    // Customer Information (Step 1)
    vehicleRegistrationController = TextEditingController(text: formData.vehicleRegistration);
    mileageController = TextEditingController(text: formData.mileage);
    makeModelController = TextEditingController(text: formData.makeModel);
    dateOfInspectionController = TextEditingController(text: formData.dateOfInspection);
    operatorNameController = TextEditingController(text: formData.operator);
    insiderCabCommentsController = TextEditingController(text: formData.insiderCabComments);
    vehicleGroundLevelCommentsController = TextEditingController(text: formData.vehicleGroundLevelComments);
    brakePerformanceCommentsController = TextEditingController(text: formData.brakePerformanceComments);
    generalServicingCommentsController = TextEditingController(text: formData.generalServicingComments);
    seenOnController = TextEditingController(text: formData.seenOn);
    signedByController = TextEditingController(text: formData.signedBy);
    tmOperatorController = TextEditingController(text: formData.tmOperator);
    checkNumberController = TextEditingController(text: formData.checkNumber);
    faultDetailsController = TextEditingController(text: formData.faultDetails);
    signatureOfInspectorController = TextEditingController(text: formData.signatureOfInspector);
    nameOfInspectorController = TextEditingController(text: formData.nameOfInspector);
    actionTakenOnFaultController = TextEditingController(text: formData.actionTakenOnFault);
    rectifiedByController = TextEditingController(text: formData.rectifiedBy);
    rectifiedSatisfactorilyController = TextEditingController(text: formData.rectifiedSatisfactorily);
    needsMoreWorkDoneController = TextEditingController(text: formData.needsMoreWorkDone);
    signatureOfMechanicController = TextEditingController(text: formData.signatureOfMechanic);
    dateController = TextEditingController(text: formData.date);
    
    // Add listeners to update formData when text changes
    // Main Information (Step 0)
    workShopNameController.addListener(() => formData.workshopName = workShopNameController.text);
    JobReferenceController.addListener(() => formData.jobReference = JobReferenceController.text);
    
    // Customer Information (Step 1)
    vehicleRegistrationController.addListener(() => formData.vehicleRegistration = vehicleRegistrationController.text);
    mileageController.addListener(() => formData.mileage = mileageController.text);
    makeModelController.addListener(() => formData.makeModel = makeModelController.text);
    dateOfInspectionController.addListener(() => formData.dateOfInspection = dateOfInspectionController.text);
    operatorNameController.addListener(() => formData.operator = operatorNameController.text);
    insiderCabCommentsController.addListener(() => formData.insiderCabComments = insiderCabCommentsController.text);
    vehicleGroundLevelCommentsController.addListener(() => formData.vehicleGroundLevelComments = vehicleGroundLevelCommentsController.text);
    brakePerformanceCommentsController.addListener(() => formData.brakePerformanceComments = brakePerformanceCommentsController.text);
    generalServicingCommentsController.addListener(() => formData.generalServicingComments = generalServicingCommentsController.text);
    seenOnController.addListener(() => formData.seenOn = seenOnController.text);
    signedByController.addListener(() => formData.signedBy = signedByController.text);
    tmOperatorController.addListener(() => formData.tmOperator = tmOperatorController.text);
    checkNumberController.addListener(() => formData.checkNumber = checkNumberController.text);
    faultDetailsController.addListener(() => formData.faultDetails = faultDetailsController.text);
    signatureOfInspectorController.addListener(() => formData.signatureOfInspector = signatureOfInspectorController.text);
    nameOfInspectorController.addListener(() => formData.nameOfInspector = nameOfInspectorController.text);
    actionTakenOnFaultController.addListener(() => formData.actionTakenOnFault = actionTakenOnFaultController.text);
    rectifiedByController.addListener(() => formData.rectifiedBy = rectifiedByController.text);
    rectifiedSatisfactorilyController.addListener(() => formData.rectifiedSatisfactorily = rectifiedSatisfactorilyController.text);
    needsMoreWorkDoneController.addListener(() => formData.needsMoreWorkDone = needsMoreWorkDoneController.text);
    signatureOfMechanicController.addListener(() => formData.signatureOfMechanic = signatureOfMechanicController.text);
    dateController.addListener(() => formData.date = dateController.text);
    
    // Setup error handler for GetX navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    workShopNameController.dispose();
    JobReferenceController.dispose();
    vehicleRegistrationController.dispose();
    mileageController.dispose();
    makeModelController.dispose();
    dateOfInspectionController.dispose();
    operatorNameController.dispose();
    insiderCabCommentsController.dispose();
    vehicleGroundLevelCommentsController.dispose();
    brakePerformanceCommentsController.dispose();
    generalServicingCommentsController.dispose();
    seenOnController.dispose();
    signedByController.dispose();
    tmOperatorController.dispose();
    checkNumberController.dispose();
    faultDetailsController.dispose();
    signatureOfInspectorController.dispose();
    nameOfInspectorController.dispose();
    actionTakenOnFaultController.dispose();
    rectifiedByController.dispose();
    rectifiedSatisfactorilyController.dispose();
    needsMoreWorkDoneController.dispose();
    signatureOfMechanicController.dispose();
    dateController.dispose();
    super.dispose();
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

  // Safe navigation back method to handle snackbar issues
  void _safeNavigateBack() {
    try {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.back();
        });
      } else {
        Get.back();
      }
    } catch (e) {
      print('Error in safeNavigateBack: $e');
      Get.back();
    }
  }

  void _collectFormData() {
    print('=== SAFETY INSPECTION DATA ===');
    print('Workshop Name: ${formData.workshopName}');
    print('Job Reference: ${formData.jobReference}');
    print('Vehicle Registration: ${formData.vehicleRegistration}');
    print('Mileage: ${formData.mileage}');
    print('Make & Model: ${formData.makeModel}');
    print('Date of Inspection: ${formData.dateOfInspection}');
    print('Operator: ${formData.operator}');
    print('Insider Cab Comments: ${formData.insiderCabComments}');
    print('Vehicle Ground Level Comments: ${formData.vehicleGroundLevelComments}');
    print('Brake Performance Comments: ${formData.brakePerformanceComments}');
    print('General Servicing Comments: ${formData.generalServicingComments}');
    print('Inspection Data: $inspectionData');
    print('Inspection Report - Seen On: ${formData.seenOn}');
    print('Inspection Report - Signed By: ${formData.signedBy}');
    print('Inspection Report - TM Operator: ${formData.tmOperator}');
    print('Comments on faults found - Check Number: ${formData.checkNumber}');
    print('Comments on faults found - Fault Details: ${formData.faultDetails}');
    print('Comments on faults found - Signature Of Inspector: ${formData.signatureOfInspector}');
    print('Comments on faults found - Name Of Inspector: ${formData.nameOfInspector}');
    print('Action taken on faults found - Action taken on fault: ${formData.actionTakenOnFault}');
    print('Action taken on faults found - Rectified by: ${formData.rectifiedBy}');
    print('Consider defects have - Rectified satisfactorily: ${formData.rectifiedSatisfactorily}');
    print('Consider defects have - Needs more work done: ${formData.needsMoreWorkDone}');
    print('Consider defects have - Signature Of Mechanic: ${formData.signatureOfMechanic}');
    print('Consider defects have - Date: ${formData.date}');
    print('Main Dropdown Values: ${formData.mainDropdownValues}');
    print('======================');
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
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
                      stepController.currentStep.value == 10 // Changed from 9 to 10
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
                  if (currentStep == 10) { // Changed from 9 to 10
                    return _buildSummaryScreen(isSmallScreen);
                  }
                  return _buildStepContent(currentStep, width);
                }),
              ),
            ),

            // BOTTOM BUTTONS SECTION
            Obx(() {
              bool isViewingFromSummary =
                  stepController.isViewingFromSummary.value;
              int currentStep = stepController.currentStep.value;

              // If viewing from summary, show simplified buttons
              if (isViewingFromSummary && currentStep < 10) { // Changed from 9 to 10
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
                            stepController.goToStep(10); // Changed from 9 to 10
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
                            stepController.goToStep(10); // Changed from 9 to 10
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
                        if (currentStep > 0 && currentStep < 10) // Changed from 9 to 10
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

                        if (currentStep < 9) // Changed from 8 to 9
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

                    if (currentStep < 9) // Changed from 8 to 9
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
                    else if (currentStep == 9) // Changed from 8 to 9
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            stepController.markStepAsFilled(9); // Changed from 8 to 9
                            stepController.goToStep(10); // Changed from 9 to 10
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
                    stepController.goToStep(9); // Changed from 8 to 9
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
                  stepTitles[index],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: "PolySans",
                    color: isFilled ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  isFilled ? "(Filled)" : "(Skipped)",
                  style: TextStyle(
                    fontSize: 13,
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
                    fontSize: isSmallScreen ? 13 : 14,
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
      case 0: // NEW: Main Information
        return _buildMainInformationSection(isSmallScreen);
      case 1: // Was 0: Customer Information
        return _buildCustomerInfoSection(isSmallScreen);
      case 2: // Was 1: Insider Cab
        return _buildInspectionSection('Insider Cab', isSmallScreen);
      case 3: // Was 2: Vehicle Ground Level
        return _buildInspectionSection('Vehicle Ground Level', isSmallScreen);
      case 4: // Was 3: Brake Performance
        return _buildInspectionSection('Brake Performance', isSmallScreen);
      case 5: // Was 4: General Servicing
        return _buildInspectionSection('General Servicing', isSmallScreen);
      case 6: // Was 5: Inspection Report
        return _buildInspectionReportSection(isSmallScreen);
      case 7: // Was 6: Comments on faults found
        return _buildCommentsOnFaultsFoundSection(isSmallScreen);
      case 8: // Was 7: Action taken on faults found
        return _buildActionTakenOnFaultsFoundSection(isSmallScreen);
      case 9: // Was 8: Consider defects have
        return _buildConsiderDefectsHaveSection(isSmallScreen);
      default:
        return Container();
    }
  }

  // ==================== STEP 0: MAIN INFORMATION ====================
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
              controller: workShopNameController,
              decoration: InputDecoration(
                hintText: 'Enter* Workshop Name & Address',
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
              controller: JobReferenceController,
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
            operatorNameController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildInspectionReportSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inspection Report',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 25),

          _buildTextFieldWithController(
            'Enter* Seen on',
            seenOnController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Signed by',
            signedByController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* TM Operator',
            tmOperatorController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildCommentsOnFaultsFoundSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments on faults found',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 25),

          _buildTextFieldWithController(
            'Enter* Check Number',
            checkNumberController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Fault Details',
            faultDetailsController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Signature Of Inspector',
            signatureOfInspectorController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Name Of Inspector',
            nameOfInspectorController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildActionTakenOnFaultsFoundSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Action taken on faults found',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 25),

          _buildTextFieldWithController(
            'Enter* Action taken on fault',
            actionTakenOnFaultController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* Rectified by',
            rectifiedByController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
        ],
      ),
      isSmallScreen,
    );
  }

  Widget _buildConsiderDefectsHaveSection(bool isSmallScreen) {
    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consider defects have',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 25),

          _buildTextFieldWithController(
            'Enter* (IF) Rectified satisfactorily',
            rectifiedSatisfactorilyController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* (IF) Needs more work done',
            needsMoreWorkDoneController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
          _buildTextFieldWithController(
            'Enter* (IF) Signature Of Mechanic',
            signatureOfMechanicController,
            isSmallScreen,
          ),
          const SizedBox(height: 16),
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

  Widget _buildInspectionSection(String sectionTitle, bool isSmallScreen) {
    Map<String, List<String>> sectionItems = {
      'Insider Cab': [
        'Drivers seat*',
        'Seat belts*',
        'Mirrors*',
        'Glass & Road View*',
        'Accessibility Features*',
        'Horn*',
      ],
      'Vehicle Ground Level': [
        'Security of body*',
        'Exhaust emission*',
        'Road wheels & hubs*',
        'Size & types of tyres*',
        'Condition of tyres*',
        'Bumper bars*',
      ],
      'Brake Performance': [
        'Service Brake Performance*',
        'Brake Performance*',
        'Parking Brake Performance*',
      ],
      'General Servicing': [
        'Vehicle excise duty*',
        'PSV*',
        'Technograph calibration*',
      ],
    };

    List<String> items = sectionItems[sectionTitle] ?? [];

    return _buildFormContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PolySans',
            ),
          ),
          const SizedBox(height: 15),

          // ---------------------- LOOP ITEMS ----------------------
          ...items.map((item) {
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
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedValues[cleanKey]?.isEmpty ?? true
                              ? null
                              : selectedValues[cleanKey],
                          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                          isExpanded: true,
                          items: mainDropdownOptions.map((val) {
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
                              formData.setMainDropdownValue(item, value);
                            });
                          },
                        ),
                      ),
                    ),
                    
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
                        onPressed: () {
                          _showIndividualSelectionPopup(item, sectionTitle);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 14),

          // ---------------------- COMMENTS FIELD ----------------------
          _buildCommentsField(sectionTitle, isSmallScreen),

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

  Widget _buildCommentsField(String sectionTitle, bool isSmallScreen) {
    TextEditingController? controller;
    if (sectionTitle == 'Insider Cab') {
      controller = insiderCabCommentsController;
    } else if (sectionTitle == 'Vehicle Ground Level') {
      controller = vehicleGroundLevelCommentsController;
    } else if (sectionTitle == 'Brake Performance') {
      controller = brakePerformanceCommentsController;
    } else if (sectionTitle == 'General Servicing') {
      controller = generalServicingCommentsController;
    }

    if (controller == null) return const SizedBox.shrink();

    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Enter* Comments (Optional)",
        hintStyle: TextStyle(
          fontFamily: "PolySans",
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
    );
  }

  void _showIndividualSelectionPopup(String itemName, String sectionTitle) {
    String cleanItemName = itemName.replaceAll('*', '').trim();

    // Define sub-items for each inspection item
    Map<String, List<String>> itemOptions = {
      'Drivers seat': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Seat belts': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Mirrors': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Glass & Road View': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Accessibility Features': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Horn': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Security of body': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Exhaust emission': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Road wheels & hubs': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Size & types of tyres': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Condition of tyres': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Bumper bars': ['Item inspected', 'Serviceable', 'Defect Found', 'Rectified by'],
      'Service Brake Performance': ['Item inspected', '% Percent'],
      'Brake Performance': ['Item inspected', '% Percent'],
      'Parking Brake Performance': ['Item inspected', '% Percent'],
      'Vehicle excise duty': ['Item inspected', 'Due Date'],
      'PSV': ['Item inspected', 'Due Date'],
      'Technograph calibration': ['Item inspected', 'Due Date'],
    };

    List<String> options = itemOptions[cleanItemName] ?? ['Check 1', 'Check 2', 'Check 3'];

    Map<String, String> initialSelections = {};
    final currentData = inspectionData[itemName] ?? {};
    for (var option in options) {
      if (currentData.containsKey(option)) {
        initialSelections[option] = currentData[option]!;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _IndividualSelectionDialog(
          itemName: itemName,
          cleanItemName: cleanItemName,
          options: options,
          initialSelections: initialSelections,
          inspectionData: inspectionData,
          selectedValues: selectedValues,
          formData: formData,
          actionButtonDropdownOptions: actionButtonDropdownOptions,
          onSave: (Map<String, String> selections) {
            setState(() {
              inspectionData[itemName] = selections;
              formData.addInspectionData(itemName, selections);
              
              String mainDropdownValue = selectedValues[cleanItemName] ?? "";
              if (mainDropdownValue.isNotEmpty) {
                formData.setMainDropdownValue(itemName, mainDropdownValue);
              }
            });
          },
        );
      },
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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

  void _exportToPdf() async {
    try {
      _collectFormData();

      // All form data is already updated via controller listeners
      // Just ensure inspectionData is saved
      formData.inspectionData = inspectionData;

      // Save selected values to mainDropdownValues
      Map<String, List<String>> sectionItems = {
        'Insider Cab': [
          'Drivers seat*',
          'Seat belts*',
          'Mirrors*',
          'Glass & Road View*',
          'Accessibility Features*',
          'Horn*',
        ],
        'Vehicle Ground Level': [
          'Security of body*',
          'Exhaust emission*',
          'Road wheels & hubs*',
          'Size & types of tyres*',
          'Condition of tyres*',
          'Bumper bars*',
        ],
        'Brake Performance': [
          'Service Brake Performance*',
          'Brake Performance*',
          'Parking Brake Performance*',
        ],
        'General Servicing': [
          'Vehicle excise duty*',
          'PSV*',
          'Technograph calibration*',
        ],
      };
      
      // Map all items from all sections
      List<String> allItems = [];
      sectionItems.values.forEach((items) => allItems.addAll(items));
      
      // Save selected values - map cleanKey to original item name
      for (var entry in selectedValues.entries) {
        if (entry.value.isNotEmpty) {
          String originalItem = allItems.firstWhere(
            (item) => item.replaceAll('*', '').trim() == entry.key,
            orElse: () => entry.key,
          );
          formData.setMainDropdownValue(originalItem, entry.value);
        }
      }

      // Add main image (from Step 0) to formData
      Uint8List? mainImageBytes;
      if (_selectedImage != null) {
        try {
          mainImageBytes = await _selectedImage!.readAsBytes();
        } catch (e) {
          print('Error reading main image bytes: $e');
        }
      }

      // Update formData with main information
      formData.workshopName = workShopNameController.text;
      formData.jobReference = JobReferenceController.text;
      formData.mainImageBytes = mainImageBytes;

      final ByteData byteData = await rootBundle.load('assets/images/logo.png');
      final Uint8List logoBytes = byteData.buffer.asUint8List();

      final pdfBytes = await SafetyInspectionPdfService.generatePdf(
        formData,
        logoImageBytes: logoBytes,
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'safety-inspection-report.pdf',
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

// Separate StatefulWidget for dialog to manage controller lifecycle
class _IndividualSelectionDialog extends StatefulWidget {
  final String itemName;
  final String cleanItemName;
  final List<String> options;
  final Map<String, String> initialSelections;
  final Map<String, Map<String, String>> inspectionData;
  final Map<String, String> selectedValues;
  final SafetyInspectionModel formData;
  final List<String> actionButtonDropdownOptions;
  final Function(Map<String, String>) onSave;

  const _IndividualSelectionDialog({
    required this.itemName,
    required this.cleanItemName,
    required this.options,
    required this.initialSelections,
    required this.inspectionData,
    required this.selectedValues,
    required this.formData,
    required this.actionButtonDropdownOptions,
    required this.onSave,
  });

  @override
  State<_IndividualSelectionDialog> createState() => _IndividualSelectionDialogState();
}

class _IndividualSelectionDialogState extends State<_IndividualSelectionDialog> {
  late Map<String, String> tempSelections;
  late Map<String, TextEditingController> textControllers;

  @override
  void initState() {
    super.initState();
    tempSelections = Map.from(widget.initialSelections);
    
    // Create text controllers for text fields
    textControllers = {};
    for (var option in widget.options) {
      bool isTextField = option == '% Percent' || 
                        option == 'Due Date' || 
                        (option == 'Item inspected' && 
                         (widget.cleanItemName == 'Service Brake Performance' || 
                          widget.cleanItemName == 'Brake Performance' || 
                          widget.cleanItemName == 'Parking Brake Performance' ||
                          widget.cleanItemName == 'Vehicle excise duty' ||
                          widget.cleanItemName == 'PSV' ||
                          widget.cleanItemName == 'Technograph calibration'));
      if (isTextField) {
        textControllers[option] = TextEditingController(text: tempSelections[option] ?? '');
      }
    }
  }

  @override
  void dispose() {
    // Dispose all text controllers when widget is disposed
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSave() {
    // Update tempSelections with text field values before saving
    for (var entry in textControllers.entries) {
      if (entry.value.text.isNotEmpty) {
        tempSelections[entry.key] = entry.value.text;
      } else {
        tempSelections.remove(entry.key);
      }
    }
    
    widget.onSave(tempSelections);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                  icon: const Icon(Icons.close, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ...widget.options.map((option) {
              // Check if this option should be a text field
              bool isTextField = option == '% Percent' || 
                                option == 'Due Date' || 
                                (option == 'Item inspected' && 
                                 (widget.cleanItemName == 'Service Brake Performance' || 
                                  widget.cleanItemName == 'Brake Performance' || 
                                  widget.cleanItemName == 'Parking Brake Performance' ||
                                  widget.cleanItemName == 'Vehicle excise duty' ||
                                  widget.cleanItemName == 'PSV' ||
                                  widget.cleanItemName == 'Technograph calibration'));
              
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
                      child: isTextField
                          ? TextField(
                              controller: textControllers[option],
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    tempSelections.remove(option);
                                  } else {
                                    tempSelections[option] = value;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Enter",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontFamily: "PolySans",
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                isDense: true,
                              ),
                              style: const TextStyle(
                                fontFamily: "PolySans",
                                fontSize: 12,
                              ),
                            )
                          : DropdownButtonHideUnderline(
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
                                items: widget.actionButtonDropdownOptions.map((String value) {
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
                                  setState(() {
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
                onPressed: _handleSave,
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
  }
}