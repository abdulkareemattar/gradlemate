import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradle_mate/ui/serch_by_gradle.dart';
import 'package:provider/provider.dart';

import '../providers/compatibility_provider.dart';
import '../providers/theme_provider.dart';
import 'CompatibilityCheckerPage.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = const [
    GradleLookupPage(),
    FullCompatibilityPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompatibilityProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final PageController _controller = PageController(
      initialPage: provider.currentIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compatibility Solver',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(
              !isDark ? Icons.light_mode : Icons.dark_mode,
              color: colorScheme.onPrimary,
            ),
            tooltip: "Toggle theme",
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? [Colors.black87, Colors.grey[900]!]
                : [Colors.teal[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: PageView(
          controller: _controller,
          onPageChanged: provider.onPageChanged,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          child: BottomNavigationBar(
            backgroundColor: colorScheme.surface,
            currentIndex: provider.currentIndex,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
            onTap: (index) {
              provider.onPageChanged(index);
              _controller.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Check',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
