import 'package:schoolo_teacher/features/subject/data/models/student_model.dart';

class ExamModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int maxScore;
  final String examType;
  bool isCompleted;
  List<Map<String, String>> studentScores;

  ExamModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.maxScore,
    required this.examType,
    this.isCompleted = false,
    this.studentScores = const [],
  });
  bool get areScoresValid {
    for (var student in studentScores) {
      final score = student['score'];
      if (score == null || score.isEmpty) return false;
      final scoreValue = int.tryParse(score);
      if (scoreValue == null || scoreValue < 0 || scoreValue > maxScore) {
        return false;
      }
    }
    return true;
  }
}

class StudentGrade {
  final StudentModel student;
  int grade;
  String notes;

  StudentGrade({
    required this.student,
    required this.grade,
    required this.notes,
  });
}
