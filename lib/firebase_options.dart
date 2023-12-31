// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyAjcOaBgUEPSHHBt2Ie_jw2wdbdytONdC0',
    appId: '1:92438156013:web:9e9eb5d7d34facdb7ab2e4',
    messagingSenderId: '92438156013',
    projectId: 'adoptme-13fa4',
    authDomain: 'adoptme-13fa4.firebaseapp.com',
    storageBucket: 'adoptme-13fa4.appspot.com',
    measurementId: 'G-7G9GLSQ862',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlWaH46_mXO_c0jutnZp3ZJlu6iM7pacI',
    appId: '1:92438156013:android:62c9b057d45df3547ab2e4',
    messagingSenderId: '92438156013',
    projectId: 'adoptme-13fa4',
    storageBucket: 'adoptme-13fa4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDz8rsr_vF9ixzALu6JtBBtav6WqGT8c1g',
    appId: '1:92438156013:ios:fbe86e90e1241c117ab2e4',
    messagingSenderId: '92438156013',
    projectId: 'adoptme-13fa4',
    storageBucket: 'adoptme-13fa4.appspot.com',
    iosBundleId: 'com.lkw.adoptme',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDz8rsr_vF9ixzALu6JtBBtav6WqGT8c1g',
    appId: '1:92438156013:ios:b4f185d9ec376e5b7ab2e4',
    messagingSenderId: '92438156013',
    projectId: 'adoptme-13fa4',
    storageBucket: 'adoptme-13fa4.appspot.com',
    iosBundleId: 'com.lkw.adoptme.RunnerTests',
  );
}
