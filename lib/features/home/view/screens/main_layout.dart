import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iman_mate_mobile_app/features/home/presentation/screens/home_screen.dart';
import 'package:iman_mate_mobile_app/features/home/presentation/screens/statistics_screen.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/app_bar_content.dart';
import 'calendar_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int index = 1;

  final List<Widget> pages = [
    CalendarScreen(),
    HomeScreen(),
    StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Appbarcontent(),  automaticallyImplyLeading: false,),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (index) => setState(() {
          this.index = index;
        }),
        height: 90.h,
        backgroundColor: theme.navBarBg,
        indicatorColor: theme.navBarIndicator,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.calendar_month,
              color: theme.navBarIconUnselected,
              size: 24.sp,
            ),
            selectedIcon: Icon(
              Icons.calendar_month,
              color: theme.navBarIconSelected,
              size: 24.sp,
            ),
            label: "Calendar",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color: theme.navBarIconUnselected,
              size: 24.sp,
            ),
            selectedIcon: Icon(
              Icons.home,
              color: theme.navBarIconSelected,
              size: 24.sp,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.bar_chart,
              color: theme.navBarIconUnselected,
              size: 24.sp,
            ),
            selectedIcon: Icon(
              Icons.bar_chart,
              color: theme.navBarIconSelected,
              size: 24.sp,
            ),
            label: "Statistics",
          ),
        ],
      ),
      body: pages[index],
    );
  }
}