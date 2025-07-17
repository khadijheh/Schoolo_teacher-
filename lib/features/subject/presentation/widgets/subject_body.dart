import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:schoolo_teacher/app_state.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/themes.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/class_level_body.dart';

class SubjectBody extends StatefulWidget {
  const SubjectBody({super.key});

  @override
  State<SubjectBody> createState() => _SubjectBodyState();
}

class _SubjectBodyState extends State<SubjectBody> {
  // Color palette adjustments
  final List<List<Color>> _gradientPalettes = [
    [primaryColor, const Color(0xFF7B9AFF)],
    [secondaryColor, const Color(0xFFFFD85C)],
    [const Color(0xFF5A7BEF), const Color(0xFF9D6BFF)],
    [const Color(0xFFFFE53B), const Color(0xFFFF7E5F)],
    [const Color(0xFF658AE2), const Color(0xFF5AC8FA)],
    // ignore: deprecated_member_use
    [secondaryColor.withOpacity(0.8), const Color(0xFF7CEC9F)],
  ];

  final List<Color> _iconBackgroundColors = [
    // ignore: deprecated_member_use
    primaryColor.withOpacity(0.2),
    // ignore: deprecated_member_use
    secondaryColor.withOpacity(0.2),
    // ignore: deprecated_member_use
    const Color(0xFF9D6BFF).withOpacity(0.2),
    // ignore: deprecated_member_use
    const Color(0xFFFF7E5F).withOpacity(0.2),
    // ignore: deprecated_member_use
    const Color(0xFF5AC8FA).withOpacity(0.2),
    // ignore: deprecated_member_use
    const Color(0xFF7CEC9F).withOpacity(0.2),
  ];

