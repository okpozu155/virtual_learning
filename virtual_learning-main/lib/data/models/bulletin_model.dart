class BulletinModel {
  final String id;
  final String title;
  final String message;

  BulletinModel({
    required this.id,
    required this.title,
    required this.message,
  });

  factory BulletinModel.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {
    return BulletinModel(
      id: id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
    );
  }
}