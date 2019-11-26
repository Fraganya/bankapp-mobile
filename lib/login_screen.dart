import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'home_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  final String authUrl = "http://192.168.43.81:80/api/login";
  var data;
  bool _authenticating = false;

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  void authenticate() async {
    setState(() {
      _authenticating = true;
    });

    var postData = {'email': _email, 'password': _password}; //serialize data

    try {
      var response = await http.post(authUrl, body: postData);
      var decodedReponse = jsonDecode(response.body);
      print(response.body);
      print(decodedReponse);

      if (decodedReponse['status'] != true) {
        final snackBar = SnackBar(
          content: Text('Your credentials are invalid!'),
        );

         Scaffold.of(context).showSnackBar(snackBar);
         return;
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(user:decodedReponse['user']))
      );

    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Having issues with network!'),
      );

      //Scaffold.of(context).showSnackBar(snackBar);
      print(e);
    }

    //

    setState(() {
      _authenticating = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeIn);

    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/splash.jpg"),
              fit: BoxFit.cover,
              color: Colors.black87,
              colorBlendMode: BlendMode.darken,
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image(
                  image: new AssetImage("assets/logo-alt.png"),
                  height: _iconAnimation.value * 100,
                  width: _iconAnimation.value * 100,
                ),
                new Form(
                  key: _formKey,
                  child: new Theme(
                      data: new ThemeData(
                          brightness: Brightness.dark,
                          primarySwatch: Colors.teal,
                          inputDecorationTheme: new InputDecorationTheme(
                              labelStyle: new TextStyle(
                                  color: Colors.teal, fontSize: 20.0))),
                      child: new Container(
                          padding: const EdgeInsets.all(40.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new TextFormField(
                                decoration: new InputDecoration(
                                    labelText: "Enter email"),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) => {_email = value},
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter email address';
                                  }

                                  return null;
                                },
                              ),
                              new TextFormField(
                                decoration: new InputDecoration(
                                    labelText: "Enter Password"),
                                keyboardType: TextInputType.text,
                                onChanged: (value) => {_password = value},
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter password';
                                  }

                                  return null;
                                },
                                obscureText: true,
                              ),
                              new Padding(
                                  padding: const EdgeInsets.only(top: 20.0)),
                              new MaterialButton(
                                height: 40.0,
                                minWidth: 100.0,
                                color: Colors.teal,
                                textColor: Colors.white,
                                child: new Text("Login"),
                                onPressed: () => {
                                  if (_formKey.currentState.validate())
                                    {authenticate()}
                                },
                                splashColor: Colors.redAccent,
                              )
                            ],
                          ))),
                )
              ],
            ),
          ],
        ),
        inAsyncCall: _authenticating,
      ),
    );
  }
}
