import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required File file,
    required String path,
    String? contentType,
  }) async {
    final metadata = contentType == null
        ? null
        : SettableMetadata(contentType: contentType);

    final ref = _storage.ref(path);
    final task = await ref.putFile(file, metadata);

    return task.ref.getDownloadURL();
  }

  Future<void> deleteFile(String path) {
    return _storage.ref(path).delete();
  }
}
