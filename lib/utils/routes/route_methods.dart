import 'package:get/get.dart';
import 'package:prime_health_doctors/utils/routes/route_name.dart';
import 'package:prime_health_doctors/views/auth/login/login.dart';
import 'package:prime_health_doctors/views/auth/register/register.dart';
import 'package:prime_health_doctors/views/auth/splash/splash.dart';
import 'package:prime_health_doctors/views/dashboard/dashboard.dart';
import 'package:prime_health_doctors/views/no_internet.dart';

class AppRouteMethods {
  static GetPage<dynamic> getPage({required String name, required GetPageBuilder page, List<GetMiddleware>? middlewares}) {
    return GetPage(name: name, page: page, transition: Transition.topLevel, showCupertinoParallax: true, middlewares: middlewares ?? [], transitionDuration: 350.milliseconds);
  }

  static List<GetPage> pages = [
    getPage(name: AppRouteNames.splash, page: () => const Splash()),
    getPage(name: AppRouteNames.noInternet, page: () => const NoInternet()),
    getPage(name: AppRouteNames.login, page: () => const Login()),
    getPage(name: AppRouteNames.register, page: () => const Register()),
    getPage(name: AppRouteNames.dashboard, page: () => const Dashboard()),
  ];
}
