import 'package:get_it/get_it.dart';
import 'package:my_chat_app/core/services/messaging_service.dart';
import 'package:my_chat_app/core/services/storage_service.dart';
import 'package:my_chat_app/viewmodels/chats_model.dart';
import 'package:my_chat_app/viewmodels/contacts_model.dart';
import 'package:my_chat_app/viewmodels/conversation_model.dart';
import 'package:my_chat_app/viewmodels/main_model.dart';
import 'package:my_chat_app/viewmodels/sign_in_model.dart';
import 'package:my_chat_app/core/services/chat_service.dart';
import 'package:my_chat_app/core/services/auth_service.dart';
import 'package:my_chat_app/core/services/navigator_service.dart';

GetIt getIt = GetIt.instance;

setupLocators() {
  getIt.registerLazySingleton(() => MessagingService());
  getIt.registerLazySingleton(() => NavigatorService());
  getIt.registerLazySingleton(() => ChatService());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => StorageService());

  getIt.registerFactory(() => MainModel());
  getIt.registerFactory(() => ChatsModel());
  getIt.registerFactory(() => SignInModel());
  getIt.registerFactory(() => ContactsModel());
  getIt.registerFactory(() => ConversationModel());
}
