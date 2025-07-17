
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolo_teacher/app_state.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/subject_body.dart';

class SubjectView extends StatefulWidget {
  const SubjectView({super.key});

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return const SubjectBody();
      },
    );
  }
}
