import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/services/auth_service.dart';
import 'package:shoes_ecommerce/widgets/primary_button.dart';
import '../services/navigation_service/navigation_service.dart';
import '../services/navigation_service/routing_service.dart';
import '../services/service_locator.dart';
import '../utils/toast_message.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Signed in as"),
            Text(
              "${locator<AuthService>().user?.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Button.outlined(
              label: "Logout",
              onTap: () async {
                try {
                  bool success = await locator<AuthService>().signOutFromGoogle();
                  if(success) {
                    locator<NavigationService>().pushAndRemoveUntil(authView);
                  }
                } catch(e) {
                  toastMessage(message: "$e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

}
