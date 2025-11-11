import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/utils/decoration.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/appointments.dart';
import 'package:prime_health_doctors/views/dashboard/home/home.dart';
import 'package:prime_health_doctors/views/dashboard/profile/profile.dart';
import 'dashboard_ctrl.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardCtrl>(
      init: DashboardCtrl(),
      builder: (ctrl) {
        return PopScope(
          canPop: false,
          child: Obx(
            () => Scaffold(
              body: IndexedStack(index: ctrl.currentIndex.value, children: [Home(), Appointments(), Profile()]),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(0, -5))],
                ),
                child: BottomNavigationBar(
                  currentIndex: ctrl.currentIndex.value,
                  onTap: ctrl.changeTab,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: decoration.colorScheme.primary,
                  unselectedItemColor: Colors.grey,
                  elevation: 0,
                  selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Appointment'),
                    BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
