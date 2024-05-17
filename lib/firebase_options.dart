// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAs9pUkGjPgHQ-CJjeDB0R91SdUIxoGj9Y',
    appId: '1:89342887866:web:18a9371fa9f1ec210d3f83',
    messagingSenderId: '89342887866',
    projectId: 'emcommerce-4a322',
    authDomain: 'emcommerce-4a322.firebaseapp.com',
    storageBucket: 'emcommerce-4a322.appspot.com',
    measurementId: 'G-FCFKPMK84F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOC--uALjBVxe8u7z0r8oMJwh174wwjoQ',
    appId: '1:89342887866:android:81e50230d6b3dae90d3f83',
    messagingSenderId: '89342887866',
    projectId: 'emcommerce-4a322',
    storageBucket: 'emcommerce-4a322.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBn0UB5imHWkQVr04fnyPhGqqnKBAmpePg',
    appId: '1:89342887866:ios:8e114ef8b5668a620d3f83',
    messagingSenderId: '89342887866',
    projectId: 'emcommerce-4a322',
    storageBucket: 'emcommerce-4a322.appspot.com',
    iosBundleId: 'com.example.shoesEcommerce',
  );
}
