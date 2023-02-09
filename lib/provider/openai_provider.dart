import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftsbyai/models/openai_model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../constants/open_ai.dart';

final gptdataprovider = FutureProvider<GptData>((ref) async {
  var url = Uri.parse('https://api.openai.com/v1/completions');

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8',
    'Authorization': 'Bearer $apiKey'
  };

  final data = jsonEncode({
    "model": "text-davinci-001",
    "prompt": "Write a tagline for an ice cream shop.",
    "temperature": 0.4,
    "max_tokens": 64,
    "top_p": 1,
    "frequency_penalty": 0,
    "presence_penalty": 0
  });

  var response = await http.post(url, headers: headers, body: data);
  if (response.statusCode == 200) {
    print(response.body);
    final gptData = gptDataFromJson(response.body);
    return gptData;
  } else {
    throw Exception(["Response from API null"]);
  }
});
