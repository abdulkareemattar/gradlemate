import 'dart:convert';
import 'package:http/http.dart' as http;
/// Represents the entire compatibility payload
class CompatibilityData {
  final Map<String, AgpCompatibilityRange> androidStudioAgpCompatibility;
  final Map<String, String> agpGradleCompatibility;
  final Map<String, JdkCompatibilityRange> jdkCompatibility;

  CompatibilityData({
    required this.androidStudioAgpCompatibility,
    required this.agpGradleCompatibility,
    required this.jdkCompatibility,
  });

  factory CompatibilityData.fromJson(Map<String, dynamic> json) {
    final asAgpMap = <String, AgpCompatibilityRange>{};
    (json['androidStudioAgpCompatibility'] as Map<String, dynamic>)
        .forEach((key, value) {
      asAgpMap[key] = AgpCompatibilityRange.fromJson(value as Map<String, dynamic>);
    });

  final agpGradleMap = <String, String>{};
    (json['agpGradleCompatibility'] as Map<String, dynamic>)
        .forEach((key, value) {
      agpGradleMap[key] = value as String;
    });

    final jdkMap = <String, JdkCompatibilityRange>{};
    (json['jdkCompatibility'] as Map<String, dynamic>)
        .forEach((key, value) {
      jdkMap[key] = JdkCompatibilityRange.fromJson(value as Map<String, dynamic>);
    });

    return CompatibilityData(
      androidStudioAgpCompatibility: asAgpMap,
      agpGradleCompatibility: agpGradleMap,
      jdkCompatibility: jdkMap,
    );
  }
}

class AgpCompatibilityRange {
  final String minAgp;
  final String maxAgp;

  AgpCompatibilityRange({required this.minAgp, required this.maxAgp});

  factory AgpCompatibilityRange.fromJson(Map<String, dynamic> json) {
    return AgpCompatibilityRange(
      minAgp: json['min_agp'] as String,
      maxAgp: json['max_agp'] as String,
    );
  }
}

class JdkCompatibilityRange {
  final String gradleMin;
  final String gradleMax;

  JdkCompatibilityRange({required this.gradleMin, required this.gradleMax});

  factory JdkCompatibilityRange.fromJson(Map<String, dynamic> json) {
    return JdkCompatibilityRange(
      gradleMin: json['gradle_min'] as String,
      gradleMax: json['gradle_max'] as String,
    );
  }
}

class CompatibilityService {
  static const _rawUrl =
      'https://gist.githubusercontent.com/abdulkareemattar/46b2fc1fc0c8f44eb78b9ce72953a130/raw/46b2fc1fc0c8f44eb78b9ce72953a130/compatibility.json';


  Future<CompatibilityData> fetchCompatibilityData() async {
    final resp = await http.get(Uri.parse(_rawUrl));
    if (resp.statusCode != 200) {
      throw Exception('Failed to load compatibility data');
    }
    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    return CompatibilityData.fromJson(jsonMap);
  }
}

