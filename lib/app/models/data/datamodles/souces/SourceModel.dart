class SourceModel {
  final int id;
  final String name;
  final String? logoUrl;

  SourceModel({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logo_url'],
    );
  }
}
