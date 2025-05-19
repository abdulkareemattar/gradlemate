import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/compatibility_model.dart';

class CompatibilityService {
  final String _gistApiUrl = dotenv.env['GIST_API_URL']!;

  Future<CompatibilityData> fetchCompatibilityData() async {
    final resp = await http.get(Uri.parse(_gistApiUrl));
    if (resp.statusCode != 200) {
      throw Exception('Failed to load Gist metadata');
    }

    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    final files = jsonMap['files'] as Map<String, dynamic>;
    final content = files['gistfile1.txt']['content'] as String;

    final parsedContent = json.decode(content) as Map<String, dynamic>;
    return CompatibilityData.fromJson(parsedContent);
  }
}
