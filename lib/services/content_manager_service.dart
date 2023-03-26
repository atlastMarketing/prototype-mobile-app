import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:atlast_mobile_app/models/user_model.dart';

// ignore: constant_identifier_names
const String API_URL = String.fromEnvironment('API_URL', defaultValue: '');

class ContentManagerService {
  static Future<List<String>> saveContent(String imageUrl) async {
    final requestBody = {
      "image_url": imageUrl
    }; // TODO: needs user id, rest of post inputs, and to be configured to follow the content-manager format

    print(
        "** sending POST request to '/content-manager' with the following body: $requestBody");

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(
      Uri.parse('$API_URL/content-manager'),
      headers: headers,
      body: json.encode(requestBody),
    );
    // TODO: error handling
    final Map<String, dynamic> responseBody = json.decode(response.body);
    print(responseBody);
    return responseBody['contentId'];
  }
}
