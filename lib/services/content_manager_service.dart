import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/models/user_model.dart';
import 'package:atlast_mobile_app/utils/print_error.dart';

// ignore: constant_identifier_names
const String API_URL = String.fromEnvironment('API_URL', defaultValue: '');

class ContentManagerService {
  static Future<String?> saveContent(PostDraft data, UserModel user) async {
    http.Response? response;

    try {
      final requestBody = {
        "user_id": user.id,
        "caption": data.caption,
        "post_date": data.dateTime,
        "image_url": data.imageUrl,
        "platform": convertToDBEnum(data.platform),
        "is_draft": true,
      };

      print(
          "** sending POST request to '/content' with the following body: $requestBody");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final response = await http.post(
        Uri.parse('$API_URL/content'),
        headers: headers,
        body: json.encode(requestBody),
      );
      // TODO: error handling
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      return responseBody['_id'];
    } catch (err) {
      printAPIError(response, err);
      return null;
    }
  }

  static Future<List<PostContent>> getAllContent(String userId) async {
    http.Response? response;

    try {
      print("** sending GET request to '/content/user/$userId' ");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final response = await http.get(
        Uri.parse('$API_URL/content/user/$userId'),
        headers: headers,
      );

      final List<dynamic> responseBody = json.decode(response.body);
      final List<PostContent> content = [];

      for (Map<String, dynamic> post in responseBody) {
        content.add(PostContent.fromJson(post));
      }

      return content;
    } catch (err) {
      printAPIError(response, err);
      return [];
    }
  }

  static Future<PostContent?> getContent(String contentId) async {
    http.Response? response;

    try {
      print("** sending GET request to '/content/$contentId' ");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final response = await http.get(
        Uri.parse('$API_URL/content/$contentId'),
        headers: headers,
      );

      if (response.statusCode == 404) return null;

      final Map<String, dynamic> responseBody = json.decode(response.body);

      return PostContent.fromJson(responseBody);
    } catch (err) {
      printAPIError(response, err);
      return null;
    }
  }

  static Future<bool> updateContent(PostContent data) async {
    http.Response? response;

    try {
      final requestBody = data.toJson();

      print(
          "** sending PUT request to '/content/${data.id}' with the following body: $requestBody");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      await http.put(
        Uri.parse('$API_URL/content/${data.id}'),
        headers: headers,
        body: json.encode(requestBody),
      );

      return true;
    } catch (err) {
      printAPIError(response, err);
      return false;
    }
  }

  static Future<bool> deleteContent(String contentId) async {
    http.Response? response;

    try {
      print("** sending DELETE request to '/content/$contentId'");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      await http.delete(
        Uri.parse('$API_URL/content/$contentId'),
        headers: headers,
      );

      return true;
    } catch (err) {
      printAPIError(response, err);
      return false;
    }
  }
}
