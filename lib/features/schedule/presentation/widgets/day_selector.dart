import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';

class DaySelector extends StatelessWidget {
  final int currentDay;
  final Function(int) onDaySelected;

  const DaySelector({
    super.key,
    required this.currentDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight! / 60),
      child: SizedBox(
        height: SizeConfig.defualtSize! * 10,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) => _buildDayItem(index,context),
        ),
      ),
    );
  }
List<String> getDayNames(BuildContext context) {
  try {
    final translated = context.tr('schedulee.short_days');
    if (translated is List) {
      return List<String>.from(translated as Iterable);
    }
    throw Exception('Translation is not a list');
  } catch (e) {
    // Fallback if translation fails
    return context.locale.languageCode == 'ar'
        ? ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  }
}

// الاستخدام:
  Widget _buildDayItem(int index,BuildContext context) {
    final isSelected = index == currentDay;
final dayNames = getDayNames(context);

    return GestureDetector(
      onTap: () => onDaySelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  // ignore: deprecated_member_use
                  colors: [primaryColor, primaryColor.withOpacity(0.5),Colors.blueAccent,],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          // ignore: deprecated_member_use
          color: isSelected ? null : primaryColor.withOpacity(0.001),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayNames[index],
              style: TextStyle(
                fontSize: SizeConfig.screenWidth! / 25,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : primaryColor,
              ),
            ),
            const VerticalSpace(1),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: SizeConfig.defualtSize! * 4,
              height: SizeConfig.defualtSize! * 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    // ignore: deprecated_member_use
                    ? Colors.white.withOpacity(0.15)
                    // ignore: deprecated_member_use
                    : primaryColor.withOpacity(0.15),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth! / 22,
                    color: isSelected ? Colors.white : const Color(0xFF636E72),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}