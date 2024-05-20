import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:shoes_ecommerce/features/discover/cubit/discover_cubit.dart';
import 'package:shoes_ecommerce/features/filter/cubit/filter_cubit.dart';
import 'package:shoes_ecommerce/services/auth_service.dart';
import 'package:shoes_ecommerce/services/navigation_service/navigation_service.dart';
import 'package:shoes_ecommerce/utils/app_theme.dart';
import 'firebase_options.dart';
import 'services/navigation_service/routing_service.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>CartCubit(locator<AuthService>().user?.uid)),
        BlocProvider(create: (_)=>DiscoverCubit()),
        BlocProvider(create: (_)=>FilterCubit()),
      ],
      child: MaterialApp(
        title: 'Shoes Mart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        navigatorKey: locator<NavigationService>().navigationKey,
        onGenerateRoute: generateRoute,
        initialRoute: splashView,
      ),
    );
  }
}