import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schoolo_teacher/app_state.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/utils/strings.dart';
import 'package:schoolo_teacher/core/widgets/custom_text_field.dart';
import 'package:schoolo_teacher/core/widgets/day_selector.dart';
import 'package:schoolo_teacher/core/widgets/profile_picture_picker.dart';
import 'package:schoolo_teacher/core/widgets/section_header.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';

class CompleteProfileBody extends StatefulWidget {
  final dynamic phoneNumber;

  const CompleteProfileBody({super.key, required this.phoneNumber});

  @override
  State<CompleteProfileBody> createState() => _CompleteProfileBodyState();
}

class _CompleteProfileBodyState extends State<CompleteProfileBody> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final List<String> availableSpecialties = [
    'Mathematics',
    'Science',
    'Arabic Language',
    'English Language',
    'History',
    'Geography',
    'Physics',
    'Chemistry',
    'Biology',
    'Islamic Education',
    'Arts',
    'Physical Education',
    'Computer Science',
    'Psychology',
  ];

  XFile? profileImage;
  List<String> _selectedDays = [];
  List<String> _selectedSpecialties = [];

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => profileImage = pickedFile);
    }
  }

  void _showMultiSelect(BuildContext context) async {
    final List<String>? results = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final List<String> selected = List.from(_selectedSpecialties);
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Specialties',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      if (selected.length == availableSpecialties.length) {
                        selected.clear();
                      } else {
                        selected.clear();
                        selected.addAll(availableSpecialties);
                      }
                      setState(() {});
                    },
                    child: Text(
                      selected.length == availableSpecialties.length
                          ? 'Deselect All'
                          : 'Select All',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context, selected),
                    child: Text(
                      'Apply (${selected.length})',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: availableSpecialties.length,
                  itemBuilder: (context, index) {
                    final specialty = availableSpecialties[index];
                    return FilterChip(
                      label: Text(specialty),
                      selected: selected.contains(specialty),
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            selected.add(specialty);
                          } else {
                            selected.remove(specialty);
                          }
                        });
                      },
                      // ignore: deprecated_member_use
                      selectedColor: primaryColor.withOpacity(0.2),
                      checkmarkColor: primaryColor,
                      labelStyle: TextStyle(
                        color: selected.contains(specialty) 
                            ? primaryColor 
                            : Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (results != null) {
      setState(() {
        _selectedSpecialties = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          'Complete Profile', 
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth! / 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth! / 10,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                Center(
                  child: ProfilePicturePicker(
                    primaryColor: primaryColor,
                    onImagePicked: (image) {
                      setState(() => profileImage = image);
                    },
                  ),
                ),
                const VerticalSpace(4),

                // Personal Info Section
                SectionHeader(
                  title: 'Personal Information',
                  padding: EdgeInsets.zero,
                ),
                const VerticalSpace(2),

                // Specialization Field
                GestureDetector(
                  onTap: () => _showMultiSelect(context),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.work_outline, color: primaryColor),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _selectedSpecialties.isEmpty
                                ? 'Select specialties'
                                : _selectedSpecialties.join(', '),
                            style: TextStyle(
                              color: _selectedSpecialties.isEmpty
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_selectedSpecialties.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${_selectedSpecialties.length} selected',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const VerticalSpace(2),

                // Address Field
                CustomTextField(
                  controller: _addressController,
                  label: 'Address',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (v) => v!.isEmpty ? 'Enter your address' : null,
                  borderRadius: 15,
                  focusBorderColor: primaryColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                const VerticalSpace(3),

                // Availability Section
                SectionHeader(
                  title: 'Working Days',
                  padding: EdgeInsets.zero,
                ),
                const VerticalSpace(2),
                DaySelector(
                  availableDays: Strings.availableDays,
                  initialSelectedDays: _selectedDays,
                  primaryColor: primaryColor,
                  onDaysChanged: (selectedDays) {
                    setState(() {
                      _selectedDays = selectedDays;
                    });
                  },
                  title: 'Select your availability:',
                  selectedLabel: 'You selected: ',
                  borderRadius: 16,
                  spacing: 10,
                  runSpacing: 10,
                  titleStyle: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth! / 26,
                  ),
                ),
                if (_selectedDays.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${_selectedDays.length} days selected',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const VerticalSpace(4),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'COMPLETE PROFILE',
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! / 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSpecialties.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one specialty')),
      );
      return;
    }

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one working day')),
      );
      return;
    }

    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile picture')),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      
      // Upload profile image if exists
      if (profileImage != null) {
        // Here you would typically upload the image to your server
        // and get the URL to save in the user's profile
        await Future.delayed(const Duration(seconds: 1)); // Simulate upload
        appState.setProfileImage(profileImage!.path);
      }

      appState.setSelectedSpecialties(_selectedSpecialties);
      appState.setSelectedDays(_selectedDays);
      appState.setAddress(_addressController.text);

      // Close loading dialog
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // Navigate to home
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Close loading dialog
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}