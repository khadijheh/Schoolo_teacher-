import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/schedule/presentation/pages/schedule_item.dart';

class ClassDetailsSheet extends StatelessWidget {
  final ScheduleItem item;

  const ClassDetailsSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.defualtSize! * 2),
              child: Column(
                children: [
                  Text(
                    _getTranslatedSubject(item.subject), // استخدام دالة مساعدة للترجمة
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! / 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  const VerticalSpace(1.5),
                  _buildDetailRow(Icons.access_time, _getTranslatedTime(item.time)),
                  const VerticalSpace(1),
                  _buildDetailRow(Icons.room, _getTranslatedClassroom(item.classroom)),
                  const VerticalSpace(1),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'close'.tr(),
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! / 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لترجمة المواد
  String _getTranslatedSubject(String subject) {
    switch (subject) {
      case 'Mathematics': return 'mathematics'.tr();
      case 'Physics': return 'physics'.tr();
      case 'Literature': return 'literature'.tr();
      default: return subject;
    }
  }

  // دالة مساعدة لترجمة الأوقات
  String _getTranslatedTime(String time) {
    switch (time) {
      case '8:00 - 9:30 AM': return 'time_8_9_30'.tr();
      case '10:00 - 11:30 AM': return 'time_10_11_30'.tr();
      case '9:00 - 10:30 AM': return 'time_9_10_30'.tr();
      default: return time;
    }
  }

  // دالة مساعدة لترجمة القاعات
  String _getTranslatedClassroom(String classroom) {
    switch (classroom) {
      case 'Room 101': return 'room_101'.tr();
      case 'Lab 2': return 'lab_2'.tr();
      case 'Room 202': return 'room_202'.tr();
      default: return classroom;
    }
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: SizeConfig.defualtSize! * 4),
        const HorizontalSpace(3),
        Text(
          text,
          style: TextStyle(
            fontSize: SizeConfig.screenWidth! / 20,
            color: const Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }
}