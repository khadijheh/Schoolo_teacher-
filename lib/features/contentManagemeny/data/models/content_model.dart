import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum ContentType { image, video, pdf, text, other, }

class ContentModel {
  final String id;
  final String title;
  final String description;
  final ContentType type;
  final List<String> fileUrls;
  final List<String> fileNames;
  final List<int> fileSizes;
  final DateTime uploadDate;
  final DateTime? lastModified;
  final String authorId;
  final List<String> tags;

  ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.fileUrls,
    required this.fileNames,
    required this.fileSizes,
    required this.uploadDate,
    this.lastModified,
    required this.authorId,
    this.tags = const [],
  });
  Color get color {
    switch (type) {
      case ContentType.image:
        return Colors.blue;
      case ContentType.video:
        return Colors.red;
      case ContentType.pdf:
        return Colors.orange;
      case ContentType.text:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (type) {
      case ContentType.image:
        return Icons.image;
      case ContentType.video:
        return Icons.videocam;
      case ContentType.pdf:
        return Icons.picture_as_pdf;
      case ContentType.text:
        return Icons.text_fields;
      default:
        return Icons.insert_drive_file;
    }
  }

  String get typeName {
    switch (type) {
      case ContentType.image:
        return 'صورة';
      case ContentType.video:
        return 'فيديو';
      case ContentType.pdf:
        return 'ملف PDF';
      case ContentType.text:
        return 'نص';
      default:
        return 'آخر';
    }
  }
}

extension ContentTypeExtension on ContentType {
  FileType toFileType() {
    switch (this) {
      case ContentType.image:
        return FileType.image;
      case ContentType.video:
        return FileType.video;
      case ContentType.pdf:
        return FileType.custom;
      case ContentType.text:
        return FileType.custom;
      case ContentType.other:
        return FileType.any;
    }
  }
}

class FileUtils {
  static IconData getFileIcon(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'png' || ext == 'jpeg') return Icons.image;
    if (ext == 'mp4' || ext == 'mov') return Icons.videocam;
    if (ext == 'pdf') return Icons.picture_as_pdf;
    if (ext == 'txt') return Icons.text_fields;
    if (ext == 'doc' || ext == 'docx') return Icons.description;
    if (ext == 'xls' || ext == 'xlsx') return Icons.table_chart;
    return Icons.insert_drive_file;
  }

  static String getFileTypeName(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'png' || ext == 'jpeg') return 'صورة';
    if (ext == 'mp4' || ext == 'mov') return 'فيديو';
    if (ext == 'pdf') return 'ملف PDF';
    if (ext == 'txt') return 'ملف نصي';
    if (ext == 'doc' || ext == 'docx') return 'ملف Word';
    if (ext == 'xls' || ext == 'xlsx') return 'ملف Excel';
    return 'ملف';
  }

  static bool isImage(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    return ext == 'jpg' || ext == 'png' || ext == 'jpeg';
  }

  static bool isVideo(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    return ext == 'mp4' || ext == 'mov';
  }
}
