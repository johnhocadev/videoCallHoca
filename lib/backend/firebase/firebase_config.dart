import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyD-xCoEUwqtg3lPHQxNP_cNfaikxFYZa0Q",
            authDomain: "videocallhoca.firebaseapp.com",
            projectId: "videocallhoca",
            storageBucket: "videocallhoca.appspot.com",
            messagingSenderId: "24585157613",
            appId: "1:24585157613:web:c6ad204d36d2124aebc5e4"));
  } else {
    await Firebase.initializeApp();
  }
}
