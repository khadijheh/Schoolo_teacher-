import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/contentManagemeny/data/models/content_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContentDetailsModal extends StatelessWidget {
  final ContentModel content;

  const ContentDetailsModal({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.defualtSize! * 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: SizeConfig.defualtSize! * 4,
                    height: SizeConfig.defualtSize! * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const VerticalSpace(2),
                Row(
                  children: [
                    Container(
                      width: SizeConfig.defualtSize! * 8,
                      height: SizeConfig.defualtSize! * 8,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: content.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          content.icon,
                          size: SizeConfig.defualtSize! * 4,
                          color: content.color,
                        ),
                      ),
                    ).animate().scale(delay: 100.ms),
                    const HorizontalSpace(3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.screenWidth! / 15,
                              color: primaryColor,
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          const VerticalSpace(1),
                          Text(
                            '${'content.uploaded_on'.tr()} ${content.uploadDate.toString().substring(0, 10)}',
                            style: TextStyle(
                              // ignore: deprecated_member_use
                              color: primaryColor.withOpacity(0.7),
                              fontSize: SizeConfig.screenWidth! / 25,
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                        ],
                      ),
                    ),
                  ],
                ),
                const VerticalSpace(3),
                Text(
                  'content.contents'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    fontSize: SizeConfig.screenWidth! / 20,
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const VerticalSpace(2),
                ...content.fileUrls.map((url) => _buildFileItem(url))
                    .toList()
                    .animate(interval: 100.ms)
                    .fadeIn()
                    .slideX(begin: 0.1),
                const VerticalSpace(2),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileItem(String url) {
    final isImage = url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.png');

    return Card(
      // ignore: deprecated_member_use
      color: primaryColor.withOpacity(0.05),
      margin: EdgeInsets.only(bottom: SizeConfig.screenHeight! / 80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: isImage
            ? Container(
                width: SizeConfig.defualtSize! * 4,
                height: SizeConfig.defualtSize! * 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(File(url)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                width: SizeConfig.defualtSize! * 4,
                height: SizeConfig.defualtSize! * 4,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  getFileTypeIcon(File(url)),
                  color: primaryColor,
                ),
              ),
        title: Text(
          url.split('/').last,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: SizeConfig.screenWidth! / 25,
          ),
        ),
        subtitle: Text(
          _getFileTypeText(File(url)),
          style: TextStyle(
            fontSize: SizeConfig.screenWidth! / 30,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  IconData getFileTypeIcon(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'png' || ext == 'jpeg') return Icons.image;
    if (ext == 'mp4' || ext == 'mov') return Icons.videocam;
    if (ext == 'pdf') return Icons.picture_as_pdf;
    if (ext == 'txt') return Icons.text_fields;
    return Icons.insert_drive_file;
  }

  String _getFileTypeText(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'png' || ext == 'jpeg') return 'content.type_image'.tr();
    if (ext == 'mp4' || ext == 'mov') return 'content.type_video'.tr();
    if (ext == 'pdf') return 'content.type_pdf'.tr();
    if (ext == 'txt') return 'content.type_text'.tr();
    return 'content.type_other'.tr();
  }
}