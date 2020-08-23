import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class CommandePage extends StatefulWidget {
  @override
  _CommandePageState createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
  String input = "";
  String quantite = "";

  List todos = [];

  final FirebaseAuth auth = FirebaseAuth.instance;
  dynamic data;

  Future<dynamic> getData() async {
    final FirebaseUser user = await auth.currentUser();
    List<dynamic> _articleList;
    final DocumentReference document = Firestore.instance
        .collection('Commandes')
        .document(user.uid)
        .collection('DetailCommande')
        .document('pmqEDtKcbsGtb0FSaBBB');
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
        for (final _article in data['articles']) {
          print(_article['nom_article']);
          _articleList.add(_article['nom_article']);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    print(uid);
    Firestore.instance
        .collection('Commandes')
        .document(user.uid)
        .updateData({'nbPhone': user.phoneNumber, 'nom': 'Zineb'});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Passer Commande'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.navigate_next),
            color: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      title: Text('Valider votre Commande ?'),
                      content: Row(
                        children: [
                          new FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new Home(),
                                    ));
                              },
                              child: Text('Oui')),
                          new FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Non')),
                        ],
                      ),
                    );
                  });
            },
          )
        ],
      ),
      body: new ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return new Dismissible(
              key: Key(todos[index]),
              child: new Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                elevation: 4.0,
                child: ListTile(
                  title: new Text(todos[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        todos.removeAt(index);
                        inputData();
                        getData();
                      });
                    },
                  ),
                ),
              ));
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  title: new Text('Article'),
                  content: new Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Votre Article'),
                        onChanged: (String value) => {input = value},
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Quantité'),
                        onChanged: (value) => {quantite = value},
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () {
                          setState(() {
                            todos.add(input);
                            inputData();
                            getData();
                          });

                          Navigator.of(context).pop();
                        },
                        child: new Text('Ajouter'))
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      persistentFooterButtons: <Widget>[
        new IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) => Home()));
          },
          icon: new Icon(Icons.check),
          color: Colors.green,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
