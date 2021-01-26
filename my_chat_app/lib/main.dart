import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_chat_app/core/locator.dart';
import 'package:my_chat_app/screens/sign_in_page.dart';
import 'package:my_chat_app/core/services/navigator_service.dart';
import 'package:my_chat_app/screens/whatsapp_main.dart';
import 'package:my_chat_app/viewmodels/sign_in_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'viewmodels/sign_in_model.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings =
        Settings(host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  setupLocators();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => getIt<SignInModel>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Captain America',
        navigatorKey: getIt<NavigatorService>().navigatorKey,
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.redAccent,
        ),
        home: Consumer<SignInModel>(
          builder: (BuildContext context, SignInModel signInModel, Widget child) =>
              signInModel.currentUser == null ? SignInPage() : WhatsAppMain(),
        ),
      ),
    );
  }
}
