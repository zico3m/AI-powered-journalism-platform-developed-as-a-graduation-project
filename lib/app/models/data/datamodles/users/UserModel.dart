class UserModel {
  final String id; // UUID from auth.users
  final String name;

  final String? pictureUrl; // يمكن أن يكون null

  final bool hasSelectedInterests; // <-- الحقل الجديد الذي أضفناه
  final int? userTypeId;
  final int? accountStatusId;

  UserModel({
    required this.id,
    required this.name,
    required this.userTypeId,
    this.pictureUrl,
    required this.accountStatusId,
    required this.hasSelectedInterests,
  });

  /// دالة Factory لتحويل بيانات JSON القادمة من جدول public.users إلى كائن UserModel.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      userTypeId: json['user_type_id'] as int?,
      pictureUrl: json['picture_url'],
      accountStatusId: json['account_status_id'] as int?,
      hasSelectedInterests: json['has_selected_interests'] ??
          false, // القيمة الافتراضية false للأمان
    );
  }

  /// دالة مساعدة لتحويل الكائن إلى JSON (مفيدة لعمليات التحديث).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_type_id': userTypeId,
      'picture_url': pictureUrl,
      'account_status_id': accountStatusId,
      'has_selected_interests': hasSelectedInterests,
    };
  }
}

