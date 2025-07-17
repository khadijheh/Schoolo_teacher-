import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/features/Announcement/presentation/widget/creative_announcement_card.dart';

class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String author;
  final bool isImportant;
  final String? attachmentUrl;
  bool isRead;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
    this.isImportant = false,
    this.attachmentUrl,
    this.isRead = false,
  });
}
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = true;
  List<Announcement> _announcements = [];
  final List<Color> _cardColors = [
    // ignore: deprecated_member_use
    primaryColor.withOpacity(0.8),
    // ignore: deprecated_member_use
    Colors.blue.withOpacity(0.8),
    // ignore: deprecated_member_use
    Colors.green.withOpacity(0.8),
    // ignore: deprecated_member_use
    Colors.orange.withOpacity(0.8),
    // ignore: deprecated_member_use
    Colors.purple.withOpacity(0.8),
  ];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
 if (mounted) {
    setState(() => _isLoading = true);
  }
    await Future.delayed(Duration(seconds: 1));
if (mounted) {
    setState(() {
    _announcements = [
        Announcement(
          id: '1',
          title: 'Staff Meeting Reminder',
          content:
              'Mandatory staff meeting tomorrow at 2:00 PM in the conference room. Please bring your laptopsMandatory staff meeting tomorrow at 2:00 PM in the conference room. Please bring your laptopsMandatory staff meeting tomorrow at 2:00 PM in the conference room. Please bring your laptopsMandatory staff meeting tomorrow at 2:00 PM in the conference room. Please bring your laptopsMandatory staff meeting tomorrow at 2:00 PM in the conference room. Please bring your laptopsMandatory staff meeting tomorrow at 2:00 PM in the conference room. Please bring your laptops.',
          date: DateTime.now().subtract(Duration(days: 1)),
          author: 'Principal Smith',
          isImportant: true,
        ),
        Announcement(
          id: '2',
          title: 'Grading Deadline',
          content:
              'Quarterly grades must be submitted by Friday 5:00 PM. Late submissions will not be accepted.',
          date: DateTime.now().subtract(Duration(days: 3)),
          author: 'Academic Office',
          isRead: true,
        ),
        Announcement(
          id: '3',
          title: 'Professional Development',
          content:
              'Sign up for next month\'s PD workshops on the staff portal by end of day today.',
          date: DateTime.now().subtract(Duration(days: 5)),
          author: 'Professional Development',
          attachmentUrl: 'https://example.com/pd_schedule.pdf',
        ),
        Announcement(
          id: '4',
          title: 'Parent-Teacher Conferences',
          content:
              'Schedule for next week\'s conferences has been posted. Please review your assigned time slots.',
          date: DateTime.now().subtract(Duration(days: 7)),
          author: 'Administration',
          isImportant: true,
          isRead: true,
        ),
        Announcement(
          id: '5',
          title: 'Classroom Supplies',
          content:
              'New teaching materials have arrived. Please collect from the supply room during your free period.',
          date: DateTime.now().subtract(Duration(days: 2)),
          author: 'Operations',
        ),
      ];
         _isLoading = false;
    });}
  }

  List<Announcement> get _filteredAnnouncements {
    if (_searchController.text.isEmpty) {
      return _announcements;
    }
    return _announcements.where((announcement) {
      return announcement.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          announcement.content.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          announcement.author.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.defualtSize! * 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            // ignore: deprecated_member_use
                            color: primaryColor.withOpacity(0.01),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'announcements.search_hint'.tr(),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: primaryColor,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.defualtSize! * 1.5,
                                      horizontal: SizeConfig.defualtSize! * 1.5,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _isSearching = value.isNotEmpty;
                                    });
                                  },
                                ),
                              ),
                              if (_isSearching)
                                IconButton(
                                  icon: Icon(Icons.clear, color: primaryColor),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _isSearching = false;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _announcements.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.announcement,
                                size: SizeConfig.defualtSize! * 15,
                                // ignore: deprecated_member_use
                                color: primaryColor.withOpacity(0.7),
                              )
                              .animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 2000.ms)
                              .scaleXY(begin: 0.9, end: 1.1, duration: 2000.ms),
                              SizedBox(height: SizeConfig.defualtSize! * 2),
                              Text(
                                'announcements.no_announcements'.tr(),
                                style: TextStyle(
                                  fontSize: SizeConfig.defualtSize! * 2.5,
                                  // ignore: deprecated_member_use
                                  color: primaryColor.withOpacity(0.8),
                                ),
                              ).animate().fadeIn(delay: 300.ms),
                            ],
                          ),
                        )
                      : AnimationLimiter(
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 80),
                            itemCount: _filteredAnnouncements.length,
                            itemBuilder: (context, index) {
                              final announcement = _filteredAnnouncements[index];
                              final cardColor = _cardColors[index % _cardColors.length];
                              final darkerColor = Color.lerp(cardColor, Colors.black, 0.1)!;

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.defualtSize! * 1.5,
                                        vertical: SizeConfig.defualtSize! * 0.5,
                                      ),
                                      child: CreativeAnnouncementCard(
                                        announcement: announcement,
                                        cardColor: cardColor,
                                        darkerColor: darkerColor,
                                      ).animate().flip(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}