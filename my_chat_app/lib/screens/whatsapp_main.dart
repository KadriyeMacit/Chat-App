import 'package:flutter/material.dart';
import 'package:my_chat_app/core/locator.dart';
import 'package:my_chat_app/screens/calls_page.dart';
import 'package:my_chat_app/screens/camera_page.dart';
import 'package:my_chat_app/screens/chats_page.dart';
import 'package:my_chat_app/screens/status_page.dart';
import 'package:my_chat_app/viewmodels/main_model.dart';
import 'package:my_chat_app/viewmodels/sign_in_model.dart';
import 'package:provider/provider.dart';

class WhatsAppMain extends StatefulWidget {
  WhatsAppMain({Key key}) : super(key: key);

  @override
  _WhatsAppMainState createState() => _WhatsAppMainState();
}

class _WhatsAppMainState extends State<WhatsAppMain>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _showMessage = true;



  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4, initialIndex: 1);
    _tabController.addListener(() {
      _showMessage = _tabController.index == 1;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = getIt<MainModel>();
    var user = Provider.of<SignInModel>(context).currentUser;
    String name = '';

    if(user.email == "kadriye@gmail.com")
      {
        name = "Kadriye";
      }
    if(user.email == "berkay@gmail.com")
    {
      name = "Berkay";
    }
    var modelforOut = getIt<SignInModel>();

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  title: Text("Merhaba $name!"),
                  actions: <Widget>[

                  Padding(padding: EdgeInsets.only(right: 10),
                  child:  InkWell(
                    onTap: (){
                      modelforOut.signOut();
                    },
                    child: Image.asset("assets/images/logout.png", color: Colors.white, height: 10, width: 35,),
                  )
                  )
                  ],
                )
              ];
            },
            body: Column(
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.camera),
                    ),
                    Tab(
                      icon: Icon(Icons.mail),
                    ),
                    Tab( icon: Icon(Icons.favorite),),
                    Tab( icon: Icon(Icons.flare_outlined),),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        CameraPage(),
                        ChatsPage(),
                        StatusPage(),
                        CallsPage(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _showMessage
          ? FloatingActionButton(
              child: Icon(
                Icons.message,
                color: Colors.white,
              ),
              onPressed: () async {
                await model.navigateToContacts();
              },
            )
          : null,
    );
  }
}
