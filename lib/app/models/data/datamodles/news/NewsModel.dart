import '../souces/SourceModel.dart';

class NewsModel {
  final int id;
  final String title;
  final String content;
  final String? primaryImageUrl;
  final DateTime? publishedAt;
  final DateTime? isBreakingUntil;

  final int? categoryId;
  final String? categoryName;

  final SourceModel? source; // 👈 فقط هذا
  final List<String> images;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.primaryImageUrl,
    this.publishedAt,
    this.isBreakingUntil,
    this.categoryId,
    this.categoryName,
    this.source,
    this.images = const [],
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'] ?? '',
      primaryImageUrl: json['primary_image'],
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      isBreakingUntil: json['is_breaking_until'] != null
          ? DateTime.parse(
        json['is_breaking_until']
            .toString()
            .replaceFirst(' ', 'T') + 'Z',
      )
          : null,

      categoryId: json['category_id'],
      categoryName: json['categories']?['name'],
      source: json['sources'] != null
          ? SourceModel.fromJson(json['sources'])
          : null,
      images: (json['news_images'] as List?)
          ?.map((e) => e['image_url'] as String)
          .toList() ??
          [],
    );
  }
}
