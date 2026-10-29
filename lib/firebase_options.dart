import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
///dart
/// // ...
/// await Firebase.initializeApp(
///    options: DefaultFirebaseOptions.currentPlatform,
/// );
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
    apiKey: 'AIzaSyBrmmwb34tiL1yVO5nndxb1TvS6MrAFzh0',
    appId: '1:169518249343:web:b7e3a25782322c9333d64a',
    messagingSenderId: '169518249343',
    projectId: 'reserveit-625cd',
    authDomain: 'reserveit-625cd.firebaseapp.com',
    storageBucket: 'reserveit-625cd.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrmmwb34tiL1yVO5nndxb1TvS6MrAFzh0',
    appId: '1:169518249343:android:6e308d460fe54feb33d64a',
    messagingSenderId: '169518249343',
    projectId: 'reserveit-625cd',
    storageBucket: 'reserveit-625cd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrmmwb34tiL1yVO5nndxb1TvS6MrAFzh0',
    appId: '1:169518249343:ios:39a8f5ed234616b833d64a',
    messagingSenderId: '169518249343',
    projectId: 'reserveit-625cd',
    storageBucket: 'reserveit-625cd.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBrmmwb34tiL1yVO5nndxb1TvS6MrAFzh0',
    appId: '1:169518249343:ios:39a8f5ed234616b833d64a',
    messagingSenderId: '169518249343',
    projectId: 'reserveit-625cd',
    storageBucket: 'reserveit-625cd.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBrmmwb34tiL1yVO5nndxb1TvS6MrAFzh0',
    appId: '1:169518249343:web:6df25f38030a2f4233d64a',
    messagingSenderId: '169518249343',
    projectId: 'reserveit-625cd',
    authDomain: 'reserveit-625cd.firebaseapp.com',
    storageBucket: 'reserveit-625cd.firebasestorage.app',
  );
}
