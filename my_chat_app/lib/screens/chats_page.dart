import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:my_chat_app/models/conversation.dart';
import 'package:my_chat_app/viewmodels/chats_model.dart';

import '../viewmodels/sign_in_model.dart';
import 'conversation_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = GetIt.instance<ChatsModel>();
    var user = Provider.of<SignInModel>(context).currentUser;

    return ChangeNotifierProvider(
      create: (BuildContext context) => model,
      child: StreamBuilder<List<Conversation>>(
        stream: model.conversations(user.uid),
        builder: (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Yükleniyor...'));
          }

          return ListView(
            children: snapshot.data
                .map(
                  (doc) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doc.profileImage),
                      ),
                      title: Text(doc.name),
                      subtitle: Text(doc.displayMassage),
                      trailing: Column(
                        children: <Widget>[
                          Text("19:30"),
                          Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Theme.of(context).accentColor),
                            child: Center(
                              child: Text(
                                "16",
                                textScaleFactor: 0.8,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (content) => ConversationPage(
                              userId: user.uid,
                              conversation: doc,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
