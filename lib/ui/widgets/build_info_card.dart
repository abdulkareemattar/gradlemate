import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../providers/compatibility_provider.dart';

Widget buildInfoCard(CompatibilityProvider provider, dynamic data) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Compatible Versions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            'AGP: ${data.agpGradleCompatibility[provider.selectedGradle]}',
          ),
          const SizedBox(height: 5),
          Text('JDK: ${provider.compatibleJdks.join(", ")}'),
        ],
      ),
    ),
  );
}
