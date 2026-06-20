
class FirestoreCollections {
  static const String slides = 'slides';
  static const String quizzes = 'quizzes';
  static const String users = 'users';

  static String hotspots(String slideId) =>
      'slides/$slideId/hotspots';
}