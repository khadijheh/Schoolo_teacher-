import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/features/schedule/presentation/pages/schedule_item.dart';
import 'package:schoolo_teacher/features/schedule/presentation/widgets/class_details_sheet.dart';
import 'package:schoolo_teacher/features/schedule/presentation/widgets/day_selector.dart';
import 'package:schoolo_teacher/features/schedule/presentation/widgets/empty_schedule.dart';
import 'package:schoolo_teacher/features/schedule/presentation/widgets/schedule_item_card.dart';
import 'package:schoolo_teacher/features/schedule/presentation/widgets/time_card.dart';
import 'package:schoolo_teacher/features/schedule/presentation/widgets/timeline_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SchedulePage extends StatefulWidget {
  final Map<int, List<ScheduleItem>>? apiScheduleData;

  const SchedulePage({super.key, this.apiScheduleData});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _currentDay = DateTime.now().weekday - 1;
  final ScrollController _scrollController = ScrollController();
  late Map<int, List<ScheduleItem>> _schedule;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _schedule = widget.apiScheduleData ?? _defaultSchedule;
  }

  final Map<int, List<ScheduleItem>> _defaultSchedule = {
    0: [ // Monday
      ScheduleItem(
        time: 'schedulee.time_slots.morning1'.tr(),
        subject: 'schedulee.subjects.Mathematics'.tr(),
        classroom: '${'schedulee.classroom'.tr()} 101',
        icon: Icons.functions,
        color: primaryColor,
      ),
      ScheduleItem(
        time: 'schedulee.time_slots.morning2'.tr(),
        subject: 'schedulee.subjects.Physics'.tr(),
        classroom: '${'schedulee.classroom'.tr()} 2',
        icon: Icons.science,
        color: const Color(0xFF00B894),
      ),
    ],
    1: [ // Tuesday
      ScheduleItem(
        time: 'schedulee.time_slots.morning1'.tr(),
        subject: 'schedulee.subjects.Literature'.tr(),
        classroom: '${'schedulee.classroom'.tr()} 202',
        icon: Icons.menu_book,
        color: const Color(0xFFFD79A8),
      ),
      ScheduleItem(
        time: 'schedulee.time_slots.afternoon1'.tr(),
        subject: 'schedulee.subjects.Advanced_Math'.tr(),
        classroom: '${'schedulee.classroom'.tr()} 203',
        icon: Icons.calculate,
        color: Colors.blue,
      ),
    ],
    2: [ // Wednesday
      ScheduleItem(
        time: 'schedulee.time_slots.morning2'.tr(),
        subject: 'schedulee.subjects.Quantum_Physics'.tr(),
        classroom: '${'schedulee.classroom'.tr()} Lab',
        icon: Icons.science,
        color: Colors.deepPurple,
      ),
    ],
    // Add more days as needed
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final updatedData = await _fetchScheduleFromAPI();
      setState(() {
        _schedule = updatedData;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<int, List<ScheduleItem>>> _fetchScheduleFromAPI() async {
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      0: [
        ScheduleItem(
          time: 'schedulee.time_slots.morning1'.tr(),
          subject: 'schedulee.subjects.Mathematics'.tr(),
          classroom: '${'schedulee.classroom'.tr()} 101',
          icon: Icons.functions,
          color: primaryColor,
        ),
        ScheduleItem(
          time: 'schedulee.time_slots.morning2'.tr(),
          subject: 'schedulee.subjects.Physics'.tr(),
          classroom: '${'schedulee.classroom'.tr()} 2',
          icon: Icons.science,
          color: const Color(0xFF00B894),
        ),
      ],
      1: [
        ScheduleItem(
          time: 'schedulee.time_slots.afternoon1'.tr(),
          subject: 'schedulee.subjects.Chemistry'.tr(),
          classroom: '${'schedulee.classroom'.tr()} 3',
          icon: Icons.science,
          color: Colors.orange,
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: primaryColor,
        displacement: SizeConfig.screenHeight!/9,
        strokeWidth: 3.0,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _DaySelectorDelegate(
                currentDay: _currentDay,
                onDaySelected: (day) {
                  setState(() => _currentDay = day);
                  _scrollController.animateTo(
                    0,
                    duration: 500.ms,
                    curve: Curves.easeOut,
                  );
                },
              ),
            ),
            if (_isLoading)
              SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildTimelineTile(index),
                childCount: _schedule[_currentDay]?.length ?? 0,
              ),
            ),
            if (_schedule[_currentDay]?.isEmpty ?? true)
              SliverFillRemaining(
                child: EmptySchedule(
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTile(int index) {
    final items = _schedule[_currentDay]!;
    final item = items[index];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! / 22),
      child: TimelineTile(
        alignment: TimelineAlign.center,
        isFirst: index == 0,
        isLast: index == items.length - 1,
        beforeLineStyle: LineStyle(
          // ignore: deprecated_member_use
          color: Colors.grey.withOpacity(0.3),
          thickness: 3,
        ),
        afterLineStyle: LineStyle(
          // ignore: deprecated_member_use
          color: Colors.grey.withOpacity(0.3),
          thickness: 3,
        ),
        indicatorStyle: IndicatorStyle(
          width: SizeConfig.defualtSize! * 5,
          height: SizeConfig.defualtSize! * 5,
          indicator: TimelineIndicator(item: item),
          padding: const EdgeInsets.all(8),
        ),
        startChild: TimeCard(item: item),
        endChild: ScheduleItemCard(
          item: item,
          onTap: () => _viewClassDetails(item),
        ),
      )
      .animate(delay: (100 * index).ms)
      .fadeIn(curve: Curves.easeOutCubic)
      .slideY(begin: 0.2, curve: Curves.easeOutBack),
    );
  }

  void _viewClassDetails(ScheduleItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffe6e6e6),
      builder: (context) => ClassDetailsSheet(item: item),
    );
  }
}

class _DaySelectorDelegate extends SliverPersistentHeaderDelegate {
  final int currentDay;
  final Function(int) onDaySelected;

  _DaySelectorDelegate({required this.currentDay, required this.onDaySelected});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return DaySelector(currentDay: currentDay, onDaySelected: onDaySelected);
  }

  @override
  double get maxExtent => 96;

  @override
  double get minExtent => 96;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}