import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/Announcement/presentation/pages/Announcement.dart';

class CreativeAnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final Color cardColor;
  final Color darkerColor;
  final Color _textColor = Color(0xff333333);

  CreativeAnnouncementCard({
    required this.announcement,
    required this.cardColor,
    required this.darkerColor,
    super.key,
  });

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    void showAnnouncementDetails(Announcement announcement) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: SizeConfig.defualtSize! * 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Draggable handle
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),

                // Header with title
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: primaryColor,
                          size: SizeConfig.defualtSize! * 4,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      HorizontalSpace(1),
                      Expanded(
                        child: Text(
                          announcement.title,
                          style: TextStyle(
                            fontSize: SizeConfig.defualtSize! * 2.5,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(SizeConfig.defualtSize! * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Content
                        Text(
                          announcement.content,
                          style: TextStyle(
                            fontSize: SizeConfig.defualtSize! * 2,
                            // ignore: deprecated_member_use
                            color: primaryColor.withOpacity(0.7),
                          ),
                        ),

                        VerticalSpace(2),
                        Divider(thickness: 1, color: blockColor),
                        VerticalSpace(1),

                        // Meta information with translation
                        Container(
                          padding: EdgeInsets.all(SizeConfig.defualtSize! * 3),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: SizeConfig.defualtSize! * 5,
                                height: SizeConfig.defualtSize! * 5,
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: primaryColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    announcement.author.substring(0, 1),
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.defualtSize! * 3,
                                    ),
                                  ),
                                ),
                              ),
                              HorizontalSpace(1),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    announcement.author,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontSize: SizeConfig.defualtSize! * 2,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(announcement.date),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: SizeConfig.defualtSize! * 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: () => showAnnouncementDetails(announcement),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(30),
          ),
          color: cardColor,
        ),
        child: ClipPath(
          clipper: _CurvedCardClipper(),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.defualtSize! * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with read indicator
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!announcement.isRead)
                      Padding(
                        padding: EdgeInsets.only(
                          top: SizeConfig.defualtSize! * 1.5,
                          right: SizeConfig.defualtSize! * 0.5,
                        ),
                        child: Container(
                          width: SizeConfig.defualtSize! * 1.5,
                          height: SizeConfig.defualtSize! * 1.5,
                          decoration: BoxDecoration(
                            color: blockColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        announcement.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.defualtSize! * 2.5,
                          color: _textColor,
                        ),
                      ),
                    ),
                    if (announcement.isImportant)
                      Tooltip(
                        message: 'announcements.important'.tr(),
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                          size: SizeConfig.defualtSize! * 3,
                        ),
                      ),
                  ],
                ),

                VerticalSpace(1.5),

                // Content
                Text(
                  announcement.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: SizeConfig.defualtSize! * 1.5,
                    // ignore: deprecated_member_use
                    color: _textColor.withOpacity(0.9),
                  ),
                ),

                VerticalSpace(1),

                // Footer with author and date
                Row(
                  children: [
                    // Author avatar
                    Container(
                      width: SizeConfig.defualtSize! * 4,
                      height: SizeConfig.defualtSize! * 4,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          announcement.author.substring(0, 1),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.defualtSize! * 2,
                          ),
                        ),
                      ),
                    ),

                    HorizontalSpace(1),

                    // Author name and date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalSpace(1),
                          Text(
                            announcement.author,
                            style: TextStyle(
                              fontSize: SizeConfig.defualtSize! * 1.8,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HorizontalSpace(1),
                              Container(
                                alignment: Alignment.center,
                                height: SizeConfig.defualtSize! * 2.5,
                                width: SizeConfig.defualtSize! * 13,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  // ignore: deprecated_member_use
                                  color: whiteColor.withOpacity(0.7),
                                ),
                                child: Text(
                                  _formatDate(announcement.date),
                                  style: TextStyle(
                                    fontSize: SizeConfig.defualtSize! * 1.2,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurvedCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20);
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(0, size.height, 30, size.height);
    path.lineTo(size.width - 30, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 30);
    path.quadraticBezierTo(size.width, 0, size.width - 10, 0);
    path.lineTo(20, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
