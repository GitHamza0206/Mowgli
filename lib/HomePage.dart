import 'dart:async';
//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mowgli_app/LoginScreen.dart';
import 'PostDetailsPage.dart';
import 'AddCommande.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // firebase connection
  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> snapshot;
  CollectionReference collectionReference =
      Firestore.instance.collection('Commandes');

  Color gradientStart = Colors.deepPurple[700];
  Color gradientEnd = Colors.purple[500];

  CollectionReference collection = Firestore.instance
      .collection('Commandes')
      .document('GuLreCiZqgVsVthdFH5BlUtajsX2')
      .collection('DetailCommande');

  //create passData

  passData(DocumentSnapshot snap) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => PostDetails(
              snapshot: snap,
            )));
  }

  passDataCollection(CollectionReference collection) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => PostDetails2(
              collection: collection,
            )));
  }

  goToAdd() {
    debugPrint('button pressed');
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => CommandePage()));
  }

  // get data from firebase
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        snapshot = datasnapshot.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Mowgli'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () => debugPrint('hey')),
            new IconButton(
                icon: new Icon(Icons.add), onPressed: () => goToAdd())
          ],
        ),
        drawer: new Drawer(
            child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text('Zerouali Hamza'),
                accountEmail: new Text('0637991102')),
            new ListTile(
                title: new Text('Passer Commande'),
                leading: new Icon(
                  Icons.cake,
                  color: Colors.purple,
                )),
            new ListTile(
                title: new Text('Voir la localisation'),
                leading: new Icon(Icons.local_grocery_store,
                    color: Colors.blueAccent)),
            new ListTile(
              title: new Text('Go to Login page'),
              leading: new Icon(Icons.home),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new LoginPage()));
              },
            ),
            new Divider(
              height: 10.0,
              color: Colors.black,
            ),
            new ListTile(
              title: new Text('Close'),
              trailing: new Icon(Icons.close),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )),
        body: new Container(
            decoration: BoxDecoration(
                gradient: new LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.0, 0.5),
              stops: [0.0, 1.0],
            )),
            child: new StreamBuilder(
                stream: Firestore.instance.collection('Commandes').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Center(
                      child: new Text('Loading...'),
                    );
                  } else {
                    //print(snapshot.data.documents);
                    return new ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return new Card(
                          elevation: 0.0,
                          color: Colors.transparent.withOpacity(0.1),
                          margin: EdgeInsets.all(10.0),
                          child: new Container(
                            padding: EdgeInsets.all(10.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new CircleAvatar(
                                  child: new Text('Z'),
                                  //new Text(snapshot.data.documents[index]['title'][0]),
                                  backgroundColor: Colors.yellow,
                                  foregroundColor: Colors.black,
                                ),
                                new SizedBox(
                                  width: 12.0,
                                ),
                                new Container(
                                  width: 210.0,
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new InkWell(
                                        child: new Text(
                                          snapshot.data.documents[index]
                                              ['nbPhone'],
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                        ),
                                        onTap: () {
                                          passDataCollection(collection);
                                          //passData(snapshot.data.documents[index]);
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                })));
  }
}
