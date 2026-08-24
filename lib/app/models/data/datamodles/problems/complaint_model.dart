class ComplaintModel {
  final String? id;
  final String? userId;
  final String name;
  final String email;
  final String subject;
  final String reason;
  final String? status;
  final DateTime? createdAt;

  ComplaintModel({
    this.id,
    this.userId,
    required this.name,
    required this.email,
    required this.subject,
    required this.reason,
    this.status,
    this.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      subject: json['subject'],
      reason: json['reason'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'subject': subject,
      'reason': reason,
    };
  }
}
