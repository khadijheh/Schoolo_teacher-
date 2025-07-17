import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';

class ProfilePicturePicker extends StatefulWidget {
  final ValueChanged<XFile?> onImagePicked;
  final Color primaryColor;

  const ProfilePicturePicker({
    super.key,
    required this.onImagePicked,
    required this.primaryColor,
  });

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  XFile? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _profileImage = pickedFile);
      widget.onImagePicked(pickedFile);
    }
  }

  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: widget.primaryColor),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: widget.primaryColor),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              child:  Text('Cancel', style: TextStyle(color: primaryColor)),
              onPressed: () => Navigator.pop(context),
            )
      ],
      )),
      );
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: _profileImage != null
                  ? ClipOval(
                      child: Image.file(
                        File(_profileImage!.path),
                        fit: BoxFit.cover,
                      )
                  ) : Icon(
                      Icons.person,
                      size: 60,
                      color: widget.primaryColor,
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                color: widget.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                onPressed: _showImageSourceSelector,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Profile Photo',
          style: TextStyle(
            color: widget.primaryColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}