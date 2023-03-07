import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:atlast_mobile_app/models/sample_model.dart';

class SampleService {
  Future<String> loadJsonFile() async {
    return await rootBundle.loadString('assets/sample_data.json');
  }

  Future getData() async {
    String _jsonData = await loadJsonFile();
    final _decodedJsonData = json.decode(_jsonData);
    return SampleModel.fromJson(_decodedJsonData);
  }
}
