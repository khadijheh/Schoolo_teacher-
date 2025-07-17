import 'package:flutter/material.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/students_body.dart';

class StudentsPageView extends StatefulWidget {
  const StudentsPageView({super.key});

  @override
  State<StudentsPageView> createState() => _StudentsPageViewState();
}

class _StudentsPageViewState extends State<StudentsPageView> {
  @override
  Widget build(BuildContext context) {
    return const StudentsBody();
  }
}