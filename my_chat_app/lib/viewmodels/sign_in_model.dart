import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_chat_app/core/locator.dart';
import 'package:my_chat_app/core/services/auth_service.dart';
import 'package:my_chat_app/core/services/messaging_service.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/screens/sign_in_page.dart';
import 'package:my_chat_app/screens/whatsapp_main.dart';
import 'base_model.dart';

class SignInModel extends BaseModel {
  final AuthService _authService = getIt<AuthService>();
  final MessagingService _messagingService = getIt<MessagingService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User get currentUser => _authService.currentUser;

  Future<void> signIn(String email, String password) async {
   // if (userName.isEmpty) return;

    busy = true;

    try {
      var user = await _authService.signIn(email,password);

      var token = await _messagingService.getUserToken();

      /*

      await _firestore
          .collection('profile')
          .doc(user.uid)
          .set({'userName': userName,
        'image': 'https://placekitten.com/200/200',
        'token': token});

       */

      await navigatorService.navigateToReplace(WhatsAppMain());
    } catch (e) {
      busy = false;
    }

    busy = false;
  }

  Future<void> signOut() async {
    busy = true;

    try {
      var user = await _authService.signOut();

      await navigatorService.navigateToReplace(SignInPage());
    } catch (e) {
      busy = false;
    }

    busy = false;
  }
}
