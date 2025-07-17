import 'package:schoolo_teacher/features/subject/data/models/section_model.dart';

class ClassModel {
  final String id;
  final String name;
  final String? localizedNameKey; // For API-based localization
  final String description;
  final String? localizedDescriptionKey;
  final int studentCount;
  final List<SectionModel> sections;

  ClassModel({
    required this.id,
    required this.name,
    this.localizedNameKey,
    required this.description,
    this.localizedDescriptionKey,
    required this.studentCount,
    required this.sections,
  });
}