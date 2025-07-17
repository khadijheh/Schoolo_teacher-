import 'package:flutter/material.dart';
class ScheduleItem {
  final String time;
  final String subject;
  final String classroom;
  final IconData icon;
  final Color color;

  ScheduleItem({
    required this.time,
    required this.subject,
    required this.classroom,
    required this.icon,
    required this.color,
  });
}