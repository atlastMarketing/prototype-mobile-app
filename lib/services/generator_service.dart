import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/constants/stock_images.dart';
import 'package:atlast_mobile_app/models/content_model.dart';
import 'package:atlast_mobile_app/models/user_model.dart';
import 'package:atlast_mobile_app/utils/print_error.dart';

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
    int? numOptions,
  }) async {
    http.Response? response;

    try {
      final requestBody = {
        'prompt': prompt,
        'prompt_info': {
          'voice': voice,
          'platform': platform,
          'num_options': numOptions,
        },
        'meta_user': {
          'user_id': userData.id,
        },
        'meta_business': {
          'business_name': userData.businessName,
          'business_type': userData.businessType,
          'business_industry': userData.businessIndustry,
          'business_description': userData.businessDescription,
          'business_voice': userData.businessVoice,
        },
        'meta_prompt': {
          'generation_num': generationNum,
          'full_catalyst': catalyst,
        },
      };
      print(
          "** sending POST request to '/ml/caption' with the following body: $requestBody");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      response = await http.post(
        Uri.parse('$API_URL/ml/caption'),
        headers: headers,
        body: json.encode(requestBody),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);
      // TODO: address bug here
      List<dynamic> extractedCaptions =
          responseBody['choices'].map((e) => e['text'].toString()).toList();
      List<String> extractedCaptionsTrimmed =
          extractedCaptions.map((e) => e.toString().trim()).toList();
      return extractedCaptionsTrimmed;
    } catch (err) {
      printAPIError(response, err);
      return [];
    }
  }

  static Future<List<int>> fetchRegularCampaignDates(
    String prompt,
    int startDate,
    CatalystCampaignOutputTypes campaignType, {
    required String platform,
    String voice = "",
    required UserModel userData,
    int generationNum = 1,
    required String catalyst,
    int? endDate,
    int? maxPosts,
  }) async {
    http.Response? response;

    try {
      final requestBody = {
        'prompt': prompt,
        'prompt_info': {
          'voice': voice,
          'platform': platform,
        },
        'campaign_type': catalystCampaignOutputApiEnums[campaignType],
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
          'business_voice': userData.businessVoice,
        },
        'meta_prompt': {
          'generation_num': generationNum,
          'full_catalyst': catalyst,
        },
      };
      print(
          "** sending POST request to '/campaign/regular' with the following body: $requestBody");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      response = await http.post(
        Uri.parse('$API_URL/campaign/regular'),
        headers: headers,
        body: json.encode(requestBody),
      );
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody
          .map((timestamp) =>
              timestamp is int ? timestamp : int.parse(timestamp))
          .toList();
    } catch (err) {
      printAPIError(response, err);
      return [];
    }
  }

  static Future<List<int>> fetchIrregularCampaignDates(
    String prompt,
    int startDate,
    CatalystCampaignOutputTypes campaignType, {
    required String platform,
    String voice = "",
    required UserModel userData,
    int generationNum = 1,
    required String catalyst,
    int? endDate,
    int? maxPosts,
  }) async {
    http.Response? response;

    try {
      final requestBody = {
        'prompt': prompt,
        'prompt_info': {
          'voice': voice,
          'platform': platform,
        },
        'campaign_type': catalystCampaignOutputApiEnums[campaignType],
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
          'business_voice': userData.businessVoice,
        },
        'meta_prompt': {
          'generation_num': generationNum,
          'full_catalyst': catalyst,
        },
      };
      print(
          "** sending POST request to '/campaign/irregular' with the following body: $requestBody");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      response = await http.post(
        Uri.parse('$API_URL/campaign/irregular'),
        headers: headers,
        body: json.encode(requestBody),
      );
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody
          .map((timestamp) =>
              timestamp is int ? timestamp : int.parse(timestamp))
          .toList();
    } catch (err) {
      printAPIError(response, err);
      return [];
    }
  }

  static Future<List<PostDraft>> fetchSuggestions({
    required SocialMediaPlatforms platform,
    String voice = "",
    required UserModel userData,
    int? numOptions,
  }) async {
    http.Response? response;

    try {
      final requestBody = {
        'prompt_info': {
          'voice': voice,
          'platform': socialMediaPlatformsOptions[platform],
          'num_options': numOptions,
        },
        'meta_user': {
          'user_id': userData.id,
        },
        'meta_business': {
          'business_name': userData.businessName,
          'business_type': userData.businessType,
          'business_industry': userData.businessIndustry,
          'business_description': userData.businessDescription,
          'business_voice': userData.businessVoice,
        },
        'meta_prompt': {},
      };
      print(
          "** sending POST request to '/ml/suggestions' with the following body: $requestBody");

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      response = await http.post(
        Uri.parse('$API_URL/ml/suggestions'),
        headers: headers,
        body: json.encode(requestBody),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);
      final int date = responseBody['date'];
      final List<dynamic> collections = responseBody['completions'];

      final List<PostDraft> extractedCollections = [];

      final Random randomizer = Random();

      for (dynamic collection in collections) {
        final String imageUrl =
            STOCK_IMAGES[randomizer.nextInt(STOCK_IMAGES.length - 1)];
        for (Map<String, dynamic> choice in collection['choices']) {
          extractedCollections.add(PostDraft(
            platform: platform,
            caption: choice['text'].trim(),
            dateTime: date,
            imageUrl: imageUrl,
          ));
        }
      }

      return extractedCollections;
    } catch (err) {
      printAPIError(response, err);
      return [];
    }
  }
}
