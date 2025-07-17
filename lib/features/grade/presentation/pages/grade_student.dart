import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:schoolo_teacher/features/exam/presentation/data/model/exam_model.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../subject/data/models/class_model.dart';
import '../../../subject/data/models/section_model.dart';

class ExamDetailsPage extends StatefulWidget {
  final ExamModel exam;
  final ClassModel classItem;
  final SectionModel section;
  final String subject;
  final Function(List<Map<String, String>>) onSaveScores;

  const ExamDetailsPage({
    super.key,
    required this.exam,
    required this.classItem,
    required this.section,
    required this.subject,
    required this.onSaveScores,
  });

  @override
  State<ExamDetailsPage> createState() => _ExamDetailsPageState();
}

class _ExamDetailsPageState extends State<ExamDetailsPage> {
  late List<Map<String, String>> _students;
  late List<TextEditingController> _scoreControllers;
  late List<FocusNode> _focusNodes;
  bool _isSaving = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeStudents();
    _initializeControllers();
  }

  void _initializeStudents() {
    _students = widget.exam.studentScores.isNotEmpty
        ? List.from(widget.exam.studentScores)
        : _generateSampleStudents();
  }

  List<Map<String, String>> _generateSampleStudents() {
    return [
      {'id': '1001', 'name': 'student_1'.tr(), 'score': ''},
      {'id': '1002', 'name': 'student_2'.tr(), 'score': ''},
      {'id': '1003', 'name': 'student_3'.tr(), 'score': ''},
      {'id': '1004', 'name': 'student_4'.tr(), 'score': ''},
      {'id': '1005', 'name': 'student_5'.tr(), 'score': ''},
      {'id': '1006', 'name': 'student_6'.tr(), 'score': ''},
      {'id': '1007', 'name': 'student_7'.tr(), 'score': ''},
    ];
  }

  void _initializeControllers() {
    _scoreControllers = _students
        .map((student) => TextEditingController(text: student['score']))
        .toList();
    _focusNodes = List.generate(_students.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _scoreControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.defualtSize! * 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, Colors.blueAccent.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: SizeConfig.defualtSize! * 3.5,
                // ignore: deprecated_member_use
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  Icons.assignment_outlined,
                  size: SizeConfig.defualtSize! * 4,
                  color: blockColor,
                ),
              ),
              SizedBox(width: SizeConfig.defualtSize! * 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exam.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.defualtSize! * 2.2,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: SizeConfig.defualtSize! * 0.5),
                    Text(
                      widget.exam.description,
                      style: TextStyle(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.9),
                        fontSize: SizeConfig.defualtSize! * 1.6,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.defualtSize! * 2),
          SingleChildScrollView(scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildExamInfoChip(
                  icon: Icons.today,
                  label: _formatDate(widget.exam.date),
                ),
                _buildExamInfoChip(
                  icon: Icons.score_outlined,
                  label: 'exam_details.total_score'.tr(namedArgs: {'score': widget.exam.maxScore.toString()}),
                ),
                _buildExamInfoChip(
                  icon: Icons.assignment_turned_in_outlined,
                  label: _getTranslatedExamType(widget.exam.examType),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
String _getTranslatedExamType(String examType) {
  switch (examType.toLowerCase()) {
    case 'نصفي':
    case 'midterm':
      return 'exam_details.exam_type.midterm'.tr();
    case 'نهائي':
    case 'final':
      return 'exam_details.exam_type.final'.tr();
    case 'اختبار قصير':
    case 'quiz':
      return 'exam_details.exam_type.quiz'.tr();
    default:
      return examType; // العودة للقيمة الأصلية إذا لم يتم العثور على ترجمة
  }
}
  Widget _buildExamInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.defualtSize! * 1.5,
        vertical: SizeConfig.defualtSize! * 0.8,
      ),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: SizeConfig.defualtSize! * 1.8,
            color: secondaryColor,
          ),
          SizedBox(width: SizeConfig.defualtSize! * 0.5),
          Text(
            label,
            style: TextStyle(
              color: blockColor,
              fontSize: SizeConfig.defualtSize! * 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassInfoSection() {
    return Container(
      margin: EdgeInsets.all(SizeConfig.defualtSize! * 1.5),
      padding: EdgeInsets.all(SizeConfig.defualtSize! * 1.5),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildClassInfoItem(Icons.school, 'exam_details.class_label'.tr(), widget.classItem.name),
          _buildClassInfoItem(Icons.group, 'exam_details.section_label'.tr(), widget.section.name),
          _buildClassInfoItem(Icons.menu_book, 'exam_details.subject_label'.tr(), widget.subject),
        ],
      ),
    );
  }

  Widget _buildClassInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.defualtSize! * 0.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // ignore: deprecated_member_use
            color: primaryColor.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            size: SizeConfig.defualtSize! * 3,
            color: primaryColor,
          ),
        ),
        SizedBox(height: SizeConfig.defualtSize! * 0.8),
        Text(
          title,
          style: TextStyle(
            fontSize: SizeConfig.defualtSize! * 1.8,
            color: primaryColor,
          ),
        ),
        SizedBox(height: SizeConfig.defualtSize! * 0.5),
        Text(
          value,
          style: TextStyle(
            fontSize: SizeConfig.defualtSize! * 1.6,
            fontWeight: FontWeight.bold,
            color: blockColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsListHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.defualtSize! * 1.5,
        vertical: SizeConfig.defualtSize!,
      ),
      child: Row(
        children: [
          Text(
            'exam_details.students_list'.tr(),
            style: TextStyle(
              fontSize: SizeConfig.defualtSize! * 3,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defualtSize! * 1.8,
              vertical: SizeConfig.defualtSize! * 0.5,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'exam_details.students_count'.tr(namedArgs: {'count': _students.length.toString()}),
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.defualtSize! * 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListItem(Map<String, String> student, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.defualtSize! * 1.5,
        vertical: SizeConfig.defualtSize! * 0.5,
      ),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _getRandomColor(int.parse(student['id']!)),
          child: Text(
            student['name']!.substring(0, 1),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.defualtSize! * 3,
            ),
          ),
        ),
        title: Text(
          student['name']!,
          style: TextStyle(
            color: blockColor,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.defualtSize! * 1.8,
          ),
        ),
        subtitle: Text(
          'ID: ${student['id']}',
          style: TextStyle(
            color: primaryColor,
            fontSize: SizeConfig.defualtSize! * 1.4,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
          width: SizeConfig.defualtSize! * 6,
          height: SizeConfig.defualtSize! * 4,
          child: widget.exam.isCompleted
              ? _buildScoreDisplay(student['score']!)
              : _buildScoreInputField(index),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.defualtSize! * 1.5,
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(String score) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defualtSize! * 0.8),
      decoration: BoxDecoration(
        color: score.isEmpty
            // ignore: deprecated_member_use
            ? whiteColor.withOpacity(0.3)
            : _getScoreColor(double.tryParse(score) ?? 0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          score.isEmpty ? '--' : score,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: score.isEmpty ? blockColor : blockColor,
            fontSize: SizeConfig.defualtSize! * 1.8,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreInputField(int index) {
    return TextField(
      controller: _scoreControllers[index],
      focusNode: _focusNodes[index],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        hintText: '--',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.zero,
      ),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.defualtSize! * 1.8,
        color: Colors.grey.shade800,
      ),
      onSubmitted: (value) => _handleEnterPressed(index),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defualtSize! * 2),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _validateAndSaveAllScores,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.defualtSize! * 1.8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          // ignore: deprecated_member_use
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isSaving)
              SizedBox(
                width: SizeConfig.defualtSize! * 2,
                height: SizeConfig.defualtSize! * 2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(Icons.save_rounded, size: SizeConfig.defualtSize! * 3),
            SizedBox(width: SizeConfig.defualtSize!),
            Text(
              _isSaving ? 'exam_details.saving_grades'.tr() : 'exam_details.save_grades'.tr(),
              style: TextStyle(
                fontSize: SizeConfig.defualtSize! * 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    final maxScore = widget.exam.maxScore;
    final percentage = score / maxScore;

    if (percentage >= 0.8) return Colors.green.shade600;
    if (percentage >= 0.5) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.exam.title),
      body: Column(
        children: [
          _buildHeaderSection(),
          _buildClassInfoSection(),
          _buildStudentsListHeader(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: SizeConfig.defualtSize! * 2),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                return _buildStudentListItem(_students[index], index);
              },
            ),
          ),
          if (!widget.exam.isCompleted) _buildSaveButton(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return 'date_format'.tr(namedArgs: {
      'day': date.day.toString(),
      'month': date.month.toString(),
      'year': date.year.toString()
    });
  }

  Color _getRandomColor(int seed) {
    final random = Random(seed);
    return Color.fromRGBO(
      (130 + random.nextInt(156)),
      130 + random.nextInt(156),
      130 + random.nextInt(156),
      1,
    );
  }

  void _handleEnterPressed(int currentIndex) {
    final scoreText = _scoreControllers[currentIndex].text;
    if (scoreText.isNotEmpty) {
      final score = double.tryParse(scoreText);
      if (score == null || score < 0 || score > widget.exam.maxScore) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'exam_details.enter_valid_grade'.tr(namedArgs: {'maxScore': widget.exam.maxScore.toString()}),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: SizeConfig.defualtSize! * 2),
            ),
            backgroundColor: Colors.red,
          ),
        );
        _focusNodes[currentIndex].requestFocus();
        return;
      }
    }

    if (currentIndex < _students.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[currentIndex + 1]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          (currentIndex + 1) * 70.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } else {
      FocusScope.of(context).unfocus();
    }

    setState(() {
      _students[currentIndex]['score'] = scoreText;
    });
  }

  void _validateAndSaveAllScores() async {
    for (int i = 0; i < _students.length; i++) {
      final scoreText = _scoreControllers[i].text;
      if (scoreText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'exam_details.enter_grade_for'.tr(namedArgs: {'studentName': _students[i]['name']!}),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
        _focusNodes[i].requestFocus();
        return;
      }

      final score = double.tryParse(scoreText);
      if (score == null || score < 0 || score > widget.exam.maxScore) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'exam_details.invalid_grade_for'.tr(namedArgs: {
                'studentName': _students[i]['name']!,
                'maxScore': widget.exam.maxScore.toString()
              }),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
        _focusNodes[i].requestFocus();
        return;
      }
    }

    for (int i = 0; i < _students.length; i++) {
      _students[i]['score'] = _scoreControllers[i].text;
    }

    setState(() => _isSaving = true);

    try {
      await widget.onSaveScores(_students);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'exam_details.grades_saved'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: SizeConfig.defualtSize! * 2),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'error_saving_grades'.tr(args: [e.toString()]),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}