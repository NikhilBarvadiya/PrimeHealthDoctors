import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
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
              body: IndexedStack(index: ctrl.currentIndex.value, children: const [Home(), Appointments(), Profile()]),
              bottomNavigationBar: _buildFastBottomNavBar(ctrl),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFastBottomNavBar(DashboardCtrl ctrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFastNavItem(ctrl: ctrl, index: 0, icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
          _buildFastNavItem(ctrl: ctrl, index: 1, icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today_rounded, label: 'Appointments'),
          _buildFastNavItem(ctrl: ctrl, index: 2, icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildFastNavItem({required DashboardCtrl ctrl, required int index, required IconData icon, required IconData activeIcon, required String label}) {
    return Obx(() {
      final isActive = ctrl.currentIndex.value == index;
      return GestureDetector(
        onTap: () => ctrl.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12 + (4 * value), vertical: 8),
                  decoration: BoxDecoration(
                    color: !isActive ? Colors.transparent : null,
                    gradient: !isActive ? null : LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryBlue.withOpacity(0.9), AppTheme.accentTeal]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: !isActive ? null : [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isActive ? activeIcon : icon, size: 22, color: Color.lerp(Colors.grey.shade600, Colors.white, value)),
                      if (value > 0.1) ...[
                        SizedBox(width: 8 * value),
                        Opacity(
                          opacity: value,
                          child: Text(
                            label,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
