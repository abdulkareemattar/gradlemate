import 'package:flutter/material.dart';
import 'package:gradle_mate/ui/widgets/build_dropdown.dart';
import 'package:gradle_mate/ui/widgets/build_section_title.dart';
import 'package:provider/provider.dart';
import '../providers/compatibility_provider.dart';

class FullCompatibilityPage extends StatelessWidget {
  const FullCompatibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      body: Consumer<CompatibilityProvider>(
        builder: (ctx, prov, _) {
          final data = prov.data;

          if (prov.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (prov.error != null) {
            return Center(
              child: Text(
                'Error: ${prov.error}',
                style: TextStyle(color: colorScheme.error, fontSize: 16),
              ),
            );
          }

          if (data == null) {
            return const Center(
              child: Text('No data available.', style: TextStyle(fontSize: 16)),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListView(
              children: [
                _buildSectionCard(
                  context: context,
                  title: '1. Gradle Version',
                  child: buildDropdown(
                    context,
                    prov.selectedGradle,
                    'Select Gradle...',
                    data.agpGradleCompatibility.values
                        .toSet()
                        .toList()
                      ..sort((a, b) => -a.compareTo(b)),
                    prov.setGradle,
                  ),
                ),
                _buildSectionCard(
                  context: context,
                  title: '2. AGP Version',
                  child: buildDropdown(
                    context,
                    prov.selectedAgp,
                    'Select AGP...',
                    data.agpGradleCompatibility.keys.toList(),
                    prov.setAgp,
                  ),
                ),
                _buildSectionCard(
                  context: context,
                  title: '3. JDK Version',
                  child: buildDropdown(
                    context,
                    prov.selectedJdk,
                    'Select JDK...',
                    data.jdkCompatibility.keys.toList(),
                    prov.setJdk,
                  ),
                ),
                _buildSectionCard(
                  context: context,
                  title: '4. Android Studio Version',
                  child: buildDropdown(
                    context,
                    prov.selectedAndroidStudio,
                    'Select Android Studio...',
                    data.androidStudioAgpCompatibility.keys.toList(),
                    prov.setAndroidStudio,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isAllSelected(prov)
                        ? () {
                      final msg = prov.checkCompatibility();
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text(msg == null
                              ? '✅ Compatible'
                              : '⚠️ Not Compatible'),
                          content: Text(msg ??
                              'All selected versions are compatible.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                        : null,
                    icon: const Icon(Icons.check_circle_outline,color: Colors.teal,),
                    label: const Text('Check Compatibility'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isAllSelected(CompatibilityProvider prov) {
    return prov.selectedGradle != null &&
        prov.selectedAgp != null &&
        prov.selectedJdk != null &&
        prov.selectedAndroidStudio != null;
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle(title),

            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
