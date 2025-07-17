import 'package:flutter/material.dart';
import 'package:schoolo_teacher/features/subject/data/models/class_model.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/section_body.dart';

class SectionPage extends StatelessWidget {
  final ClassModel classItem;
  final String subject;
  
  const SectionPage({
    super.key,
    required this.classItem,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SectionBody(
        classItem: classItem,
        subject: subject,
      ),
    );
  }
}