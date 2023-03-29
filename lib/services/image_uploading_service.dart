import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const String API_URL = String.fromEnvironment('API_URL', defaultValue: '');
// ignore: constant_identifier_names
const String IMGUR_CLIENT_ID =
    String.fromEnvironment('IMGUR_CLIENT_ID', defaultValue: 'da02f29c3c2720c');
// TODO: remove hardcoded id

class ImageUploadingService {
  static uploadImage(File image) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/upload"));
    request.headers["Authorization"] = "Client-ID $IMGUR_CLIENT_ID";
    var file = await http.MultipartFile.fromPath(
      "image",
      image.path,
    );
    request.files.add(file);
    var response = await request.send();
    var result = await http.Response.fromStream(response)
        .then((value) => jsonDecode(value.body));
    var data = result["data"];
    return "https://i.imgur.com/" + data["id"] + ".jpeg";
  }
}
