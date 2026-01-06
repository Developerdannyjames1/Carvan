// import 'dart:io';
// import 'dart:typed_data';

// import 'package:data/models/static_carvan_service_model.dart';
// import 'package:data/services/static_carvan_service_pdf.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:printing/printing.dart';

// class StepController extends GetxController {
//   var currentStep = 0.obs;
//   var stepStatus = <int, String>{}.obs;
//   var isViewingFromSummary = false.obs;

//   void nextStep() {
//     if (currentStep.value < 12) {
//       currentStep.value++;
//     }
//   }

//   void previousStep() {
//     if (currentStep.value > 0) {
//       currentStep.value--;
//     }
//   }

//   void goToStep(int step) {
//     if (step >= 0 && step <= 13) {
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

// class StaticCarvanServiceForm extends StatefulWidget {
//   @override
//   _StaticCarvanServiceFormState createState() => _StaticCarvanServiceFormState();
// }

// class _StaticCarvanServiceFormState extends State<StaticCarvanServiceForm> {
//   final StaticCarvanServiceModel formData = StaticCarvanServiceModel();
//   final List<String> statusOptions = ['P', 'F', 'N/A', 'R'];
//   final StepController stepController = Get.put(StepController());

//   // Image handling variables for main logo
//   File? _selectedImage;
//   Uint8List? _imageBytes;
//   bool _isUploading = false;

//   // Bodywork attachment variables
//   File? _bodyworkSelectedImage;
//   Uint8List? _bodyworkImageBytes;
//   bool _isBodyworkUploading = false;

//   final List<String> stepTitles = [
//     'Main Information',
//     'Customer Info',
//     'Underbody',
//     'Electrical System',
//     'Gas System',
//     'Water System',
//     'Bodywork',
//     'Ventilation',
//     'Fire & Safety',
//     'Smoke/CO Alarms',
//     'Additional Information',
//     'Battery Info',
//     'Finalization',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     for (int i = 0; i < stepTitles.length; i++) {
//       stepController.markStepAsSkipped(i);
//     }
//   }

//   // Method to pick main logo image
//   Future<void> _pickImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//         maxWidth: 800,
//       );

//       if (image != null) {
//         setState(() {
//           _isUploading = true;
//         });

//         final File imageFile = File(image.path);
//         final Uint8List bytes = await imageFile.readAsBytes();

//         setState(() {
//           _selectedImage = imageFile;
//           _imageBytes = bytes;
//           _isUploading = false;
//         });
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//       setState(() {
//         _isUploading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to pick image: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // Method to remove main logo image
//   void _removeImage() {
//     setState(() {
//       _selectedImage = null;
//       _imageBytes = null;
//     });
//   }

//   // Method to pick bodywork image
//   Future<void> _pickBodyworkImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//         maxWidth: 800,
//       );

//       if (image != null) {
//         setState(() {
//           _isBodyworkUploading = true;
//         });

//         final File imageFile = File(image.path);
//         final Uint8List bytes = await imageFile.readAsBytes();

//         setState(() {
//           _bodyworkSelectedImage = imageFile;
//           _bodyworkImageBytes = bytes;
//           formData.bodyworkAttachment = imageFile;
//           _isBodyworkUploading = false;
//         });
//       }
//     } catch (e) {
//       print('Error picking bodywork image: $e');
//       setState(() {
//         _isBodyworkUploading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to pick image: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // Method to remove bodywork image
//   void _removeBodyworkImage() {
//     setState(() {
//       _bodyworkSelectedImage = null;
//       _bodyworkImageBytes = null;
//       formData.bodyworkAttachment = null;
//     });
//   }

//   // Updated PDF export method
//   void _exportToPdf() async {
//     try {
//       setState(() {
//         _isUploading = true;
//       });

//       final pdfBytes = await StaticCarvanServicePDF.generatePdf(
//         formData,
//         logoImageBytes: _imageBytes,
//         bodyworkImageBytes: _bodyworkImageBytes,
//       );

//       await Printing.sharePdf(
//         bytes: pdfBytes,
//         filename: 'static-carvan-service-form.pdf',
//       );

//       setState(() {
//         _isUploading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('PDF generated successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print('Error generating PDF: $e');
//       setState(() {
//         _isUploading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to generate PDF: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // Show 240V Appliances Dialog
//   void _show240VAppliancesDialog(BuildContext context, bool isSmallScreen) {
//     Map<String, String> tempSelections = {};
    
//     tempSelections['230V consumer unit load test RCD'] = 
//         formData.electricalSystem['230V consumer unit load test RCD'] ?? '';
//     tempSelections['Earth bonding continuity test'] = 
//         formData.electricalSystem['Earth bonding continuity test'] ?? '';
//     tempSelections['230V sockets'] = 
//         formData.electricalSystem['230V sockets'] ?? '';
//     tempSelections['Hob/Cooker Mains Test'] = 
//         formData.electricalSystem['Hob/Cooker Mains Test'] ?? '';
//     tempSelections['Water Heater Mains Test'] = 
//         formData.electricalSystem['Water Heater Mains Test'] ?? '';
//     tempSelections['Room Heater Mains Test'] = 
//         formData.electricalSystem['Room Heater Mains Test'] ?? '';
//     tempSelections['230V & 12V fridge operation'] = 
//         formData.electricalSystem['230V & 12V fridge operation'] ?? '';
//     tempSelections['Check all aftermarket items'] = 
//         formData.electricalSystem['Check all aftermarket items'] ?? '';

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               insetPadding: const EdgeInsets.all(20),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "240 V Appliances",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontFamily: "PolySans",
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, size: 22),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 25),

//                     // 230V RCD Load Test
//                     _buildDialogDropdownField(
//                       label: 'Select* 230V RCD Load Test',
//                       value: tempSelections['230V consumer unit load test RCD']!,
//                       onChanged: (newValue) {
//                         setModalState(() {
//                           tempSelections['230V consumer unit load test RCD'] = newValue!;
//                         });
//                       },
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     const SizedBox(height: 12),

//                     // Earth bonding continuity test
//                     _buildDialogDropdownField(
//                       label: 'Select* Earth bonding continuity test',
//                       value: tempSelections['Earth bonding continuity test']!,
//                       onChanged: (newValue) {
//                         setModalState(() {
//                           tempSelections['Earth bonding continuity test'] = newValue!;
//                         });
//                       },
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     const SizedBox(height: 12),

