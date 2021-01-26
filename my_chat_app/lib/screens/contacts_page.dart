import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_chat_app/core/locator.dart';
import 'package:my_chat_app/models/profile.dart';
import 'package:my_chat_app/viewmodels/contacts_model.dart';

import '../viewmodels/sign_in_model.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kişiler"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ContactSearchDelegate(),);
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ContactsList(),
    );
  }
}

class ContactsList extends StatelessWidget {
  final String query;
  const ContactsList({
    Key key,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = getIt<ContactsModel>();
    var user = Provider.of<SignInModel>(context).currentUser;

    return FutureBuilder(
      future: model.getContacts(query),
      builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );

        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return ListView(
            children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.group, color: Colors.white),
            ),
            title: Text("Yeni grup"),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.person_add, color: Colors.white),
            ),
            title: Text("Yeni kişi"),
          ),
        ]..addAll(snapshot.data
                .map(
                  (profile) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage: NetworkImage(profile.image),
                    ),
                    title: Text(profile.userName),
                    onTap: () => model.startConversation(user, profile),
                  ),
                )
                .toList()));
      },
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      primaryColor: Colors.red,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ContactsList(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Aramak için bir şey yaz"),
    );
  }
}
