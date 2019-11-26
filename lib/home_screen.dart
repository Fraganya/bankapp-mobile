import 'package:bankapp/deposits_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final Map user;

  HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  State createState() => new HomeScreenState(user);
}

class HomeScreenState extends State<HomeScreen> {
  Map user;

  HomeScreenState(this.user);

  final String balanceUrl = "http://192.168.43.81:80/api/balance/";
  final String depositsUrl = "http://192.168.43.81:80/api/deposits/";

  bool _inCall = false;

  void getBalance() async {
    setState(() {
      _inCall = true;
    });

    String sendUrl = "${balanceUrl}${user['id']}";
    try {
      var response = await http.get(sendUrl);
      print(response.body);
      var decodedReponse = jsonDecode(response.body);

      print(decodedReponse);

      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title:new Text("Bank Balance"),
              content:new Text(decodedReponse['balance']),
              actions: <Widget>[
                new FlatButton(onPressed: ()=>{
                  Navigator.of(context).pop()
                }, child: new Text('Close'))
              ],
            );


          }
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title:new Text("Bank Balance"),
              content:new Text("Could not be retrieved /"),
              actions: <Widget>[
                new FlatButton(onPressed: ()=>{
                  Navigator.of(context).pop()
                }, child: new Text('Close'))
              ],
            );

          }
      );
      print(e);
    }

    setState(() {
      _inCall = false;
    });
  }


  void getDeposits() async{

    setState(() {
      _inCall = true;
    });

    String sendUrl = "${depositsUrl}${user['id']}";

    try{
      var response = await http.get(sendUrl);

      print(response.body);
      var decodedResponse = jsonDecode(response.body);

      print(decodedResponse);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DepositsScreen(decodedResponse))
      );

    }catch(e){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title:new Text("Problem"),
              content:new Text("Could not fetch deposits /"),
              actions: <Widget>[
                new FlatButton(onPressed: ()=>{
                  Navigator.of(context).pop()
                }, child: new Text('Close'))
              ],
            );

          }
      );
      print(e);
    }

    setState(() {
      _inCall = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Smart Bank"),
        ),
        body: ModalProgressHUD(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 10.0,
                      child: Padding(
                          padding: EdgeInsets.all(13.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${user['name']}"),
                              Text("${user['email']}"),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        MaterialButton(
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          child: Text("Balance"),
                          onPressed: getBalance
                        ),
                        MaterialButton(
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          child: Text("Deposits"),
                          onPressed: getDeposits,
                        )
                      ],
                    ),
                  )
                ]),
          ),
          inAsyncCall: _inCall,
        ));
  }
}
