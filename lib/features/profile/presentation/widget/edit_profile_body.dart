import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';

class Teacher {
  String id;
  String name;
  String email;
  String phone;
  String specialization;
  String joinDate;
  String imageUrl;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.joinDate,
    required this.imageUrl,
  });
}
class EditProfileBody extends StatefulWidget {
  final Teacher teacher;
  final File? profileImage;
  final Function(File?) onImageChanged;

  const EditProfileBody({
    super.key,
    required this.teacher,
    this.profileImage,
    required this.onImageChanged,
  });

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  late File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.profileImage;
    _nameController.text = widget.teacher.name;
    _specializationController.text = widget.teacher.specialization;
    _emailController.text = widget.teacher.email;
    _phoneController.text = widget.teacher.phone;
    _bioController.text = widget.teacher.specialization;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('edit_profile.change_photo'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('edit_profile.take_photo'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('edit_profile.choose_gallery'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveChanges() {
    widget.teacher.name = _nameController.text;
    widget.teacher.specialization = _specializationController.text;
    widget.teacher.email = _emailController.text;
    widget.teacher.phone = _phoneController.text;
    
    widget.onImageChanged(_selectedImage);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('edit_profile.changes_saved'.tr()),
        duration: const Duration(seconds: 2),
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_profile.title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'edit_profile.save'.tr(),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : AssetImage(widget.teacher.imageUrl) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _showImageSourceDialog,
                        tooltip: 'edit_profile.change_photo'.tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'edit_profile.name'.tr(),
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _specializationController,
              decoration: InputDecoration(
                labelText: 'edit_profile.specialization'.tr(),
                prefixIcon: const Icon(Icons.work),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'edit_profile.email'.tr(),
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'edit_profile.phone'.tr(),
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _bioController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'edit_profile.bio'.tr(),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}