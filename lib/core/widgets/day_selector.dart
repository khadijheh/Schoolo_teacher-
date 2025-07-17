import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';

class DaySelector extends StatefulWidget {
  final List<String> availableDays;
  final List<String> initialSelectedDays;
  final ValueChanged<List<String>> onDaysChanged;
  final Color primaryColor;
  final String title;
  final String selectedLabel;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double spacing;
  final double runSpacing;
  final TextStyle? titleStyle;
  final TextStyle? selectedTextStyle;
  final TextStyle? selectedLabelStyle;

  const DaySelector({
    super.key,
    required this.availableDays,
    this.initialSelectedDays = const [],
    required this.onDaysChanged,
    required this.primaryColor,
    this.title = 'Select your working days:',
    this.selectedLabel = 'Selected days:',
    this.padding,
    this.borderRadius = 12,
    this.spacing = 6,
    this.runSpacing = 6,
    this.titleStyle,
    this.selectedTextStyle,
    this.selectedLabelStyle,
  });

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.initialSelectedDays);
  }

  void _toggleDaySelection(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      widget.onDaysChanged(_selectedDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(
              widget.title,
              style:
                  widget.titleStyle ??
                  TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),

          // Day Selection Grid
          Wrap(
            spacing: widget.spacing,
            runSpacing: widget.runSpacing,
            children: widget.availableDays.map((day) {
              final isSelected = _selectedDays.contains(day);
              return GestureDetector(
                onTap: () => _toggleDaySelection(day),
                child: Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenHeight!/260,
                    vertical:  SizeConfig.screenWidth!/200,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? widget.primaryColor
                          : Colors.grey.shade400,
                    ),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Selected Days Summary
          if (_selectedDays.isNotEmpty) ...[
            VerticalSpace(0.5),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  widget.selectedLabel,
                  style:
                      widget.selectedLabelStyle ??
                      const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  _selectedDays.join(', '),
                  style:
                      widget.selectedTextStyle ??
                      TextStyle(
                        color: widget.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
