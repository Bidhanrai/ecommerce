import 'package:get_it/get_it.dart';
import 'package:shoes_ecommerce/services/auth_service.dart';
import 'package:shoes_ecommerce/services/navigation_service/navigation_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
}