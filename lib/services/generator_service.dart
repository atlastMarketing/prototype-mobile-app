import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:atlast_mobile_app/models/user_model.dart';

// ignore: constant_identifier_names
const String API_URL = String.fromEnvironment('API_URL', defaultValue: '');

class GeneratorService {
  Future<http.Response> fetchCaption(
    prompt, {
    required String platform,
    String voice = "",
    required UserModel userData,
    int generationNum = 1,
  }) async {
    final body = {
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
      },
    };
    final jsonBody = json.encode(body);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    return await http.post(
      Uri.parse('$API_URL/ml/caption'),
      headers: headers,
      body: jsonBody,
    );
  }
}
