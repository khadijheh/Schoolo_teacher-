import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/custom_app_bar.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/contentManagemeny/data/models/content_model.dart';
import 'package:schoolo_teacher/features/contentManagemeny/presentation/pages/add_content_form.dart';
import 'package:schoolo_teacher/features/contentManagemeny/presentation/pages/content_detail_model.dart';
import 'package:schoolo_teacher/features/subject/data/models/section_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContentManagementPage extends StatefulWidget {
  final SectionModel section;

  const ContentManagementPage({super.key, required this.section});

  @override
  // ignore: library_private_types_in_public_api
  _ContentManagementPageState createState() => _ContentManagementPageState();
}

class _ContentManagementPageState extends State<ContentManagementPage> {
  List<ContentModel> _contents = [];
  List<ContentModel> _filteredContents = [];
  bool _isLoading = false;
  String _selectedType = 'All';
  final List<String> _contentTypes = [
    'All',
    'Image',
    'Video',
    'PDF',
    'Text',
    'Other',
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContents();
    _searchController.addListener(_filterContents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContents() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _contents = widget.section.content.cast<ContentModel>();
      _filteredContents = _contents;
      _isLoading = false;
    });
  }

  void _filterContents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContents = _contents.where((content) {
        final matchesSearch =
            content.title.toLowerCase().contains(query) ||
            content.description.toLowerCase().contains(query);
        final matchesType =
            _selectedType == 'All' ||
            content.type.name.toLowerCase() == _selectedType.toLowerCase();
        return matchesSearch && matchesType;
      }).toList();
    });
  }

  void _onTypeSelected(String? type) {
    if (type == null) return;
    setState(() {
      _selectedType = type;
      _filterContents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${'content.title'.tr()} - ${widget.section.name}'),
      body: Column(
        children: [
          _buildSearchAndFilterBar(),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _filteredContents.isEmpty
                    ? _buildEmptyState()
                    : _buildContentList(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "content.add_tooltip".tr(),
        backgroundColor: primaryColor,
        onPressed: _showAddContentDialog,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: SizeConfig.defualtSize! * 4,
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.defualtSize! * 2),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'content.search_hint'.tr(),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: SizeConfig.screenWidth! / 22,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: SizeConfig.screenWidth! / 20,
              ),
            ),
          ),
          const VerticalSpace(1),
          SizedBox(
            height: SizeConfig.screenHeight! / 18,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _contentTypes.length,
              separatorBuilder: (_, __) => const HorizontalSpace(1),
              itemBuilder: (context, index) {
                final type = _contentTypes[index];
                return ChoiceChip(
                  label: Text('content.types.${_contentTypes[index]}'.tr()),
                  selected: _selectedType == type,
                  selectedColor: primaryColor,
                  labelStyle: TextStyle(
                    fontSize: SizeConfig.screenWidth! / 25,
                    color: _selectedType == type ? Colors.white : primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (selected) =>
                      _onTypeSelected(selected ? type : 'All'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ).animate().scale(delay: (index * 100).ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.screenWidth! / 8,
            height: SizeConfig.screenHeight! / 15,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          const VerticalSpace(2),
          Text(
            'content.loading'.tr(),
            style: TextStyle(
              color: primaryColor,
              fontSize: SizeConfig.screenWidth! / 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: SizeConfig.defualtSize! * 15,
            // ignore: deprecated_member_use
            color: primaryColor.withOpacity(0.5),
          ),
          const VerticalSpace(1),
          Text(
            'content.empty_title'.tr(),
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 20,
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          const VerticalSpace(1),
          Text(
            'content.empty_subtitle'.tr(),
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: SizeConfig.screenWidth! / 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80, top: 8),
      itemCount: _filteredContents.length,
      itemBuilder: (context, index) =>
          _buildContentItem(_filteredContents[index]),
    );
  }

  Widget _buildContentItem(ContentModel content) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth! / 20,
        vertical: SizeConfig.screenHeight! / 80,
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showContentDetails(content),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.defualtSize! * 1.5),
          child: Row(
            children: [
              Container(
                width: SizeConfig.defualtSize! * 7,
                height: SizeConfig.defualtSize! * 7,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: content.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    content.icon,
                    size: SizeConfig.defualtSize! * 3.5,
                    color: content.color,
                  ),
                ),
              ),
              const HorizontalSpace(2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpace(0.5),
                    Text(
                      content.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenWidth! / 22,
                        color: primaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const VerticalSpace(1),
                    Chip(
                      label: Text(
                        content.type.name.tr(),
                        style: TextStyle(
                          color: content.color,
                          fontSize: SizeConfig.screenWidth! / 28,
                        ),
                      ),
                      // ignore: deprecated_member_use
                      backgroundColor: content.color.withOpacity(0.1),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: primaryColor,
                      size: SizeConfig.defualtSize! * 2.6,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _editContent(content);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: SizeConfig.defualtSize! * 2.6,
                    ),
                    onPressed: () => _deleteContent(content),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 * _filteredContents.indexOf(content)).ms);
  }

  void _showContentDetails(ContentModel content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),),
        child: ContentDetailsModal(content: content),
      ),
    );
  }

  Future<void> _showAddContentDialog() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'mp4', 'txt'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      showModalBottomSheet(
        // ignore: use_build_context_synchronously
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: AddContentForm(
            initialFiles: files,
            onContentAdded: (content) {
              setState(() {
                _contents.add(content);
                _filterContents();
              });
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  void _editContent(ContentModel content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),),
        child: AddContentForm(
          initialContent: content,
          initialFiles: content.fileUrls.map((url) => File(url)).toList(),
          onContentAdded: (updatedContent) {
            setState(() {
              int index = _contents.indexOf(content);
              _contents[index] = updatedContent;
              _filterContents();
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _deleteContent(ContentModel content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'content.delete_title'.tr(),
          style: TextStyle(
            color: primaryColor,
            fontSize: SizeConfig.screenWidth! / 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'content.delete_message'.tr(),
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: SizeConfig.screenWidth! / 25,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'common.cancel'.tr(),
              style: TextStyle(
                color: primaryColor,
                fontSize: SizeConfig.screenWidth! / 22,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _contents.remove(content);
                _filterContents();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('content.delete_success'.tr()),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'common.delete'.tr(),
              style: TextStyle(
                color: Colors.red,
                fontSize: SizeConfig.screenWidth! / 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}