  // Helper function to normalize subject keys
  String _normalizeSubjectKey(String subject) {
    final keyMap = {
      'Mathematics': 'math',
      'Physics': 'physics',
      'Chemistry': 'chemistry',
      'Biology': 'biology',
      'Literature': 'literature',
      'Arabic': 'arabic',
      'Arabic Language': 'arabic',
      'English': 'english',
      'English Language': 'english',
      'History': 'history',
      'Geography': 'geography',
      'Islamic Education': 'islamic',
      'Arts': 'arts',
      'Physical Education': 'physical',
      'Computer Science': 'computer',
      'Psychology': 'psychology',
      'Science': 'science',
      'General Science': 'science',
    };

    // تنظيف النص من المسافات الزائدة وحوافه
    final cleanedSubject = subject.trim();

    return keyMap[cleanedSubject] ??
        cleanedSubject.toLowerCase().replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedSpecialties = appState.selectedSpecialties;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.screenHeight! / 35,
        horizontal: SizeConfig.screenWidth! / 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'subjects.my_subjects'.tr(),
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 13,
              fontWeight: FontWeight.bold,
              color: lightTheme.primaryColorDark,
            ),
          ),
          const VerticalSpace(2),
          if (selectedSpecialties.isEmpty)
            _buildEmptyState()
          else
            _buildSubjectsGrid(selectedSpecialties),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.4),
            ),
            padding: EdgeInsets.all(SizeConfig.screenWidth! / 10),
            child: Icon(
              Icons.school,
              size: SizeConfig.screenWidth! / 5,
              color: primaryColor,
            ),
          ),
          const VerticalSpace(3),
          Text(
            'subjects.no_subjects'.tr(),
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 20,
              color: blockColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VerticalSpace(1),
          Text(
            'subjects.complete_profile_message'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 25,
              // ignore: deprecated_member_use
              color: blockColor.withOpacity(0.6),
            ),
          ),
          const VerticalSpace(3),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'completeProfile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth! / 8,
                vertical: SizeConfig.screenHeight! / 60,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'subjects.complete_profile_button'.tr(),
              style: TextStyle(
                fontSize: SizeConfig.screenWidth! / 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsGrid(List<String> subjects) {
    return Expanded(
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: SizeConfig.orientation == Orientation.portrait
              ? 2
              : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subjectKey = _normalizeSubjectKey(subjects[index]);
          return _buildSubjectCard(subjectKey, index);
        },
      ),
    );
  }

  Widget _buildSubjectCard(String subjectKey, int index) {
    final colorPair = _gradientPalettes[index % _gradientPalettes.length];
    final iconBgColor =
        _iconBackgroundColors[index % _iconBackgroundColors.length];
    final subjectName = 'subjects.names.$subjectKey'.tr();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClassLevelBody(subject: subjectName),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: colorPair,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: blockColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.defualtSize! / 0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: iconBgColor,
                      ),
                      child: _getSubjectImage(subjectKey),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subjectName,
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth! / 22,
                          fontWeight: FontWeight.w700,
                          color: lightTheme.shadowColor,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      VerticalSpace(0.5),
                      Text(
                        _getSubjectDescription(subjectKey),
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth! / 40,
                          // ignore: deprecated_member_use
                          color: blockColor.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.class_outlined,
                        size: SizeConfig.screenWidth! / 28,
                        // ignore: deprecated_member_use
                        color: blockColor.withOpacity(0.9),
                      ),
                      HorizontalSpace(0.5),
                      Text(
                        '${_getClassCount(subjectKey)} ${'subjects.classes'.tr()}',
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth! / 30,
                          fontWeight: FontWeight.w600,
                          // ignore: deprecated_member_use
                          color: blockColor.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().shimmer(delay: Duration(milliseconds: 300)),
    );
  }

  Image _getSubjectImage(String subjectKey) {
    String imagePath;
    switch (subjectKey) {
      case 'math':
        imagePath = 'images/math.png';
        break;
      case 'physics':
        imagePath = 'images/physics.png';
        break;
      case 'chemistry':
        imagePath = 'images/chemistry.png';
        break;
      case 'biology':
        imagePath = 'images/biology.png';
        break;
      case 'literature':
      case 'arabic':
      case 'english':
        imagePath = 'images/language.png';
        break;
      case 'history':
        imagePath = 'images/history.png';
        break;
      case 'geography':
        imagePath = 'images/geography.png';
        break;
      case 'islamic':
        imagePath = 'images/islamic.png';
        break;
      case 'arts':
        imagePath = 'images/arts.png';
        break;
      case 'physical':
        imagePath = 'images/physical.png';
        break;
      case 'computer':
        imagePath = 'images/computer.png';
        break;
      case 'psychology':
        imagePath = 'images/psychology.png';
        break;
      case 'science':
        imagePath = 'images/science.png';
        break;
      default:
        imagePath = 'images/logoo.png';
    }
    return Image.asset(
      imagePath,
      width: SizeConfig.screenWidth! / 10,
      fit: BoxFit.contain,
    );
  }

  String _getSubjectDescription(String subjectKey) {
    switch (subjectKey) {
      case 'math':
        return 'subjects.descriptions.math'.tr();
      case 'physics':
      case 'chemistry':
      case 'biology':
      case 'science':
        return 'subjects.descriptions.science'.tr();
      case 'literature':
      case 'arabic':
      case 'english':
        return 'subjects.descriptions.language'.tr();
      case 'history':
        return 'subjects.descriptions.history'.tr();
      case 'geography':
        return 'subjects.descriptions.geography'.tr();
      case 'islamic':
        return 'subjects.descriptions.islamic'.tr();
      case 'arts':
        return 'subjects.descriptions.arts'.tr();
      case 'physical':
        return 'subjects.descriptions.physical'.tr();
      case 'computer':
        return 'subjects.descriptions.computer'.tr();
      case 'psychology':
        return 'subjects.descriptions.psychology'.tr();
      default:
        return 'subjects.descriptions.default'.tr();
    }
  }

  int _getClassCount(String subjectKey) {
    final rng = subjectKey.hashCode % 5;
    return 3 + rng;
  }
}
