import 'package:flutter/material.dart';

class NavigationService {

  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  pushReplacement(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  push(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  pushAndRemoveUntil(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!.pushNamedAndRemoveUntil(routeName, arguments: arguments, (route) => false);
  }

  pop({dynamic arguments}) {
    return navigationKey.currentState!.pop(arguments);
  }
}
