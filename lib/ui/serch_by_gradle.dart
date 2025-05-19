import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradle_mate/ui/widgets/build_dropdown.dart';
import 'package:gradle_mate/ui/widgets/build_section_title.dart';
import 'package:provider/provider.dart';

import '../providers/compatibility_provider.dart';

class GradleLookupPage extends StatelessWidget {
  const GradleLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Consumer<CompatibilityProvider>(
        builder: (ctx, prov, _) {
          if (prov.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null) {
            return Center(
              child: Text(
                'Error: ${prov.error}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          final data = prov.data!;

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSectionTitle('Select Gradle Version'),
                          SizedBox(height: 8.h),
                          buildDropdown(
                            context,
                            prov.selectedGradle,
                            'Choose...',
                            data.agpGradleCompatibility.values
                                .toSet()
                                .toList()
                              ..sort((a, b) => -a.compareTo(b)),
                            prov.setGradle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: prov.selectedGradle == null
                          ? null
                          : () => prov.notifyListeners(),
                      icon: const Icon(Icons.search),
                      label: const Text('Show Compatibility'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  if (prov.selectedGradle != null) ...[
                    _buildCompatibilityCard(
                      title: 'Compatible AGP',
                      items: prov.compatibleAgps,
                    ),
                    _buildCompatibilityCard(
                      title: 'Compatible JDK',
                      items: prov.compatibleJdks,
                    ),
                    _buildCompatibilityCard(
                      title: 'Compatible Android Studio',
                      items: prov.compatibleAndroidStudios,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompatibilityCard({
    required String title,
    required List<String> items,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            ...items.map(
                  (item) => ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                title: Text(item),
                leading: const Icon(Icons.check_circle_outline, color: Colors.teal, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