//                     // 230V sockets
//                     _buildDialogDropdownField(
//                       label: 'Select* 230V sockets',
//                       value: tempSelections['230V sockets']!,
//                       onChanged: (newValue) {
//                         setModalState(() {
//                           tempSelections['230V sockets'] = newValue!;
//                         });
//                       },
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     const SizedBox(height: 20),

//                     // Hob/Cooker Mains Test
//                     _buildDialogDropdownField(
//                       label: 'Select* Hob/Cooker Mains Test',
//                       value: tempSelections['Hob/Cooker Mains Test']!,
//                       onChanged: (newValue) {
//                         setModalState(() {
//                           tempSelections['Hob/Cooker Mains Test'] = newValue!;
//                         });
//                       },
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     const SizedBox(height: 12),

//                     // Water Heater Mains Test
//                     _buildDialogDropdownField(
//                       label: 'Select* Water Heater Mains Test',
//                       value: tempSelections['Water Heater Mains Test']!,
//                       onChanged: (newValue) {
//                         setModalState(() {
//                           tempSelections['Water Heater Mains Test'] = newValue!;
//                         });
//                       },
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     const SizedBox(height: 12),

//                     // Room Heater Mains Test
//                     _buildDialogDropdownField(
//                       label: 'Select* Room Heater Mains Test',
//                       value: tempSelections['Room Heater Mains Test']!,
//                       onChanged: (newValue) {
//                         setModalState(() {
//                           tempSelections['Room Heater Mains Test'] = newValue!;
//                         });
//                       },
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     const SizedBox(height: 12),

//                     // 230V fridge operation
//                     _buildDialogDropdownField(
//                       label: 'Select* 230V fridge operation',
//                       value: tempSelections['230V & 12V fridge operation']!,
//                       onChanged: (newValue) {
//                         setModalState(() {
//                           tempSelections['230V & 12V fridge operation'] = newValue!;
//                         });
//                       },
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     const SizedBox(height: 20),

//                     // Aftermarket Items
//                     _buildDialogDropdownField(
//                       label: 'Select* Aftermarket Items',
//                       value: tempSelections['Check all aftermarket items']!,
//                       onChanged: (newValue) {
//                         setModalState(() {
//                           tempSelections['Check all aftermarket items'] = newValue!;
//                         });
//                       },
//                       isSmallScreen: isSmallScreen,
//                     ),

//                     const SizedBox(height: 18),

//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             formData.electricalSystem['230V consumer unit load test RCD'] = 
//                                 tempSelections['230V consumer unit load test RCD']!;
//                             formData.electricalSystem['Earth bonding continuity test'] = 
//                                 tempSelections['Earth bonding continuity test']!;
//                             formData.electricalSystem['230V sockets'] = 
//                                 tempSelections['230V sockets']!;
//                             formData.electricalSystem['Hob/Cooker Mains Test'] = 
//                                 tempSelections['Hob/Cooker Mains Test']!;
//                             formData.electricalSystem['Water Heater Mains Test'] = 
//                                 tempSelections['Water Heater Mains Test']!;
//                             formData.electricalSystem['Room Heater Mains Test'] = 
//                                 tempSelections['Room Heater Mains Test']!;
//                             formData.electricalSystem['230V & 12V fridge operation'] = 
//                                 tempSelections['230V & 12V fridge operation']!;
//                             formData.electricalSystem['Check all aftermarket items'] = 
//                                 tempSelections['Check all aftermarket items']!;
//                           });
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xff173EA6),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           "Save",
//                           style: TextStyle(
//                             fontFamily: "PolySans",
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//   // Build Dialog Dropdown Field
//   Widget _buildDialogDropdownField({
//     required String label,
//     required String value,
//     required Function(String?) onChanged,
//     required bool isSmallScreen,
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontFamily: "PolySans",
//               fontSize: 14,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Container(
//           width: 80,
//           height: 40,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: Colors.grey.shade300,
//             ),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value.isEmpty ? null : value,
//               alignment: Alignment.center,
//               isExpanded: true,
//               items: statusOptions.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Center(
//                     child: Text(
//                       value,
//                       style: const TextStyle(
//                         fontFamily: "PolySans",
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
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
//                 IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//             onPressed: () => Get.back(),
//           ),
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
//                       stepController.currentStep.value == 13
//                           ? '(SUMMARY)'
//                           : '(STEP ${stepController.currentStep.value + 1} OF 13)',
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
//                   if (currentStep == 13) {
//                     return _buildSummaryScreen(isSmallScreen);
//                   }
//                   return _buildStepContent(currentStep, width);
//                 }),
//               ),
//             ),

//             Obx(() {
//               bool isViewingFromSummary = stepController.isViewingFromSummary.value;
//               int currentStep = stepController.currentStep.value;

//               if (isViewingFromSummary && currentStep < 13) {
//                 return Container(
//                   padding: const EdgeInsets.all(20),
//                   color: const Color(0xFFF8F8F8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () {
//                             stepController.setViewingFromSummary(false);
//                             stepController.goToStep(13);
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
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             stepController.markStepAsFilled(currentStep);
//                             stepController.setViewingFromSummary(false);
//                             stepController.goToStep(13);
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

//               return Container(
//                 padding: const EdgeInsets.all(20),
//                 color: const Color(0xFFF8F8F8),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         if (currentStep > 0 && currentStep < 13)
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

//                         if (currentStep < 12)
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

//                     if (currentStep < 12)
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
//                     else if (currentStep == 12)
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             stepController.markStepAsFilled(12);
//                             stepController.goToStep(13);
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
//                       SizedBox(
//                         width: double.infinity,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xff173EA6), Color(0xff091840)],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: ElevatedButton(
//                             onPressed: _exportToPdf,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 24,
//                                 vertical: 16,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               'Create A PDF',
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 16 : 18,
//                                 fontWeight: FontWeight.w600,
//                                 fontFamily: 'PolySans',
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
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
//           Column(
//             children: [
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     stepController.setViewingFromSummary(false);
//                     stepController.goToStep(12);
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
//           Expanded(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   stepTitles[index],
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 16 : 17,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: "PolySans",
//                     color: isFilled ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
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

