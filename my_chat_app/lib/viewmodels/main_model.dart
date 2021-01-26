import 'package:my_chat_app/screens/contacts_page.dart';
import 'package:my_chat_app/viewmodels/base_model.dart';

class MainModel extends BaseModel {
  Future<void> navigateToContacts() {
    return navigatorService.navigateTo(ContactsPage());
  }
}
