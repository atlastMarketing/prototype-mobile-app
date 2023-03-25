import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:atlast_mobile_app/models/user_model.dart';
import 'package:atlast_mobile_app/utils/print_error.dart';

// ignore: constant_identifier_names
const String API_URL = String.fromEnvironment('API_URL', defaultValue: '');

class UserService {
  static Future<UserModel?> fetchUserById(String id) async {
    http.Response? response;

    try {
      print("** sending GET request to '/user/$id'");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      response = await http.get(
        Uri.parse('$API_URL/user/$id'),
        headers: headers,
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);
      return UserModel.fromJson(responseBody);
    } catch (err) {
      printAPIError(response, err);
      return null;
    }
  }

  static Future<UserModel?> login(String email) async {
    http.Response? response;

    try {
      print("** sending POST request to '/user/login'");

      final requestBody = {'email': email};

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      response = await http.post(
        Uri.parse('$API_URL/user/login'),
        headers: headers,
        body: json.encode(requestBody),
      );
      if (response.statusCode == 404) return null;

      final Map<String, dynamic> responseBody = json.decode(response.body);
      return UserModel.fromJson(responseBody);
    } catch (err) {
      printAPIError(response, err);
      return null;
    }
  }

  static Future<String> createAccount(UserModel user) async {
    http.Response? response;

    try {
      final requestBody = user.toJson();
      print(
          "** sending POST request to '/user' with the following body: $requestBody");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      response = await http.post(
        Uri.parse('$API_URL/user'),
        headers: headers,
        body: json.encode(requestBody),
      );
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return responseBody['_id'];
    } catch (err) {
      printAPIError(response, err);
      return "";
    }
  }

  static Future<bool> updateAccount(UserModel user) async {
    http.Response? response;

    try {
      final requestBody = user.toJson();
      print(
          "** sending PUT request to '/user' with the following body: $requestBody");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      response = await http.put(
        Uri.parse('$API_URL/user'),
        headers: headers,
        body: json.encode(requestBody),
      );
      return true;
    } catch (err) {
      printAPIError(response, err);
      return false;
    }
  }
}
