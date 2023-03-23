import 'dart:convert';

import 'package:http/http.dart' as http;

void printAPIError(http.Response response, dynamic? err) {
  String message = "** API ERROR (${response.statusCode})";
  if (response.body.isEmpty) {
    message += ": NO INFORMATION FOUND";
    return;
  }

  final decodedBody = jsonDecode(response.body);
  if (decodedBody == null) {
    message += ": $err";
  } else {
    message += ": ${decodedBody['message']}";
  }
  print(message);
  return;
}
