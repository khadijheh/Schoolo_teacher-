import 'package:flutter/material.dart';
import 'package:schoolo_teacher/features/profile/presentation/widget/profile_body.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return  ProfileBody();
  }
}