//   Widget _buildFormContainer(Widget child, bool isSmallScreen) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(minHeight: 430),
//         child: Container(
//           margin: EdgeInsets.all(isSmallScreen ? 8 : 16),
//           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }

//   Widget _buildStepContent(int step, double width) {
//     bool isSmallScreen = width < 600;

//     switch (step) {
//       case 0:
//         return _buildMainInformationSection(isSmallScreen);
//       case 1:
//         return _buildCustomerInfoSection(isSmallScreen);
//       case 2:
//         return _buildChassisRunningGearSection(isSmallScreen);
//       case 3:
//         return _buildElectricalSystemSection(isSmallScreen);
//       case 4:
//         return _buildGasSystemSection(isSmallScreen);
//       case 5:
//         return _buildWaterSystemSection(isSmallScreen);
//       case 6:
//         return _buildBodyworkSection(isSmallScreen);  
//       case 7:
//         return _buildVentilationSection(isSmallScreen);
//       case 8:
//         return _buildFireAndSafetySection(isSmallScreen);
//       case 9:
//         return _buildSmokeCarbonMonoxideSection(isSmallScreen);
//       case 10:
//         return _buildAdditionalInformationSection(isSmallScreen);
//       case 11:
//         return _buildBatteryInfoSection(isSmallScreen);
//       case 12:
//         return _buildFinalizationSection(isSmallScreen);
//       default:
//         return Container();
//     }
//   }

//   Widget _buildBatteryInfoSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Battery Info',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 20),
          
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* RCD Test 1x1',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.rcdTest1x1 = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* RCD Test 5 Times',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.rcdTest5Times = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Earth Bond Chassis',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.earthBondChassis = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Continuity Test Gas',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.continuityTestGas = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Gas Hose Expiry Date',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.gasHoseExpiryDate = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Regulator Age',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.regulatorAge = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 120 : 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Comments (Optional)',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.comments = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildMainInformationSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Main Information',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 25),
//           Container(
//             height: 160,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: _isUploading
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 12),
//                         Text(
//                           "Uploading...",
//                           style: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontFamily: 'PolySans',
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : InkWell(
//                     onTap: _pickImage,
//                     borderRadius: BorderRadius.circular(12),
//                     child: Center(
//                       child: _selectedImage != null
//                           ? Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.file(
//                                     _selectedImage!,
//                                     width: 120,
//                                     height: 120,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 4,
//                                   right: 4,
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       color: Colors.black54,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: IconButton(
//                                       icon: const Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                       onPressed: _removeImage,
//                                       padding: EdgeInsets.zero,
//                                       constraints: const BoxConstraints(
//                                         minWidth: 24,
//                                         minHeight: 24,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.attach_file,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       "Add* Attachments",
//                                       style: TextStyle(
//                                         color: Colors.grey.shade600,
//                                         fontFamily: 'PolySans',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   "File Type: JPG, PNG, JPEG",
//                                   style: TextStyle(
//                                     color: Colors.grey.shade500,
//                                     fontSize: 11,
//                                     fontFamily: 'PolySans',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//           ),
//           const SizedBox(height: 20),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 50 : 55,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: 'Enter* Approved Workshop Name & Address',
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     isDense: true,
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 12 : 14,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 12 : 14,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) => formData.workshopName = value,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 50 : 55,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: 'Enter* Job Reference/Date',
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     isDense: true,
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) => formData.jobReference = value,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//  Widget _buildCustomerInfoSection(bool isSmallScreen) {
//   return _buildFormContainer(
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Customer Information',
//           style: TextStyle(
//             fontSize: isSmallScreen ? 20 : 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//             fontFamily: 'PolySans',
//           ),
//         ),
//         const SizedBox(height: 25),
//         Container(
//           height: isSmallScreen ? 50 : 55,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: TextFormField(
//             decoration: InputDecoration(
//               hintText: 'Enter* Customer Name',
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//               isDense: true,
//               hintStyle: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: isSmallScreen ? 14 : 16,
//                 fontFamily: 'PolySans',
//               ),
//             ),
//             style: TextStyle(
//               fontSize: isSmallScreen ? 14 : 16,
//               fontFamily: 'PolySans',
//             ),
//             onChanged: (value) => formData.customerName = value,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           height: isSmallScreen ? 50 : 55,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: TextFormField(
//             decoration: InputDecoration(
//               hintText: 'Enter* Make & Model',
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//               isDense: true,
//               hintStyle: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: isSmallScreen ? 14 : 16,
//                 fontFamily: 'PolySans',
//               ),
//             ),
//             style: TextStyle(
//               fontSize: isSmallScreen ? 14 : 16,
//               fontFamily: 'PolySans',
//             ),
//             onChanged: (value) => formData.makeModel = value,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           height: isSmallScreen ? 50 : 55,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: TextFormField(
//             decoration: InputDecoration(
//               hintText: 'Enter* CRIS/Vin Number',
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//               isDense: true,
//               hintStyle: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: isSmallScreen ? 14 : 16,
//                 fontFamily: 'PolySans',
//               ),
//             ),
//             style: TextStyle(
//               fontSize: isSmallScreen ? 14 : 16,
//               fontFamily: 'PolySans',
//             ),
//             onChanged: (value) => formData.crisVinNumber = value,  // Fixed this line
//           ),
//         ),
//         const SizedBox(height: 16),
//       ],
//     ),
//     isSmallScreen,
//   );
// }

