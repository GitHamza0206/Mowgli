import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'DetailCommande.dart';

class PostDetails extends StatefulWidget {
  DocumentSnapshot snapshot;
  PostDetails({this.snapshot});

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Historique des Commandes'),
          backgroundColor: Colors.green,
        ),
        body: new Card(
            elevation: 10.0,
            margin: EdgeInsets.all(10.0),
            child: new ListView.builder(
                itemCount: widget.snapshot.data['content'].length,
                itemBuilder: (context, index) {
                  return new Card(
                      elevation: 2.0,
                      child: new ListTile(
                        leading: new CircleAvatar(
                          child: new Text(widget.snapshot.data['title'][0]),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        title: new Text(widget.snapshot.data['content'][index]),
                      ));
                })),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.check),
          backgroundColor: Colors.green,
        ));
  }
}

class PostDetails2 extends StatefulWidget {
  @override
  _PostDetails2State createState() => _PostDetails2State();
  CollectionReference collection;
  PostDetails2({this.collection});
}

class _PostDetails2State extends State<PostDetails2> {
  List<DocumentSnapshot> snapshotCommande;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  detailCommande(DocumentSnapshot snap) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => DetailCommande(snapshot: snap)));
  }

  Color color;
  CommandeDone(AsyncSnapshot snapshot, int index) {
    if (snapshot.data.documents[index]['done']) {
      color = Colors.green;
    } else {
      color = Colors.red;
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Historique des Commandes'),
          backgroundColor: Colors.green,
        ),
        body: new Card(
            elevation: 10.0,
            margin: EdgeInsets.all(10.0),
            child: new StreamBuilder(
                stream: widget.collection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('No data');
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          Timestamp dateTS =
                              snapshot.data.documents[index]['dateCMD'];

                          DateTime date = dateTS.toDate();
                          return new Card(
                              elevation: 2.0,
                              child: new ListTile(
                                leading: new CircleAvatar(
                                  child: new Text(''),
                                  backgroundColor:
                                      CommandeDone(snapshot, index),
                                  foregroundColor: Colors.white,
                                ),
                                title: new Text(date.toString()),
                                onTap: () {
                                  detailCommande(
                                      snapshot.data.documents[index]);
                                },
                              ));
                        });
                  }
                })),

        /*new ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return new Card(
                      elevation: 2.0,
                      child: new ListTile(
                        leading: new CircleAvatar(
                          child: new Text('test'),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        title: new Text('test2'),
                      ));
                })),*/
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.check),
          backgroundColor: Colors.green,
          onPressed: () {
            print(widget.collection.getDocuments());
          },
        ));
  }
}
