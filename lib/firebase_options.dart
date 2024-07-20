// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  static final FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['WEBFIREBASEAPIKEY']!,
    appId: dotenv.env['WEBFIREBASEAPIID']!,
    messagingSenderId: dotenv.env['MESSAGINGSENDERID']!,
    projectId: 'chatify-41173',
    authDomain: 'chatify-41173.firebaseapp.com',
    storageBucket: 'chatify-41173.appspot.com',
    measurementId: 'G-P0JRJ7FGMQ',
  );

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['ANDROIDAPIKEY']!,
    appId: dotenv.env['ANDROIDAPPID']!,
    messagingSenderId: dotenv.env['MESSAGINGSENDERID']!,
    projectId: 'chatify-41173',
    storageBucket: 'chatify-41173.appspot.com',
  );

  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['IOSAPIKEY']!,
    appId: dotenv.env['IOSAPPID']!,
    messagingSenderId: dotenv.env['MESSAGINGSENDERID']!,
    projectId: 'chatify-41173',
    storageBucket: 'chatify-41173.appspot.com',
    iosBundleId: 'com.example.chatify',
  );
}
