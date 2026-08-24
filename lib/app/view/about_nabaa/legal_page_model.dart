class LegalPage {
  final String id;
  final String pageKey;
  final String title;
  final String content;
  final String version;

  LegalPage({
    required this.id,
    required this.pageKey,
    required this.title,
    required this.content,
    required this.version,
  });

  factory LegalPage.fromJson(Map<String, dynamic> json) {
    return LegalPage(
      id: json['id'],
      pageKey: json['page_key'],
      title: json['title'],
      content: json['content'],
      version: json['version'],
    );
  }
}
