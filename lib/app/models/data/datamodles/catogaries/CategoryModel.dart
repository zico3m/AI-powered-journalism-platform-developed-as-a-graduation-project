// lib/app/models/data/CategoryModel.dart

class CategoryModel {
  final int id;
  final String name;
  final String? details; // الحقل اختياري، لذلك يمكن أن يكون null

  CategoryModel({
    required this.id,
    required this.name,
    this.details,
  });

  /// دالة Factory لتحويل بيانات JSON القادمة من Supabase إلى كائن CategoryModel.
  ///
  /// الـ Factory Constructor هو طريقة خاصة لإنشاء كائن لا تقوم دائماً بإنشاء نسخة جديدة،
  /// وهنا نستخدمه لتنظيم منطق التحويل من JSON.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      details: json['details'],
    );
  }

  /// دالة مساعدة لتحويل الكائن إلى JSON (قد نحتاجها لاحقاً).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
    };
  }
}
