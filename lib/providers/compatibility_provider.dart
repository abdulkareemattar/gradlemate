import 'package:flutter/material.dart';
import '../models/compatibility_model.dart';
import '../services/compatibility_service.dart' as compService;

class CompatibilityProvider extends ChangeNotifier {
  final compService.CompatibilityService _service = compService.CompatibilityService();
  CompatibilityData? _data;
  bool _loading = true;
  String? _error;
int currentIndex =0;
String? selectedGradle;
  String? selectedAgp;
  String? selectedJdk;
  String? selectedAndroidStudio;

  CompatibilityProvider() {
    fetchData();
  }

  CompatibilityData? get data => _data;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchData() async {
    try {
      _data = await _service.fetchCompatibilityData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setGradle(String? v) {
    selectedGradle = v;
    notifyListeners();
  }

  void setAgp(String? v) {
    selectedAgp = v;
    notifyListeners();
  }

  void setJdk(String? v) {
    selectedJdk = v;
    notifyListeners();
  }

  void setAndroidStudio(String? v) {
    selectedAndroidStudio = v;
    notifyListeners();
  }


  void onPageChanged(int index) {
      currentIndex = index;
      notifyListeners();
  }

  List<String> get compatibleAgps {
    if (_data == null || selectedGradle == null) return [];
    return _data!.agpGradleCompatibility.entries
        .where((e) => e.value == selectedGradle)
        .map((e) => e.key)
        .toList();
  }

  List<String> get compatibleJdks {
    if (_data == null || selectedGradle == null) return [];
    return _data!.jdkCompatibility.entries
        .where((e) {
      return _compareVersion(e.value.gradleMin, selectedGradle!) <= 0 &&
          _compareVersion(e.value.gradleMax, selectedGradle!) >= 0;
    })
        .map((e) => e.key)
        .toList();
  }

  List<String> get compatibleAndroidStudios {
    if (_data == null || compatibleAgps.isEmpty) return [];
    return _data!.androidStudioAgpCompatibility.entries
        .where((e) {
      return compatibleAgps.any((agp) =>
      _compareVersion(agp, e.value.minAgp) >= 0 &&
          _compareVersion(agp, e.value.maxAgp) <= 0
      );
    })
        .map((e) => e.key)
        .toList();
  }

  String? checkCompatibility() {
    if (_data == null ||
        selectedGradle == null ||
        selectedAgp == null ||
        selectedJdk == null ||
        selectedAndroidStudio == null) {
      return "Please select all four versions.";
    }

    final expectedGradle = _data!.agpGradleCompatibility[selectedAgp!];
    if (expectedGradle != selectedGradle) {
      return "AGP $selectedAgp requires Gradle $expectedGradle.";
    }

    final jdkRange = _data!.jdkCompatibility[selectedJdk!]!;
    if (_compareVersion(jdkRange.gradleMin, selectedGradle!) > 0 ||
        _compareVersion(jdkRange.gradleMax, selectedGradle!) < 0) {
      return "JDK $selectedJdk supports Gradle ${jdkRange.gradleMin}–${jdkRange.gradleMax}.";
    }

    final asRange = _data!.androidStudioAgpCompatibility[selectedAndroidStudio!]!;
    if (_compareVersion(selectedAgp!, asRange.minAgp) < 0 ||
        _compareVersion(selectedAgp!, asRange.maxAgp) > 0) {
      return "Android Studio $selectedAndroidStudio supports AGP ${asRange.minAgp}–${asRange.maxAgp}.";
    }

    return null;
  }

  int _compareVersion(String a, String b) {
    final pa = a.split('.').map(int.parse).toList();
    final pb = b.split('.').map(int.parse).toList();
    for (var i = 0; i < pa.length || i < pb.length; i++) {
      final na = i < pa.length ? pa[i] : 0;
      final nb = i < pb.length ? pb[i] : 0;
      if (na != nb) return na.compareTo(nb);
    }
    return 0;
  }
}
