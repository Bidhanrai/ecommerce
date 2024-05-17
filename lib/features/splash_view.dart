import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/features/authentication/auth_view.dart';
import 'package:shoes_ecommerce/features/discover/discover_view.dart';
import 'package:shoes_ecommerce/services/auth_service.dart';
import '../services/service_locator.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  _checkAuthentication() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if(locator<AuthService>().isLoggedIn) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const DiscoverView()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AuthView()), (route) => false);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
