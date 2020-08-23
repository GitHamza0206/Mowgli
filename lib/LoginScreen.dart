import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mowgli_app/AddCommande.dart';
import 'package:mowgli_app/DetailCommande.dart';
import 'HomePage.dart';
import 'package:international_phone_input/international_phone_input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final name_user = TextEditingController();
  final nbPhone_user = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  navigationPush(phone) {
    if (phone == '+212619109287') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCommande(),
          ));
    }
  }

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if (user != null) {
            /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ));*/
            navigationPush(phone);
          } else {
            print('Error');
          }
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Insérez le Code'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _codeController,
                      )
                    ],
                  ),
                  actions: [
                    FlatButton(
                      child: Text('Confirm'),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId,
                                smsCode: _codeController.text);

                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;
                        if (user != null) {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ));*/
                          navigationPush(phone);
                        } else {
                          print('error');
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nbPhone_user.dispose();
    super.dispose();
  }

  toHomePage(nbPhone_user) {
    if (nbPhone_user == '0619109287') {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => Home()));
    } else {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => CommandePage()));
    }
  }

  void subscribe(name, phoneNb) {
    String _role = "user";
    if (phoneNb == '+212619109287') {
      _role = "admin";
    }

    final _firestore = Firestore.instance
        .collection('Commandes')
        .add({'nom': name, 'nbPhone': phoneNb, 'role': _role}).then(
            (value) => print('user created'));

    Firestore.instance
        .collection('Commandes')
        .document()
        .collection('DetailCommande')
        .document()
        .setData({});
  }

  String phoneNumber;
  String phoneIsoCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = "+212" + number;
      phoneIsoCode = isoCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        new Card(
          color: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: new Container(
              padding: const EdgeInsets.all(40.0),
              width: 500,
              height: 500,
              child: Center(
                  child: new ListView(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Form(
                      key: _formKey,
                      child: new Column(
                        children: [
                          new TextFormField(
                            controller: name_user,
                            decoration: new InputDecoration(
                              labelText: "Votre prénom",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Veuillez renseigner votre nom complet';
                              }
                              return null;
                            },
                          ),
                          new InternationalPhoneInput(
                            onPhoneNumberChange: onPhoneNumberChange,
                            initialPhoneNumber: phoneNumber,
                            initialSelection: phoneIsoCode,
                            enabledCountries: ['+212', '+33'],
                          ),
                          /*new TextFormField(
                              controller: nbPhone_user,
                              decoration: new InputDecoration(
                                  labelText: "Votre numéro de télephone"),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                /*if (!validate_form('name', value)) {
                                  return 'Veuillez entrer un numéro de télephone valide';
                                }*/
                                return null;
                              }),*/
                          new Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: RaisedButton.icon(
                                  icon: new Icon(Icons.airport_shuttle),
                                  label: new Text('Connect'),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      /*Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text('Bienvenue')));*/
                                      //authenticate(name_user.text, nbPhone_user.text);
                                      loginUser(phoneNumber, context);
                                      subscribe(name_user.text, phoneNumber);
                                    }
                                  }))
                        ],
                      )),
                ],
              ))),
        )
      ],
    ));
  }
}

/*Positioned(
            top: 20,
            child: new Card(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: new Container(
                width: 250,
                height: 250,
              ),
            )) */
