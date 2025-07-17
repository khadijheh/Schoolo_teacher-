import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:schoolo_teacher/app_state.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/space_widget.dart';
import '../data/model/exam_model.dart';
import '../../../grade/presentation/pages/grade_student.dart';
import '../../../subject/data/models/class_model.dart';
import '../../../subject/data/models/section_model.dart';

class ExamsPage extends StatefulWidget {
  final SectionModel section;
  final ClassModel classItem;
  final String subject;
  final ValueChanged<List<Map<String, String>>>? onSaveScores;
  const ExamsPage({
    super.key,
    required this.section,
    required this.classItem,
    required this.subject,
    this.onSaveScores,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExamsPageState createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  List<ExamModel> _exams = [];
  bool _isLoading = true;
  final CardSwiperController _controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    _fetchExams();
  }

  Future<void> _fetchExams() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _exams = [
          ExamModel(
            id: '1',
            title: 'midterm_exam'.tr(),
            description: 'exam_description'.tr(),
            date: DateTime.now().subtract(Duration(days: 30)),
            maxScore: 100,
            examType: 'exam_types.midterm'.tr(),
            isCompleted: true,
            studentScores: [],
          ),
          ExamModel(
            id: '2',
            title: 'final_exam'.tr(),
            description: 'full_exam_description'.tr(),
            date: DateTime.now().add(Duration(days: 30)),
            maxScore: 100,
            examType: 'exam_types.final'.tr(),
            isCompleted: false,
            studentScores: [],
          ),
          ExamModel(
            id: '3',
            title: 'quiz'.tr(),
            description: 'unit_review'.tr(),
            date: DateTime.now(),
            maxScore: 50,
            examType: 'exam_types.quiz'.tr(),
            isCompleted: false,
            studentScores: [],
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load exams: ${e.toString()}')),
      );
    }
  }

  void _navigateToExamDetails(ExamModel exam) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Consumer<AppState>(
          builder: (context, appState, child) {
            return ExamDetailsPage(
              exam: exam,
              classItem: widget.classItem,
              section: widget.section,
              subject: widget.subject,
              onSaveScores: (scores) {
                setState(() {
                  exam.studentScores = scores;
                  exam.isCompleted = true;
                });
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'exams_page_title'.tr(
          namedArgs: {'section': widget.section.name},
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.centerLeft,
            colors: [
              // ignore: deprecated_member_use
              primaryColor.withOpacity(0.1),
              // ignore: deprecated_member_use
              primaryColor.withOpacity(0.2), primaryColor.withOpacity(0.3),
              // ignore: deprecated_member_use
              primaryColor.withOpacity(0.4), primaryColor.withOpacity(0.5),
              // ignore: deprecated_member_use
              
              // ignore: deprecated_member_use
              secondaryColor.withOpacity(0.4), secondaryColor.withOpacity(0.5),
            ],
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _exams.isEmpty
            ? Center(
                child: Text(
                  'no_exams_found'.tr(),
                  style: TextStyle(
                    fontSize: SizeConfig.defualtSize! * 2.5,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
              ).animate().scale()
            : Column(
                children: [
                  VerticalSpace(13),
                  Expanded(
                    child: CardSwiper(
                      controller: _controller,
                      cardsCount: _exams.length,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      numberOfCardsDisplayed: 3,
                      backCardOffset: Offset(40, 40),
                      cardBuilder:
                          (
                            context,
                            index,
                            horizontalThresholdPercentage,
                            verticalThresholdPercentage,
                          ) => _buildExamCard(_exams[index]),
                    ),
                  ),
                  VerticalSpace(5),
                  _buildActionButtons(),
                  VerticalSpace(5),
                ],
              ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction == CardSwiperDirection.right) {
      _navigateToExamDetails(_exams[previousIndex]);
    }
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    return true;
  }

  Widget _buildExamCard(ExamModel exam) {
    return GestureDetector(
      onTap: () => _navigateToExamDetails(exam),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: SizeConfig.defualtSize! * 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: _getExamGradient(exam.examType),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getExamIcon(exam.examType),
                      size: SizeConfig.defualtSize! * 7,
                      color: Colors.white,
                    ),
                    VerticalSpace(1),
                    Text(
                      exam.examType,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.defualtSize! * 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.2),
              height: SizeConfig.screenHeight! * 0.47,
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.defualtSize! * 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: TextStyle(
                        fontSize: SizeConfig.defualtSize! * 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    VerticalSpace(1.5),
                    Text(
                      exam.description,
                      style: TextStyle(
                        fontSize: SizeConfig.defualtSize! * 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    VerticalSpace(2),
                    Divider(),
                    VerticalSpace(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailItem(
                          icon: Icons.calendar_today,
                          text: _formatDate(exam.date),
                        ),
                        _buildDetailItem(
                          icon: Icons.score,
                          text: 'max_score'.tr(
                            namedArgs: {'score': exam.maxScore.toString()},
                          ),
                        ),
                      ],
                    ),
                    VerticalSpace(3),
                    if (exam.isCompleted)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defualtSize! * 0.5,
                          vertical: SizeConfig.defualtSize! * 0.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: SizeConfig.defualtSize! * 3,
                            ),
                            HorizontalSpace(1),
                            Text(
                              'marks_entered'.tr(),
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: SizeConfig.defualtSize! * 2.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: SizeConfig.defualtSize! * 3, color: primaryColor),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: SizeConfig.defualtSize! * 2,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
  }

  List<Color> _getExamGradient(String examType) {
    if (examType == 'exam_types.midterm'.tr()) {
      return [
        primaryColor,
        Colors.blueAccent.shade400,
        // ignore: deprecated_member_use
        secondaryColor.withOpacity(0.6),
      ];
    } else if (examType == 'exam_types.final'.tr()) {
      return [
        Colors.red.shade600,
        // ignore: deprecated_member_use
        primaryColor.withOpacity(0.7),
        // ignore: deprecated_member_use
        Colors.deepPurpleAccent.withOpacity(0.6),
      ];
    } else if (examType == 'exam_types.quiz'.tr()) {
      return [
        Colors.orange.shade700,
        // ignore: deprecated_member_use
        primaryColor.withOpacity(0.7),
        // ignore: deprecated_member_use
        secondaryColor.withOpacity(0.5),
      ];
    } else {
      return [
        primaryColor,
        Colors.blueAccent,
        // ignore: deprecated_member_use
        secondaryColor.withOpacity(0.6),
      ];
    }
  }

  IconData _getExamIcon(String examType) {
    if (examType == 'exam_types.midterm'.tr()) {
      return Icons.assignment_turned_in;
    } else if (examType == 'exam_types.final'.tr()) {
      return Icons.assignment;
    } else if (examType == 'exam_types.quiz'.tr()) {
      return Icons.quiz;
    } else {
      return Icons.school;
    }
  }

  String _formatDate(DateTime date) {
    return 'date_format'.tr(
      namedArgs: {
        'day': date.day.toString(),
        'month': date.month.toString(),
        'year': date.year.toString(),
      },
    );
  }
}
