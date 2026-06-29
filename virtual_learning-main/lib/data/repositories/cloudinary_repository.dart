import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryRepository {

  static const String cloudName =
      'dqful8wad';

  static const String uploadPreset =
      'virtual_learning_upload';

  Future<String> uploadImage(File image) async {

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request =
    http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] =
        uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    final response =
    await request.send();

    final responseData =
    await response.stream.bytesToString();

    final data =
    jsonDecode(responseData);

    if (response.statusCode == 200) {
      return data['secure_url'];
    }

    throw Exception(data);
  }
}