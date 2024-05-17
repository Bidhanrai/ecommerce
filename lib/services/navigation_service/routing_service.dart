import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/features/discover/discover_view.dart';
import '../../features/authentication/auth_view.dart';
import '../../features/splash_view.dart';

const String splashView = "splashView";
const String authView = "authView";
const String discoverView = "discoverView";


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashView:
      return customPageRoute(child: const SplashView(), routeSettings: settings);
    case authView:
      return customPageRoute(child: const AuthView(), routeSettings: settings);
    case discoverView:
      return customPageRoute(child: const DiscoverView(), routeSettings: settings);
    default:
      return MaterialPageRoute(builder: (context) => Material(child: Center(child: Text("No such route ${settings.name}"),)));
  }
}

Route<dynamic> customPageRoute({
  required Widget child,
  required RouteSettings routeSettings,
}) {
  if(Platform.isIOS) {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return child;
      },
      settings: routeSettings,
    );
  } else {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return child;
      },
      settings: routeSettings,
    );
  }
}