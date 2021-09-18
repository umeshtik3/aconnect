import 'package:a_connect/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordChangedSuccessfully extends StatefulWidget {
  PasswordChangedSuccessfully() : super();

  @override
  _PasswordChangedSuccessfully createState() => _PasswordChangedSuccessfully();
}

class _PasswordChangedSuccessfully extends State<PasswordChangedSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/tick.png',
                      fit: BoxFit.contain,
                      width: 60,
                      height: 60,
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Changed Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.bottomCenter,
                          // padding: EdgeInsets.fromLTRB(60, 15, 10, 10),
                          child: Text(
                            'Password changed successfully',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          )),
                      Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            textColor: Colors.white,
                            color: Color.fromARGB(255, 86, 30, 101),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => Login(),
                              ));
                            },
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}
