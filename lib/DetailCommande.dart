import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'HomePage.dart';
import 'PostDetailsPage.dart';
import 'package:flutter/material.dart';

class DetailCommande extends StatefulWidget {
  @override
  _DetailCommandeState createState() => _DetailCommandeState();
  DocumentSnapshot snapshot;
  DetailCommande({this.snapshot});
}

class _DetailCommandeState extends State<DetailCommande> {
  List<bool> _isSelected = new List<bool>();
  bool _visible = false;
  @override
  void initState() {
    setState(() {
      for (int i = 0; i < widget.snapshot['articles'].length; i++) {
        _isSelected.add(false);
      }
    });
  }

  bool validateCommande() {
    setState(() {
      if (!_isSelected.contains(false)) {
        _visible = true;
      } else {
        _visible = false;
      }
    });
    return _visible;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widget.snapshot['dateCMD'].toDate().toString()),
          backgroundColor: Colors.green,
        ),
        body: new ListView.builder(
          itemCount: widget.snapshot['articles'].length,
          itemBuilder: (context, index) {
            //return new Text(widget.snapshot['articles'][index]['nom_article']);
            return new CheckboxListTile(
                title: Text(widget.snapshot['articles'][index]['nom_article']),
                subtitle: Text(widget.snapshot['articles'][index]['quantite']),
                value: _isSelected[index],
                onChanged: (bool value) {
                  setState(() {
                    _isSelected[index] = value;
                    //TODO : add function that changes the achatFair attribute to value

                    Map<String, dynamic> _article_list =
                        widget.snapshot['articles'][index];

                    _article_list.update('achatFait', (event) {
                      return value;
                    });
                    /*
                  widget.snapshot.reference.updateData(<String, dynamic>{
                    'articles': FieldValue.arrayUnion([_article_list])
                  });*/
                  });
                });
          },
        ),
        floatingActionButton: new Visibility(
          visible: validateCommande(),
          child: new FloatingActionButton(
              autofocus: true,
              backgroundColor: Colors.green,
              elevation: 10.0,
              child: new Icon(Icons.check),
              onPressed: () {
                //TODO : add function that changes the done attribute to TRUE
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: Text('Valider la prise de commande?'),
                        content: Row(
                          children: [
                            new FlatButton(
                                onPressed: () {
                                  widget.snapshot.reference
                                      .updateData({'done': true});
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
              }),
        ));
  }
}
