import "package:flutter/material.dart";


class DepositsScreen extends StatelessWidget{
  final List deposits;

  DepositsScreen(this.deposits);


  Card _buildDepositsForListView(BuildContext context,int index){
    print(deposits[index]['amount']);
    return Card(

      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("K ${deposits[index]['amount']}"),
            new Text("on ${deposits[index]['created_at']}")
          ],
        ),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Deposits"),
      ),
      body: ListView.builder(
        itemCount: deposits.length,
        itemBuilder: _buildDepositsForListView,
      ),
    );
  }
}