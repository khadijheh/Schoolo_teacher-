class SectionModel {
  final String id;
  final String name;
  final String? localizedNameKey;
  final String streamType;
  final String? localizedStreamTypeKey;
  final bool isActive;
  final int capacity;
  final List<dynamic> content;

  SectionModel({
    required this.id,
    required this.name,
    this.localizedNameKey,
    required this.streamType,
    this.localizedStreamTypeKey,
    required this.isActive,
    required this.capacity,
    required this.content,
  });
}