import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:schoolo_teacher/app_state.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/custom_app_bar.dart';
import 'package:schoolo_teacher/features/contentManagemeny/presentation/pages/content_mangement_page.dart';
import 'package:schoolo_teacher/features/exam/presentation/pages/exam_page.dart';
import 'package:schoolo_teacher/features/subject/data/models/class_model.dart';
import 'package:schoolo_teacher/features/subject/data/models/section_model.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/empty_section_state.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/loading_indicator.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/section_card.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/section_details_sheet.dart';

class SectionBody extends StatefulWidget {
  final ClassModel classItem;
  final String subject;

  const SectionBody({
    super.key,
    required this.classItem,
    required this.subject,
  });

  @override
  State<SectionBody> createState() => _SectionBodyState();
}

class _SectionBodyState extends State<SectionBody> {
  List<SectionModel> _sections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSections();
  }

  Future<void> _fetchSections() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _sections = widget.classItem.sections.cast<SectionModel>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('sections.load_error'.tr(args: [e.toString()]))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.subject} - ${widget.classItem.name}',
      ),
      body: _isLoading ? const SectionLoadingIndicator() : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        ..._buildBackgroundElements(),
        _sections.isEmpty ? const EmptySectionState() : _buildSectionsList(),
      ],
    );
  }

  List<Widget> _buildBackgroundElements() {
    return [
      Positioned(
        top: -SizeConfig.screenHeight! / 15,
        right: -SizeConfig.screenWidth! / 9,
        child: Container(
          width: SizeConfig.screenWidth! / 3,
          height: SizeConfig.screenHeight! / 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // ignore: deprecated_member_use
            color: primaryColor.withOpacity(0.7),
          ),
        ),
      ),
      Positioned(
        top: -SizeConfig.screenHeight! / 15,
        right: -SizeConfig.screenWidth! / 15,
        child: Container(
          width: SizeConfig.screenWidth! / 1.5,
          height: SizeConfig.screenHeight! / 2.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // ignore: deprecated_member_use
            color: primaryColor.withOpacity(0.3),
          ),
        ),
      ),
      Positioned(
        top: SizeConfig.screenHeight! / 15,
        left: -SizeConfig.screenWidth! / 9,
        child: Container(
          width: SizeConfig.screenWidth! * 0.85,
          height: SizeConfig.screenHeight! * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // ignore: deprecated_member_use
            color: secondaryColor.withOpacity(0.3),
          ),
        ),
      ),
      Positioned(
        top: SizeConfig.screenHeight! / 3,
        left: SizeConfig.screenWidth! / 5,
        child: Container(
          width: SizeConfig.screenWidth! * 0.85,
          height: SizeConfig.screenHeight! * 0.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // ignore: deprecated_member_use
            color: primaryColor.withOpacity(0.2),
          ),
        ),
      ),
    ];
  }

  Widget _buildSectionsList() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight! / 40),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.screenHeight! / 80,
          horizontal: SizeConfig.screenWidth! / 20,
        ),
        itemCount: _sections.length,
        itemBuilder: (context, index) => SectionCard(
          section: _sections[index],
          onTap: () => _showSectionDetails(_sections[index]),
          onContentTap: () => _manageContent(_sections[index]),
          onExamTap: () => _navigateToExam(_sections[index]),
        ).animate().scale(),
      ),
    );
  }

  void _manageContent(SectionModel section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentManagementPage(section: section),
      ),
    );
  }

  void _navigateToExam(SectionModel section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Consumer<AppState>(
          builder: (context, appState, child) {
            return ExamsPage(
              subject: widget.subject,
              section: section,
              classItem: widget.classItem,
            );
          },
        ),
      ),
    );
  }

  void _showSectionDetails(SectionModel section) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SectionDetailsSheet(
        section: section,
        onManageStudents: () => _manageStudents(section),
      ),
    );
  }

  void _manageStudents(SectionModel section) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
          appBar: CustomAppBar(
            title: '${'students.title'.tr()} ${section.name}',
          ),
          body: Container(
            padding: EdgeInsets.all(SizeConfig.screenWidth! / 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Replace with actual student count
                    itemBuilder: (context, index) => _buildStudentListItem(),
                  ),
                ),
              ],
            ),
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildStudentListItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: SizeConfig.screenWidth! / 8,
          height: SizeConfig.screenHeight! / 15,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor,
                // ignore: deprecated_member_use
                primaryColor.withOpacity(0.5),
                secondaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'students.name'.tr().substring(0, 2),
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.screenWidth! / 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          'students.name'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth! / 22,
          ),
        ),
        subtitle: Text(
          "students.phone".tr(),
          style: TextStyle(
            fontSize: SizeConfig.screenWidth! / 28,
            color: primaryColor
          ),
        ),
      ),
    );
  }
}