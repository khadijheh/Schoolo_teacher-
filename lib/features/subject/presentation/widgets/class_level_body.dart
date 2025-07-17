import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/custom_app_bar.dart';
import 'package:schoolo_teacher/features/subject/data/models/class_model.dart';
import 'package:schoolo_teacher/features/subject/data/models/section_model.dart';
import 'package:schoolo_teacher/features/subject/presentation/pages/section_page.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/class_card.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/class_level_shimmer.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/empty_class_state..dart';

class ClassLevelBody extends StatefulWidget {
  final String subject;

  const ClassLevelBody({super.key, required this.subject});

  @override
  State<ClassLevelBody> createState() => _ClassLevelBodyState();
}

class _ClassLevelBodyState extends State<ClassLevelBody> {
  late List<ClassModel> classes;
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadClasses();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _initializeData() {
    classes = [
      ClassModel(
        id: "1",
        name: "class_levels.grade_3".tr(),
        description: "class_levels.semester_1_2023_2024".tr(),
        studentCount: 32,
        sections: List.generate(6, (index) => _createDummySection()),
      ),
      ClassModel(
        id: "2",
        name: "class_levels.grade_4".tr(),
        description: "class_levels.semester_1_2023_2024".tr(),
        studentCount: 28,
        sections: [],
      ),
      ClassModel(
        id: "3",
        name: "class_levels.grade_2".tr(),
        description: "class_levels.semester_2_2023_2024".tr(),
        studentCount: 35,
        sections: [],
      ),
      ClassModel(
        id: "4",
        name: "class_levels.grade_3".tr(),
        description: "class_levels.semester_1_2023_2024".tr(),
        studentCount: 28,
        sections: [],
      ),
      ClassModel(
        id: "5",
        name: "class_levels.grade_4".tr(),
        description: "class_levels.semester_1_2023_2024".tr(),
        studentCount: 28,
        sections: List.generate(2, (index) => _createDummySection()),
      ),
    ];
  }

  SectionModel _createDummySection() {
    return SectionModel(
      id: "1",
      name: "class_levels.section_a".tr(),
      streamType: "class_levels.general".tr(),
      isActive: true,
      capacity: 30,
      content: [],
    );
  }

  Future<void> _loadClasses() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.subject} - ${'class_levels.classes'.tr()}',
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) return const ClassLevelShimmer();
    if (classes.isEmpty) return const EmptyClassState();
    return _buildClassesGrid();
  }

  Widget _buildClassesGrid() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.08),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: SizeConfig.screenHeight! / 5,
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: classes.length,
      itemBuilder: (context, index) => ClassCard(
        classItem: classes[index],
        index: index,
        onTap: () => _navigateToSections(classes[index]),
      ),
    );
  }

  void _navigateToSections(ClassModel classItem) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionPage(
          classItem: classItem,
          subject: widget.subject,
        ),
      ),
    );
  }
}