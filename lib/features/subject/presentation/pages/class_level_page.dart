import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolo_teacher/app_state.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/class_level_body.dart';

class ClassLevelPage extends StatelessWidget {
  final String subject;
  const ClassLevelPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$subject - الصفوف'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) => ClassLevelBody(subject: subject),
      ),
    );
  }
}