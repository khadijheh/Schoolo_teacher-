import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/contentManagemeny/data/models/content_model.dart';
import 'package:video_player/video_player.dart';

class AddContentForm extends StatefulWidget {
  final Function(ContentModel) onContentAdded;
  final List<File> initialFiles;
  final ContentModel? initialContent;

  const AddContentForm({
    super.key,
    required this.onContentAdded,
    required this.initialFiles,
    this.initialContent,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddContentFormState createState() => _AddContentFormState();
}

class _AddContentFormState extends State<AddContentForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  List<File> _selectedFiles = [];
  bool _isUploading = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialContent != null) {
      _titleController.text = widget.initialContent!.title;
      _descController.text = widget.initialContent!.description;
    }
    _selectedFiles = widget.initialFiles;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.defualtSize! * 3),
        decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              VerticalSpace(1),
              _buildFormFields(),
              VerticalSpace(1),
              _buildMediaSelectionButtons(),
              VerticalSpace(1),
              if (_selectedFiles.isNotEmpty) _buildSelectedFiles(),
              VerticalSpace(1),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          widget.initialContent == null 
              ? 'content.add_new'.tr() 
              : 'content.edit'.tr(),
          style: TextStyle(
            color: primaryColor,
            fontSize: SizeConfig.screenWidth! / 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        HorizontalSpace(3),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'content.title'.tr(),
            // ignore: deprecated_member_use
            labelStyle: TextStyle(color: primaryColor.withOpacity(0.5)),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defualtSize! * 2,
              vertical: SizeConfig.defualtSize! * 2,
            ),
          ),
          validator: (value) =>
              value!.isEmpty ? 'content.validation.required'.tr() : null,
        ),
        VerticalSpace(1),
      ],
    );
  }

  Widget _buildMediaSelectionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'content.add_media'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth! / 22,
          ),
        ),
        VerticalSpace(1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMediaButton(
              icon: Icons.photo_library,
              label: 'content.gallery'.tr(),
              onPressed: _pickFromGallery,
            ),
            _buildMediaButton(
              icon: Icons.video_library,
              label: 'content.videos'.tr(),
              onPressed: _pickVideos,
            ),
            _buildMediaButton(
              icon: Icons.insert_drive_file,
              label: 'content.files'.tr(),
              onPressed: _pickFiles,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            size: SizeConfig.defualtSize! * 5,
            color: primaryColor,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig.screenWidth! / 25,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedFiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpace(1),
        Text(
          'content.selected_items'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth! / 22,
          ),
        ),
        VerticalSpace(1),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedFiles.map((file) {
            return _buildFileItem(file);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFileItem(File file) {
    final fileName = file.path.split('/').last;
    final isImage = fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg') ||
        fileName.toLowerCase().endsWith('.png');
    final isVideo = fileName.toLowerCase().endsWith('.mp4') ||
        fileName.toLowerCase().endsWith('.mov');

    return InkWell(
      onTap: () => _previewMedia(file),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.defualtSize! * 1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isImage)
              Container(
                width: SizeConfig.defualtSize! * 5,
                height: SizeConfig.defualtSize! * 5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else if (isVideo)
              Icon(Icons.videocam, size: SizeConfig.defualtSize! * 5)
            else
              Icon(_getFileIcon(fileName)),
            HorizontalSpace(3),
            SizedBox(
              width: SizeConfig.defualtSize! * 15,
              child: Text(fileName, overflow: TextOverflow.ellipsis),
            ),
            HorizontalSpace(2),
            IconButton(
              icon: Icon(
                Icons.close,
                size: SizeConfig.defualtSize! * 2.5,
                color: primaryColor,
              ),
              onPressed: () => _removeFile(file),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (ext == 'pdf') return Icons.picture_as_pdf;
    if (ext == 'doc' || ext == 'docx') return Icons.description;
    if (ext == 'xls' || ext == 'xlsx') return Icons.table_chart;
    if (ext == 'ppt' || ext == 'pptx') return Icons.slideshow;
    if (ext == 'txt') return Icons.text_fields;
    return Icons.insert_drive_file;
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: SizeConfig.screenWidth! / 2.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: SizeConfig.defualtSize! * 1.5),
        ),
        onPressed: _isUploading ? null : _submitForm,
        child: _isUploading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'content.save'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.screenWidth! / 25,
                ),
              ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedFiles.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      _showError('error.image_select'.tr(args: [e.toString()]));
    }
  }

  Future<void> _pickVideos() async {
    try {
      final pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedFiles.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      _showError('error.video_select'.tr(args: [e.toString()]));
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'mp4', 'mov', 'txt'],
      );

      if (result != null) {
        final files = result.paths.map((path) => File(path!)).toList();
        final oversized = files.any((file) => file.lengthSync() > 10 * 1024 * 1024);
        
        if (oversized) {
          _showError('error.file_size'.tr());
          return;
        }
        
        setState(() => _selectedFiles.addAll(files));
      }
    } catch (e) {
      _showError('error.file_select'.tr(args: [e.toString()]));
    }
  }

  void _removeFile(File file) {
    setState(() {
      _selectedFiles.remove(file);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final content = ContentModel(
        id: widget.initialContent?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descController.text,
        type: determineContentType(),
        fileUrls: _selectedFiles.map((file) => file.path).toList(),
        uploadDate: DateTime.now(), 
        fileNames: [], 
        fileSizes: [], 
        authorId: '',
      );

      widget.onContentAdded(content);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('content.success'.tr())),
      );
    } catch (e) {
      _showError('error.general'.tr(args: [e.toString()]));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _previewMedia(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    
    if (['jpg', 'jpeg', 'png'].contains(ext)) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Image.file(file)),
        ),
      ));
    } else if (['mp4', 'mov'].contains(ext)) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: VideoPlayer(File(file.path) as VideoPlayerController))
            ,
      )));
    }
  }
 
  ContentType determineContentType() {
    if (_selectedFiles.isEmpty) return ContentType.other;

    final types = _selectedFiles.map((file) {
      final path = file.path.toLowerCase();
      if (path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png')) {
        return ContentType.image;
      } else if (path.endsWith('.mp4') || path.endsWith('.mov')) {
        return ContentType.video;
      } else if (path.endsWith('.pdf')) {
        return ContentType.pdf;
      } else if (path.endsWith('.txt')) {
        return ContentType.text;
      }
      return ContentType.other;
    }).toSet();

    if (types.length == 1) return types.first;
    return ContentType.other;
  }
}