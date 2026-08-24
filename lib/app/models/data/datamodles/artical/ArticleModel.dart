import '../users/UserModel.dart';

class ArticleModel {
  final int? id;
  final String title;
  final String content;
  final String? coverImage;
  final DateTime createdAt;
  final UserModel author;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    this.coverImage,
    required this.createdAt,
    required this.author,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as int?,
      title: json['title'],
      content: json['content'],
      coverImage: json['cover_image'],
      createdAt: DateTime.parse(json['created_at']),
      author: UserModel.fromJson(json['users']),
    );
  }

  /// ✅ copyWith الصحيح
  ArticleModel copyWith({
    String? title,
    String? content,
    String? coverImage,
  }) {
    return ArticleModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      coverImage: coverImage ?? this.coverImage,
      createdAt: createdAt,
      author: author,
    );
  }
}
