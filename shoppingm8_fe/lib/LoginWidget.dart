import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://live.staticflickr.com/65535/48369301137_482117c791_b.jpg"),
                  fit: BoxFit.cover
              ),
            ),
          ),
          Center(
            child: Card(
              margin: EdgeInsets.all(40.0),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Title(
                      color: Colors.black,
                      child: Text(
                          "Please, login to your ShoppingM8!",
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                      )
                    ),
                    TextField(
                      autofocus: true,
                      autocorrect: false,
                      decoration: InputDecoration(labelText: "email"),
                      controller: emailController,
                    ),
                    TextField(
                      autofocus: false,
                      autocorrect: false,
                      decoration: InputDecoration(labelText: "password"),
                      controller: passwordController,
                      obscureText: true,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text("LOGIN"),
                        color: Colors.lightGreen,
                        onPressed: () => {print("LOGIN")},
                      )
                    ),
                    Row(
                        children: <Widget>[
                          Expanded(
                              child: Divider()
                          ),
                          Text("OR"),
                          Expanded(
                              child: Divider()
                          ),
                        ]
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: OutlineButton(
                              splashColor: Colors.grey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage("assets/google.png"),
                                    height: 25.0,
                                  ),
                                  Container(
                                    width: 230,
                                    child: Text(
                                      "Login with Google",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: OutlineButton(
                              splashColor: Colors.grey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage("assets/facebook.png"),
                                    height: 25.0,
                                  ),
                                  Container(
                                    width: 240,
                                    child: Text(
                                      "Login with Facebook",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Column(
                        children: <Widget>[
                          Text(
                              "Don't have the account yet?",
                            style: TextStyle(
                              color: Colors.black26
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: FlatButton(
                                child: Text("REGISTER"),
                                color: Colors.lightGreen,
                                onPressed: () => {print("register")},
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                )
              )
            ),
          )
        ],
      )
    );
  }

}