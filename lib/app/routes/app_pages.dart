import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../modules/akun/bindings/akun_binding.dart';
import '../modules/akun/views/akun_view.dart';
import '../modules/akun_detail/bindings/akun_detail_binding.dart';
import '../modules/akun_detail/views/akun_detail_view.dart';
import '../modules/detail_mobil/bindings/detail_mobil_binding.dart';
import '../modules/detail_mobil/views/detail_mobil_view.dart';
import '../modules/favorit/bindings/favorit_binding.dart';
import '../modules/favorit/views/favorit_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/informasi/bindings/informasi_binding.dart';
import '../modules/informasi/views/informasi_view.dart';
import '../modules/kebijakan_dan_privasi/bindings/kebijakan_dan_privasi_binding.dart';
import '../modules/kebijakan_dan_privasi/views/kebijakan_dan_privasi_view.dart';
import '../modules/list_mobil/bindings/list_mobil_binding.dart';
import '../modules/list_mobil/views/list_mobil_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/password_update/bindings/password_update_binding.dart';
import '../modules/password_update/views/password_update_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/tentang/bindings/tentang_binding.dart';
import '../modules/tentang/views/tentang_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.AKUN,
      page: () => const AkunView(),
      binding: AkunBinding(),
    ),
    GetPage(
      name: _Paths.LIST_MOBIL,
      page: () => const ListMobilView(),
      binding: ListMobilBinding(),
    ),
    GetPage(
      name: _Paths.FAVORIT,
      page: () => const FavoritView(),
      binding: FavoritBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MOBIL,
      page: () => const DetailMobilView(),
      binding: DetailMobilBinding(),
    ),
    GetPage(
      name: _Paths.AKUN_DETAIL,
      page: () => const AkunDetailView(),
      binding: AkunDetailBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_UPDATE,
      page: () => const PasswordUpdateView(),
      binding: PasswordUpdateBinding(),
    ),
    GetPage(
      name: _Paths.INFORMASI,
      page: () => const InformasiView(),
      binding: InformasiBinding(),
    ),
    GetPage(
      name: _Paths.TENTANG,
      page: () => const TentangView(),
      binding: TentangBinding(),
    ),
    GetPage(
      name: _Paths.KEBIJAKAN_DAN_PRIVASI,
      page: () => const KebijakanDanPrivasiView(),
      binding: KebijakanDanPrivasiBinding(),
    ),
  ];
}
