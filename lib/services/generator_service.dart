import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:atlast_mobile_app/models/user_model.dart';

// ignore: constant_identifier_names
const String API_URL = String.fromEnvironment('API_URL', defaultValue: '');

class GeneratorService {
  static Future<List<String>> fetchCaptions(
    String prompt, {
    required String platform,
    String voice = "",
    required UserModel userData,
    int generationNum = 1,
    required String catalyst,
  }) async {
    final requestBody = {
      'prompt': prompt,
      'prompt_info': {
        'voice': voice,
        'platform': platform,
      },
      'meta_user': {
        'user_id': userData.id,
      },
      'meta_business': {
        'business_name': userData.businessName,
        'business_type': userData.businessType,
        'business_industry': userData.businessIndustry,
        'business_description': userData.businessDescription,
      },
      'meta_prompt': {
        'generation_num': generationNum,
        'full_catalyst': catalyst,
      },
    };
    print(
        "** sending POST request to '/ml/caption' with the following body: $requestBody");

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(
      Uri.parse('$API_URL/ml/caption'),
      headers: headers,
      body: json.encode(requestBody),
    );
    // TODO: error handling
    final Map<String, dynamic> responseBody = json.decode(response.body);
    print(responseBody);
    // TODO: address bug here
    List<dynamic> extractedCaptions1 =
        responseBody['choices'].map((e) => e['text'].toString()).toList();
    List<String> extractedCaptions =
        extractedCaptions1.map((e) => e.toString()).toList();
    return extractedCaptions;
  }

  static Future<List<int>> fetchRegularCampaignDates(
    String prompt,
    int startDate, {
    required String platform,
    String voice = "",
    required UserModel userData,
    int generationNum = 1,
    required String catalyst,
    int? endDate,
    int? maxPosts,
  }) async {
    final requestBody = {
      'prompt': prompt,
      'prompt_info': {
        'voice': voice,
        'platform': platform,
      },
      'start_date': startDate,
      'end_date': endDate,
      // TODO: don't hardcode this
      'timezone': 'America/Vancouver',
      'maximum_posts': maxPosts,
      'meta_user': {
        'user_id': userData.id,
      },
      'meta_business': {
        'business_name': userData.businessName,
        'business_type': userData.businessType,
        'business_industry': userData.businessIndustry,
        'business_description': userData.businessDescription,
      },
      'meta_prompt': {
        'generation_num': generationNum,
        'full_catalyst': catalyst,
      },
    };
    print(
        "** sending POST request to '/campaign/regular' with the following body: $requestBody");

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(
      Uri.parse('$API_URL/campaign/regular'),
      headers: headers,
      body: json.encode(requestBody),
    );
    // TODO: error handling
    final List<dynamic> responseBody = json.decode(response.body);
    return responseBody
        .map((timestamp) => timestamp is int ? timestamp : int.parse(timestamp))
        .toList();
  }

  static Future<List<int>> fetchIrregularCampaignDates(
    String prompt,
    int startDate, {
    required String platform,
    String voice = "",
    required UserModel userData,
    int generationNum = 1,
    required String catalyst,
    int? endDate,
    int? maxPosts,
  }) async {
    final requestBody = {
      'prompt': prompt,
      'prompt_info': {
        'voice': voice,
        'platform': platform,
      },
      'start_date': startDate,
      'end_date': endDate,
      // TODO: don't hardcode this
      'timezone': 'America/Vancouver',
      'maximum_posts': maxPosts,
      'meta_user': {
        'user_id': userData.id,
      },
      'meta_business': {
        'business_name': userData.businessName,
        'business_type': userData.businessType,
        'business_industry': userData.businessIndustry,
        'business_description': userData.businessDescription,
      },
      'meta_prompt': {
        'generation_num': generationNum,
        'full_catalyst': catalyst,
      },
    };
    print(
        "** sending POST request to '/campaign/irregular' with the following body: $requestBody");

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(
      Uri.parse('$API_URL/campaign/irregular'),
      headers: headers,
      body: json.encode(requestBody),
    );
    // TODO: error handling
    final List<dynamic> responseBody = json.decode(response.body);
    return responseBody
        .map((timestamp) => timestamp is int ? timestamp : int.parse(timestamp))
        .toList();
  }
}
