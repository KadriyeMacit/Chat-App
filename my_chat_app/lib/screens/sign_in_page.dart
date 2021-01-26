import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_chat_app/core/locator.dart';
import 'package:my_chat_app/viewmodels/sign_in_model.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    final TextEditingController _editingController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (BuildContext context) => getIt<SignInModel>(),
      child: Consumer<SignInModel>(
        builder: (BuildContext context, SignInModel model, Widget child) =>
            Scaffold(

          body: SingleChildScrollView(
            child: Stack(
              children: [

                ClipPath(
                    clipper: TopBackgrounfImageClipper(),
                    child: Container(
                        height: 260,
                        width: size.width,
                        child: Container(color: Colors.red,)
                    )),

                Padding(
                  padding:  EdgeInsets.only(top: height*0.1, left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                      child: Image.asset("assets/images/loginImage.png", height: height*0.4,)),
                ),


                Container(
                  padding: EdgeInsets.all(8),
                  child: model.busy
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: height*0.55,),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  children: [

                                    SizedBox(height: height*0.02,),
                                    Theme(
                                      data: ThemeData(
                                        primaryColor: Colors.red,
                                        primaryColorDark: Colors.grey,
                                      ),
                                      child: TextField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.mail, color: Colors.red,),
                                            hintText: 'Mail adresi',
                                            prefixText: ' ',
                                          )),
                                    ),
                                    SizedBox(height: height*0.02,),
                                    Theme(
                                      data: ThemeData(
                                        primaryColor: Colors.red,
                                        primaryColorDark: Colors.grey,
                                      ),
                                      child: TextField(
                                          controller: _passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.vpn_key, color: Colors.red,),
                                            hintText: 'Parola',
                                            prefixText: ' ',
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height*0.04,),
                              InkWell(
                                onTap: () async =>
                                await model.signIn(_emailController.text, _passwordController.text),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(child: Text("Giriş yap", style: TextStyle(color: Colors.white),)),
                                  ),
                                ),
                              )
                            ],
                          ),
                      
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class TopBackgrounfImageClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstControlPoint = Offset(55, size.height / 1.4);
    var firstEndPoint = Offset(size.width / 1.7, size.height / 1.3);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (35), size.height - 95);
    var secondEndPoint = Offset(size.width, size.height / 2.4);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
