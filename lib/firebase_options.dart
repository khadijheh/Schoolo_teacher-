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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyB7TLv6O26Zexeo4_9UGqqByauBrowT0kA',
    appId: '1:838994041314:web:206011418476ebf1ab81bb',
    messagingSenderId: '838994041314',
    projectId: 'schoolteacher-9b8a7',
    authDomain: 'schoolteacher-9b8a7.firebaseapp.com',
    storageBucket: 'schoolteacher-9b8a7.firebasestorage.app',
    measurementId: 'G-7FP9QWZG3R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUwrqrivu3wlozHop_9Ylp92CNxDEp0J8',
    appId: '1:838994041314:android:e8808ea75d9e7d8eab81bb',
    messagingSenderId: '838994041314',
    projectId: 'schoolteacher-9b8a7',
    storageBucket: 'schoolteacher-9b8a7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1ju4vhh6i6zMQgPvthXi-OFh6vM_OOt4',
    appId: '1:838994041314:ios:43199473372cb97aab81bb',
    messagingSenderId: '838994041314',
    projectId: 'schoolteacher-9b8a7',
    storageBucket: 'schoolteacher-9b8a7.firebasestorage.app',
    iosBundleId: 'com.example.schooloTeacher',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1ju4vhh6i6zMQgPvthXi-OFh6vM_OOt4',
    appId: '1:838994041314:ios:43199473372cb97aab81bb',
    messagingSenderId: '838994041314',
    projectId: 'schoolteacher-9b8a7',
    storageBucket: 'schoolteacher-9b8a7.firebasestorage.app',
    iosBundleId: 'com.example.schooloTeacher',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB7TLv6O26Zexeo4_9UGqqByauBrowT0kA',
    appId: '1:838994041314:web:dfeb0eabf20fb5b2ab81bb',
    messagingSenderId: '838994041314',
    projectId: 'schoolteacher-9b8a7',
    authDomain: 'schoolteacher-9b8a7.firebaseapp.com',
    storageBucket: 'schoolteacher-9b8a7.firebasestorage.app',
    measurementId: 'G-KDHPZ0MDSM',
  );
}
