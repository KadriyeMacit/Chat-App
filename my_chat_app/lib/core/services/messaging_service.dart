import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_chat_app/core/services/chat_service.dart';
import 'package:my_chat_app/core/services/navigator_service.dart';
import 'package:my_chat_app/screens/conversation_page.dart';

import '../locator.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final ChatService _chatService = getIt<ChatService>();

  MessagingService() {
    _firebaseMessaging.getToken().then((value) => print(value));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: _notificationClicked,
      onResume: _notificationClicked,
    );
  }

  Future _notificationClicked(Map<String, dynamic> message) async {
    var data = message['data'];
    var conversation = await _chatService.getConversation(data['conversationId'], data['senderId']);
    await _navigatorService.navigateTo(ConversationPage(
      conversation: conversation,
      userId: data['userId'],
    ));
  }

  Future<String> getUserToken() {
    return _firebaseMessaging.getToken();
  }
}