//   Widget _buildChassisRunningGearSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Underbody',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 20),
//           ...formData.chassisRunningGear.entries.map(
//             (entry) => _buildStatusField(entry.key, entry.value, (value) {
//               setState(() {
//                 formData.chassisRunningGear[entry.key] = value;
//               });
//             }, isSmallScreen),
//           ),
//           const SizedBox(height: 24),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 120 : 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     hintText: 'Enter* Comments (Optional)',
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     alignLabelWithHint: true,
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   maxLines: 3,
//                   onChanged: (value) {
//                     setState(() {
//                       formData.underbodyComments = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildElectricalSystemSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Electrical System',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildVoltageRow(
//             label: '240 V*',
//             hint: 'Appliances',
//             isSmallScreen: isSmallScreen,
//             onTap: () {
//               _show240VAppliancesDialog(context, isSmallScreen);
//             },
//           ),
//           const SizedBox(height: 24),
//           Container(
//             height: isSmallScreen ? 140 : 140,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(4),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: TextFormField(
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: 'Enter* Comments (Optional)',
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.all(16),
//                 hintStyle: TextStyle(
//                   fontSize: isSmallScreen ? 14 : 16,
//                   color: Colors.grey.shade600,
//                   fontFamily: 'PolySans',
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   formData.electricalSystemComments = value;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildVoltageRow({
//     required String label,
//     required String hint,
//     required bool isSmallScreen,
//     required VoidCallback onTap,
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: isSmallScreen ? 48 : 56,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(4),
//                 bottomLeft: Radius.circular(4),
//               ),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: RichText(
//                 text: TextSpan(
//                   text: '$label ',
//                   style: const TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: hint,
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.normal,
//                         fontFamily: 'PolySans',
//                         fontSize: isSmallScreen ? 14 : 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         InkWell(
//           onTap: onTap,
//           child: Container(
//             height: isSmallScreen ? 48 : 56,
//             width: isSmallScreen ? 48 : 56,
//             decoration: const BoxDecoration(
//               color: Color(0xFF1E40AF),
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(4),
//                 bottomRight: Radius.circular(4),
//               ),
//             ),
//             child: const Icon(Icons.open_in_new, color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWaterSystemSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Water System',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildStatusField(
//             'Select* Water Pump & Pressure',
//             formData.waterSystem['Water Pump & Pressure'] ?? '',
//             (value) {
//               setState(() {
//                 formData.waterSystem['Water Pump & Pressure'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* Taps, Valve, Pipes & Tank',
//             formData.waterSystem['Taps, Valve, Pipes & Tank'] ?? '',
//             (value) {
//               setState(() {
//                 formData.waterSystem['Taps, Valve, Pipes & Tank'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* Water Inlets',
//             formData.waterSystem['Water Inlets'] ?? '',
//             (value) {
//               setState(() {
//                 formData.waterSystem['Water Inlets'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* Waste System',
//             formData.waterSystem['Waste System'] ?? '',
//             (value) {
//               setState(() {
//                 formData.waterSystem['Waste System'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* Toilet',
//             formData.waterSystem['Toilet'] ?? '',
//             (value) {
//               setState(() {
//                 formData.waterSystem['Toilet'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 120 : 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.all(16),
//                     hintText: 'Enter* Comments (Optional)',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   maxLines: 4,
//                   onChanged: (value) {
//                     setState(() {
//                       formData.waterSystemComments = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildBodyworkSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Body Work', 
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildStatusField(
//             'Select* Doors & Windows',
//             formData.bodywork['Doors & Windows'] ?? '',
//             (value) {
//               setState(() {
//                 formData.bodywork['Doors & Windows'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* General Roof Condition',
//             formData.bodywork['General Roof Condition'] ?? '',
//             (value) {
//               setState(() {
//                 formData.bodywork['General Roof Condition'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* External Seals',
//             formData.bodywork['External Seals'] ?? '',
//             (value) {
//               setState(() {
//                 formData.bodywork['External Seals'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* Floor',
//             formData.bodywork['Floor'] ?? '',
//             (value) {
//               setState(() {
//                 formData.bodywork['Floor'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* Furniture',
//             formData.bodywork['Furniture'] ?? '',
//             (value) {
//               setState(() {
//                 formData.bodywork['Furniture'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* Damp Test',
//             formData.bodywork['Damp Test'] ?? '',
//             (value) {
//               setState(() {
//                 formData.bodywork['Damp Test'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 10),
//           _buildStatusField(
//             'Select* Rising Roof',
//             formData.bodywork['Rising Roof'] ?? '',
//             (value) {
//               setState(() {
//                 formData.bodywork['Rising Roof'] = value;
//               });
//             },
//             isSmallScreen,
//           ),
//           const SizedBox(height: 20),
//           Container(
//             height: 160,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: _isBodyworkUploading
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 12),
//                         Text(
//                           "Uploading...",
//                           style: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontFamily: 'PolySans',
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : InkWell(
//                     onTap: _pickBodyworkImage,
//                     borderRadius: BorderRadius.circular(12),
//                     child: Center(
//                       child: _bodyworkSelectedImage != null
//                           ? Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.file(
//                                     _bodyworkSelectedImage!,
//                                     width: 120,
//                                     height: 120,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 4,
//                                   right: 4,
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       color: Colors.black54,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: IconButton(
//                                       icon: const Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                       onPressed: _removeBodyworkImage,
//                                       padding: EdgeInsets.zero,
//                                       constraints: const BoxConstraints(
//                                         minWidth: 24,
//                                         minHeight: 24,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.attach_file,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       "Add* Body Attachment",
//                                       style: TextStyle(
//                                         color: Colors.grey.shade600,
//                                         fontFamily: 'PolySans',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   "File Type: JPG, PNG, JPEG",
//                                   style: TextStyle(
//                                     color: Colors.grey.shade500,
//                                     fontSize: 11,
//                                     fontFamily: 'PolySans',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//           ),
//           const SizedBox(height: 20),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 120 : 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.all(16),
//                     hintText: 'Enter* Comments (Optional)',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   maxLines: 4,
//                   onChanged: (value) {
//                     setState(() {
//                       formData.bodyworkComments = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildVentilationSection(bool isSmallScreen) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildFormContainer(
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Ventilation',
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 20 : 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontFamily: 'PolySans',
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ...formData.ventilation.entries.map(
//                   (entry) => _buildStatusField(entry.key, entry.value, (value) {
//                     setState(() {
//                       formData.ventilation[entry.key] = value;
//                     });
//                   }, isSmallScreen),
//                 ),
//                 const SizedBox(height: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: isSmallScreen ? 140 : 140,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey.shade400),
//                       ),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.all(16),
//                           hintText: 'Enter* Comments (Optional)',
//                           hintStyle: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontSize: isSmallScreen ? 14 : 16,
//                             fontFamily: 'PolySans',
//                           ),
//                         ),
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 14 : 16,
//                           fontFamily: 'PolySans',
//                         ),
//                         maxLines: 4,
//                         onChanged: (value) {
//                           setState(() {
//                             formData.ventilationComments = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             isSmallScreen,
//           ),      
//         ],
//       ),
//     );
//   }

//   Widget _buildFireAndSafetySection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Fire & Safety',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//           ),
//         ),
//         const SizedBox(height: 20),
//         _buildStatusField(
//           'Select* Press Test Button On Smoke',
//           formData.fireSafety['Press Test Button On Smoke'] ?? '',
//           (value) {
//             setState(() {
//               formData.fireSafety['Press Test Button On Smoke'] = value;
//             });
//           },
//           isSmallScreen,
//         ),
//         const SizedBox(height: 10),
//         _buildStatusField(
//           'Select* Press Test Button CO Alarm',
//           formData.fireSafety['Press Test Button CO Alarm'] ?? '',
//           (value) {
//             setState(() {
//               formData.fireSafety['Press Test Button CO Alarm'] = value;
//             });
//           },
//           isSmallScreen,
//         ),
//         const SizedBox(height: 10),
//         _buildStatusField(
//           'Select* If A Fire Extinguisher is Fitted',
//           formData.fireSafety['If A Fire Extinguisher is Fitted'] ?? '',
//           (value) {
//             setState(() {
//               formData.fireSafety['If A Fire Extinguisher is Fitted'] = value;
//             });
//           },
//           isSmallScreen,
//         ),
//         const SizedBox(height: 10),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: isSmallScreen ? 120 : 120,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade400),
//               ),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.all(16),
//                   hintText: 'Enter* Comments (Optional)',
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
//                 maxLines: 4,
//                 onChanged: (value) {
//                   setState(() {
//                     formData.fireSafetyComments = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//     isSmallScreen,
//   );
// }

//   Widget _buildGasSystemSection(bool isSmallScreen) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildFormContainer(
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'LPG Gas System',
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 20 : 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontFamily: 'PolySans',
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildStatusField(
//                   'Select* Regulator, Gas Hose, Pipe..',
//                   formData.gasSystem['Regulator, Gas Hose, Pipe..'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['Regulator, Gas Hose, Pipe..'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 _buildStatusField(
//                   'Select* Gas Tightness Check',
//                   formData.gasSystem['Gas Tightness Check'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['Gas Tightness Check'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 _buildStatusField(
//                   'Select* Gas Dispersal Vents',
//                   formData.gasSystem['Gas Dispersal Vents'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['Gas Dispersal Vents'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 _buildStatusField(
//                   'Select* Security Of Gas Cylinder',
//                   formData.gasSystem['Security Of Gas Cylinder'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['Security Of Gas Cylinder'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 _buildStatusField(
//                   'Select* Operation of Fridge & FF',
//                   formData.gasSystem['Operation of Fridge & FF'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['Operation of Fridge & FF'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 _buildStatusField(
//                   'Check* Operation of Hob/Cooker & FF',
//                   formData.gasSystem['Operation of Hob/Cooker & FF'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['Operation of Hob/Cooker & FF'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 _buildStatusField(
//                   'Check* Operation of Space Heater & FF',
//                   formData.gasSystem['Operation of Space Heater & FF'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['Operation of Space Heater & FF'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 _buildStatusField(
//                   'Check* Operation of Water Heater & FF',
//                   formData.gasSystem['Operation of Water Heater & FF'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['Operation of Water Heater & FF'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 _buildStatusField(
//                   'Select* CO Test',
//                   formData.gasSystem['CO Test'] ?? '',
//                   (value) {
//                     setState(() {
//                       formData.gasSystem['CO Test'] = value;
//                     });
//                   },
//                   isSmallScreen,
//                 ),
//                 const SizedBox(height: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: isSmallScreen ? 120 : 120,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey.shade400),
//                       ),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.all(16),
//                           hintText: 'Enter* Comments (Optional)',
//                           hintStyle: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontSize: isSmallScreen ? 14 : 16,
//                             fontFamily: 'PolySans',
//                           ),
//                         ),
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 14 : 16,
//                           fontFamily: 'PolySans',
//                         ),
//                         maxLines: 4,
//                         onChanged: (value) {
//                           setState(() {
//                             formData.gasSystemComments = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             isSmallScreen,
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildSmokeCarbonMonoxideSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Smoke/Carbon Monoxide',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 20),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Smoke Alarm Expiry Date',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.smokeAlarmExpiryDate = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Carbon Monoxide Alarm Expiry Date',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.carbonMonoxideAlarmExpiryDate = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Fire Extinguisher Expiry Date',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.fireExtinguisherExpiryDate = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 120 : 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.all(16),
//                     hintText: 'Enter* Comments (Optional)',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   maxLines: 4,
//                   onChanged: (value) {
//                     setState(() {
//                       formData.smokeCOAlarmComments = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildAdditionalInformationSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Additional Information',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//             ),
//           ),
//           const SizedBox(height: 20),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Customer Name',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.additionalCustomerName = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Make & Model',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.additionalMakeModel = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 45 : 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     hintText: 'Enter* Vin Number',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       formData.additionalVinNumber = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 100 : 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.all(16),
//                     hintText: 'Enter* Service Information:',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   maxLines: 4,
//                   onChanged: (value) {
//                     setState(() {
//                       formData.additionalServiceInfo = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: isSmallScreen ? 120 : 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.all(16),
//                     hintText: 'Enter* Comments (Optional)',
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontFamily: 'PolySans',
//                     ),
//                   ),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontFamily: 'PolySans',
//                   ),
//                   maxLines: 4,
//                   onChanged: (value) {
//                     setState(() {
//                       formData.additionalComments = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       isSmallScreen,
//     );
//   }

//   Widget _buildFinalizationSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Finalization',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//           ),
//         ),
//         const SizedBox(height: 20),
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
//                 onChanged: (value) {
//                   setState(() {
//                     formData.serviceTechnicianName = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
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
//                 onChanged: (value) {
//                   setState(() {
//                     formData.customerSignature = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
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
//                 onChanged: (value) {
//                   setState(() {
//                     formData.signature = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
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
//                 onChanged: (value) {
//                   setState(() {
//                     formData.date = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//     isSmallScreen,
//   );
// }

//   Widget _buildStatusField(
//     String label,
//     String value,
//     Function(String) onChanged,
//     bool isSmallScreen,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: isSmallScreen ? 14 : 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade800,
//                 fontFamily: 'PolySans',
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             flex: 1,
//             child: Container(
//               height: isSmallScreen ? 45 : 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade400),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: value.isEmpty ? null : value,
//                   alignment: Alignment.center,
//                   isExpanded: true,
//                   items: statusOptions.map((String status) {
//                     return DropdownMenuItem<String>(
//                       value: status,
//                       child: Center(
//                         child: Text(
//                           status,
//                           style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) => onChanged(newValue ?? ''),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showExitConfirmation() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Exit Form?', style: TextStyle(fontFamily: 'PolySans')),
//         content: const Text(
//           'Are you sure you want to go back? Your progress may not be saved.',
//           style: TextStyle(fontFamily: 'PolySans'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontFamily: 'PolySans',
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             child: const Text(
//               'Exit',
//               style: TextStyle(
//                 color: Color(0xff173EA6),
//                 fontFamily: 'PolySans',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:io';
import 'dart:typed_data';

import 'package:data/models/static_carvan_service_model.dart';
import 'package:data/services/static_carvan_service_pdf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';

class StepController extends GetxController {
  var currentStep = 0.obs;
  var stepStatus = <int, String>{}.obs;
  var isViewingFromSummary = false.obs;

  void nextStep() {
    if (currentStep.value < 12) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 13) {
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

class StaticCarvanServiceForm extends StatefulWidget {
  @override
  _StaticCarvanServiceFormState createState() => _StaticCarvanServiceFormState();
}

class _StaticCarvanServiceFormState extends State<StaticCarvanServiceForm> {
  final StaticCarvanServiceModel formData = StaticCarvanServiceModel();
  final List<String> statusOptions = ['P', 'F', 'N/A', 'R'];
  final StepController stepController = Get.put(StepController());

  // Image handling variables for main logo
  File? _selectedImage;
  Uint8List? _imageBytes;
  bool _isUploading = false;

  // Bodywork attachment variables
  File? _bodyworkSelectedImage;
  Uint8List? _bodyworkImageBytes;
  bool _isBodyworkUploading = false;

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

  // TextEditingController instances for all text fields
  late TextEditingController _workshopNameController;
  late TextEditingController _jobReferenceController;
  late TextEditingController _customerNameController;
  late TextEditingController _makeModelController;
  late TextEditingController _workShopNameController;
  late TextEditingController _addressController;
  late TextEditingController _underbodyCommentsController;
  late TextEditingController _electricalSystemCommentsController;
  late TextEditingController _gasSystemCommentsController;
  late TextEditingController _waterSystemCommentsController;
  late TextEditingController _bodyworkCommentsController;
  late TextEditingController _ventilationCommentsController;
  late TextEditingController _fireSafetyCommentsController;
  late TextEditingController _smokeAlarmExpiryDateController;
  late TextEditingController _carbonMonoxideAlarmExpiryDateController;
  late TextEditingController _fireExtinguisherExpiryDateController;
  late TextEditingController _smokeCOAlarmCommentsController;
  late TextEditingController _additionalCustomerNameController;
  late TextEditingController _additionalMakeModelController;
  late TextEditingController _additionalVinNumberController;
  late TextEditingController _additionalServiceInfoController;
  late TextEditingController _additionalCommentsController;
  late TextEditingController _rcdTest1x1Controller;
  late TextEditingController _rcdTest5TimesController;
  late TextEditingController _earthBondChassisController;
  late TextEditingController _continuityTestGasController;
  late TextEditingController _gasHoseExpiryDateController;
  late TextEditingController _regulatorAgeController;
  late TextEditingController _commentsController;
  late TextEditingController _serviceTechnicianNameController;
  late TextEditingController _customerSignatureController;
  late TextEditingController _signatureController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    
    // Initialize all controllers
    _workshopNameController = TextEditingController();
    _jobReferenceController = TextEditingController();
    _customerNameController = TextEditingController();
    _makeModelController = TextEditingController();
    _workShopNameController = TextEditingController();
    _addressController = TextEditingController();
    _underbodyCommentsController = TextEditingController();
    _electricalSystemCommentsController = TextEditingController();
    _gasSystemCommentsController = TextEditingController();
    _waterSystemCommentsController = TextEditingController();
    _bodyworkCommentsController = TextEditingController();
    _ventilationCommentsController = TextEditingController();
    _fireSafetyCommentsController = TextEditingController();
    _smokeAlarmExpiryDateController = TextEditingController();
    _carbonMonoxideAlarmExpiryDateController = TextEditingController();
    _fireExtinguisherExpiryDateController = TextEditingController();
    _smokeCOAlarmCommentsController = TextEditingController();
    _additionalCustomerNameController = TextEditingController();
    _additionalMakeModelController = TextEditingController();
    _additionalVinNumberController = TextEditingController();
    _additionalServiceInfoController = TextEditingController();
    _additionalCommentsController = TextEditingController();
    _rcdTest1x1Controller = TextEditingController();
    _rcdTest5TimesController = TextEditingController();
    _earthBondChassisController = TextEditingController();
    _continuityTestGasController = TextEditingController();
    _gasHoseExpiryDateController = TextEditingController();
    _regulatorAgeController = TextEditingController();
    _commentsController = TextEditingController();
    _serviceTechnicianNameController = TextEditingController();
    _customerSignatureController = TextEditingController();
    _signatureController = TextEditingController();
    _dateController = TextEditingController();

    // Initialize step status
    for (int i = 0; i < stepTitles.length; i++) {
      stepController.markStepAsSkipped(i);
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _workshopNameController.dispose();
    _jobReferenceController.dispose();
    _customerNameController.dispose();
    _makeModelController.dispose();
    _workShopNameController.dispose();
    _addressController.dispose();
    _underbodyCommentsController.dispose();
    _electricalSystemCommentsController.dispose();
    _gasSystemCommentsController.dispose();
    _waterSystemCommentsController.dispose();
    _bodyworkCommentsController.dispose();
    _ventilationCommentsController.dispose();
    _fireSafetyCommentsController.dispose();
    _smokeAlarmExpiryDateController.dispose();
    _carbonMonoxideAlarmExpiryDateController.dispose();
    _fireExtinguisherExpiryDateController.dispose();
    _smokeCOAlarmCommentsController.dispose();
    _additionalCustomerNameController.dispose();
    _additionalMakeModelController.dispose();
    _additionalVinNumberController.dispose();
    _additionalServiceInfoController.dispose();
    _additionalCommentsController.dispose();
    _rcdTest1x1Controller.dispose();
    _rcdTest5TimesController.dispose();
    _earthBondChassisController.dispose();
    _continuityTestGasController.dispose();
    _gasHoseExpiryDateController.dispose();
    _regulatorAgeController.dispose();
    _commentsController.dispose();
    _serviceTechnicianNameController.dispose();
    _customerSignatureController.dispose();
    _signatureController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Method to sync form data with controllers
  void _syncFormData() {
  // Sync all form data from controllers
  formData.workshopName = _workshopNameController.text;
  formData.jobReference = _jobReferenceController.text;
  formData.customerName = _customerNameController.text;
  formData.makeModel = _makeModelController.text;
  formData.workShopName = _workShopNameController.text;
  formData.address = _addressController.text;
  formData.underbodyComments = _underbodyCommentsController.text;
  formData.electricalSystemComments = _electricalSystemCommentsController.text;
  formData.gasSystemComments = _gasSystemCommentsController.text;
  formData.waterSystemComments = _waterSystemCommentsController.text;
  formData.bodyworkComments = _bodyworkCommentsController.text;
  formData.ventilationComments = _ventilationCommentsController.text;
  formData.fireSafetyComments = _fireSafetyCommentsController.text;
  formData.smokeAlarmExpiryDate = _smokeAlarmExpiryDateController.text;
  formData.carbonMonoxideAlarmExpiryDate = _carbonMonoxideAlarmExpiryDateController.text;
  formData.fireExtinguisherExpiryDate = _fireExtinguisherExpiryDateController.text;
  formData.smokeCOAlarmComments = _smokeCOAlarmCommentsController.text;
  formData.additionalCustomerName = _additionalCustomerNameController.text;
  formData.additionalMakeModel = _additionalMakeModelController.text;
  formData.additionalVinNumber = _additionalVinNumberController.text;
  formData.additionalServiceInfo = _additionalServiceInfoController.text;
  formData.additionalComments = _additionalCommentsController.text;
  formData.rcdTest1x1 = _rcdTest1x1Controller.text;
  formData.rcdTest5Times = _rcdTest5TimesController.text;
  formData.earthBondChassis = _earthBondChassisController.text;
  formData.continuityTestGas = _continuityTestGasController.text;
  formData.gasHoseExpiryDate = _gasHoseExpiryDateController.text;
  formData.regulatorAge = _regulatorAgeController.text;
  formData.comments = _commentsController.text;
  formData.serviceTechnicianName = _serviceTechnicianNameController.text;
  formData.customerSignature = _customerSignatureController.text;
  formData.signature = _signatureController.text;
  formData.date = _dateController.text; // Sync date controller
}

  // Method to pick main logo image
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

  // Method to remove main logo image
  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageBytes = null;
    });
  }

  // Method to pick bodywork image
  Future<void> _pickBodyworkImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (image != null) {
        setState(() {
          _isBodyworkUploading = true;
        });

        final File imageFile = File(image.path);
        final Uint8List bytes = await imageFile.readAsBytes();

        setState(() {
          _bodyworkSelectedImage = imageFile;
          _bodyworkImageBytes = bytes;
          formData.bodyworkAttachment = imageFile;
          _isBodyworkUploading = false;
        });
      }
    } catch (e) {
      print('Error picking bodywork image: $e');
      setState(() {
        _isBodyworkUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to remove bodywork image
  void _removeBodyworkImage() {
    setState(() {
      _bodyworkSelectedImage = null;
      _bodyworkImageBytes = null;
      formData.bodyworkAttachment = null;
    });
  }

  // Updated PDF export method
  void _exportToPdf() async {
    try {
      setState(() {
        _isUploading = true;
      });

      // Sync all data before generating PDF
      _syncFormData();

      final pdfBytes = await StaticCarvanServicePDF.generatePdf(
        formData,
        logoImageBytes: _imageBytes,
        bodyworkImageBytes: _bodyworkImageBytes,
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'static-carvan-service-form.pdf',
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
    
    tempSelections['230V consumer unit load test RCD'] = 
        formData.electricalSystem['230V consumer unit load test RCD'] ?? '';
    tempSelections['Earth bonding continuity test'] = 
        formData.electricalSystem['Earth bonding continuity test'] ?? '';
    tempSelections['230V sockets'] = 
        formData.electricalSystem['230V sockets'] ?? '';
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
                    const SizedBox(height: 25),

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
                            formData.electricalSystem['230V consumer unit load test RCD'] = 
                                tempSelections['230V consumer unit load test RCD']!;
                            formData.electricalSystem['Earth bonding continuity test'] = 
                                tempSelections['Earth bonding continuity test']!;
                            formData.electricalSystem['230V sockets'] = 
                                tempSelections['230V sockets']!;
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
              bool isViewingFromSummary = stepController.isViewingFromSummary.value;
              int currentStep = stepController.currentStep.value;

              if (isViewingFromSummary && currentStep < 13) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFFF8F8F8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
          Column(
            children: [
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
                  controller: _rcdTest1x1Controller,
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
                  onChanged: (value) {
                    setState(() {
                      formData.rcdTest1x1 = value;
                    });
                  },
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
                  controller: _rcdTest5TimesController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.rcdTest5Times = value;
                    });
                  },
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
                  controller: _earthBondChassisController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.earthBondChassis = value;
                    });
                  },
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
                  controller: _continuityTestGasController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.continuityTestGas = value;
                    });
                  },
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
                  controller: _gasHoseExpiryDateController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.gasHoseExpiryDate = value;
                    });
                  },
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
                  controller: _regulatorAgeController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.regulatorAge = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                  controller: _commentsController,
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
                  maxLines: 4,
                  onChanged: (value) {
                    setState(() {
                      formData.comments = value;
                    });
                  },
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
                  controller: _workshopNameController,
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
                  onChanged: (value) => formData.workshopName = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                  controller: _jobReferenceController,
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
                  onChanged: (value) => formData.jobReference = value,
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
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: _customerNameController,
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
              onChanged: (value) => formData.customerName = value,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: _makeModelController,
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
              onChanged: (value) => formData.makeModel = value,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: _workShopNameController,
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
              onChanged: (value) => formData.workShopName = value,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: isSmallScreen ? 50 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter* Address',
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
              onChanged: (value) => formData.address = value,
            ),
          ),
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
          ...formData.chassisRunningGear.entries.map(
            (entry) => _buildStatusField(entry.key, entry.value, (value) {
              setState(() {
                formData.chassisRunningGear[entry.key] = value;
              });
            }, isSmallScreen),
          ),
          const SizedBox(height: 24),
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
                  controller: _underbodyCommentsController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.underbodyComments = value;
                    });
                  },
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
          _buildVoltageRow(
            label: '240 V*',
            hint: 'Appliances',
            isSmallScreen: isSmallScreen,
            onTap: () {
              _show240VAppliancesDialog(context, isSmallScreen);
            },
          ),
          const SizedBox(height: 24),
          Container(
            height: isSmallScreen ? 140 : 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: _electricalSystemCommentsController,
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
              onChanged: (value) {
                setState(() {
                  formData.electricalSystemComments = value;
                });
              },
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
                  controller: _waterSystemCommentsController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.waterSystemComments = value;
                    });
                  },
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
          _buildStatusField(
            'Select* Rising Roof',
            formData.bodywork['Rising Roof'] ?? '',
            (value) {
              setState(() {
                formData.bodywork['Rising Roof'] = value;
              });
            },
            isSmallScreen,
          ),
          const SizedBox(height: 20),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _isBodyworkUploading
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
                    onTap: _pickBodyworkImage,
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: _bodyworkSelectedImage != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _bodyworkSelectedImage!,
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
                                      onPressed: _removeBodyworkImage,
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
                                      "Add* Body Attachment",
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
                  controller: _bodyworkCommentsController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.bodyworkComments = value;
                    });
                  },
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
                        controller: _ventilationCommentsController,
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
                        onChanged: (value) {
                          setState(() {
                            formData.ventilationComments = value;
                          });
                        },
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
                controller: _fireSafetyCommentsController,
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
                onChanged: (value) {
                  setState(() {
                    formData.fireSafetyComments = value;
                  });
                },
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
                _buildStatusField(
                  'Select* Regulator, Gas Hose, Pipe..',
                  formData.gasSystem['Regulator, Gas Hose, Pipe..'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Regulator, Gas Hose, Pipe..'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                _buildStatusField(
                  'Select* Gas Tightness Check',
                  formData.gasSystem['Gas Tightness Check'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Gas Tightness Check'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                _buildStatusField(
                  'Select* Gas Dispersal Vents',
                  formData.gasSystem['Gas Dispersal Vents'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Gas Dispersal Vents'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                _buildStatusField(
                  'Select* Security Of Gas Cylinder',
                  formData.gasSystem['Security Of Gas Cylinder'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Security Of Gas Cylinder'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                _buildStatusField(
                  'Select* Operation of Fridge & FF',
                  formData.gasSystem['Operation of Fridge & FF'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Operation of Fridge & FF'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                _buildStatusField(
                  'Check* Operation of Hob/Cooker & FF',
                  formData.gasSystem['Operation of Hob/Cooker & FF'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Operation of Hob/Cooker & FF'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                _buildStatusField(
                  'Check* Operation of Space Heater & FF',
                  formData.gasSystem['Operation of Space Heater & FF'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Operation of Space Heater & FF'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                _buildStatusField(
                  'Check* Operation of Water Heater & FF',
                  formData.gasSystem['Operation of Water Heater & FF'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['Operation of Water Heater & FF'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
                _buildStatusField(
                  'Select* CO Test',
                  formData.gasSystem['CO Test'] ?? '',
                  (value) {
                    setState(() {
                      formData.gasSystem['CO Test'] = value;
                    });
                  },
                  isSmallScreen,
                ),
                const SizedBox(height: 10),
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
                        controller: _gasSystemCommentsController,
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
                        onChanged: (value) {
                          setState(() {
                            formData.gasSystemComments = value;
                          });
                        },
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
                  controller: _smokeAlarmExpiryDateController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.smokeAlarmExpiryDate = value;
                    });
                  },
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
                  controller: _carbonMonoxideAlarmExpiryDateController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.carbonMonoxideAlarmExpiryDate = value;
                    });
                  },
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
                  controller: _fireExtinguisherExpiryDateController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.fireExtinguisherExpiryDate = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                  controller: _smokeCOAlarmCommentsController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.smokeCOAlarmComments = value;
                    });
                  },
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
                  controller: _additionalCustomerNameController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.additionalCustomerName = value;
                    });
                  },
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
                  controller: _additionalMakeModelController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.additionalMakeModel = value;
                    });
                  },
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
                  controller: _additionalVinNumberController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.additionalVinNumber = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                  controller: _additionalServiceInfoController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.additionalServiceInfo = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                  controller: _additionalCommentsController,
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
                  onChanged: (value) {
                    setState(() {
                      formData.additionalComments = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      isSmallScreen,
    );
  }

//   Widget _buildFinalizationSection(bool isSmallScreen) {
//     return _buildFormContainer(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Finalization',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 20 : 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontFamily: 'PolySans',
//           ),
//         ),
//         const SizedBox(height: 20),
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
//                 controller: _serviceTechnicianNameController,
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
//                 onChanged: (value) {
//                   setState(() {
//                     formData.serviceTechnicianName = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
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
//                 controller: _customerSignatureController,
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
//                 onChanged: (value) {
//                   setState(() {
//                     formData.customerSignature = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
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
//                 controller: _signatureController,
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
//                 onChanged: (value) {
//                   setState(() {
//                     formData.signature = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
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
//                 controller: _dateController,
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
//                 onChanged: (value) {
//                   setState(() {
//                     formData.date = value;
//                   });
//                 },
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
                controller: _serviceTechnicianNameController, // Use underscore
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
                onChanged: (value) {
                  setState(() {
                    formData.serviceTechnicianName = value;
                  });
                },
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
                controller: _customerSignatureController, // Use underscore
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
                onChanged: (value) {
                  setState(() {
                    formData.customerSignature = value;
                  });
                },
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
                controller: _signatureController, // Use underscore
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
                onChanged: (value) {
                  setState(() {
                    formData.signature = value;
                  });
                },
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
      _dateController.text = formattedDate; // Use underscore
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
          'Are you sure you want to go back? Your progress may not be saved.',
          style: TextStyle(fontFamily: 'PolySans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
              Navigator.pop(context);
              Navigator.pop(context);
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