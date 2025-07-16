class AnnouncementModel {
  final String? id;
  final String? title;
  final String? message;
  final String? audience;
  final String? postedBy;
  final DateTime? createdAt;

  AnnouncementModel({
    this.id,
    this.title,
    this.message,
    this.audience,
    this.postedBy,
    this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    print('Announcement JSON: $json');
    return AnnouncementModel(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      audience: json['audience'] ?? '',
      postedBy: json['postedBy']?.toString() ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title ?? '',
        'message': message ?? '',
        'audience': audience ?? 'all',
      };
} 