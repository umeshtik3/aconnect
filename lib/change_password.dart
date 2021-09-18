import 'dart:convert';

import 'package:a_connect/password_successfully_changed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'constant.dart';
import 'dashboard.dart';

Constants constant = new Constants();

class ChangePasswordScreen extends StatefulWidget {
  String token, baseurl;

  ChangePasswordScreen({Key key, this.token, this.baseurl}) : super(key: key);

  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePasswordScreen> {
  bool _validateCurrent = false;
  bool _validateNew = false;
  bool _validateConfirm = false;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController NewPasswordController = TextEditingController();
  TextEditingController ConfirmNewPasswordController = TextEditingController();

  changePasssword() async {
    var uri = Uri.parse('${widget.baseurl}' + Constants.DEANA_CHANGE_PASSWORD_URL);

    var requestBody = {
      'currentPassword': currentPasswordController.text,
      'newPassword': NewPasswordController.text,
    };
    Response response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": '${widget.token}'
      },
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      print(response.body);
      Fluttertoast.showToast(
          msg: "Successfully Changed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PasswordChangedSuccessfully(),
      ));
    } else {
      Fluttertoast.showToast(
          msg: "InCorrect Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

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
                  padding: EdgeInsets.all(10),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    alignment: Alignment.topLeft,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => DashboardScreen(
                            token: '${widget.token}',
                            baseurl: '${widget.baseurl}'),
                      ));
                    },
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          obscureText: true,
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 30, 101)),
                          controller: currentPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: _validateCurrent
                                ? 'Current password cant be empty'
                                : null,
                            labelText: 'Current Password',
                          ),
                        ),
                      ),
                      Container(
                        //  decoration: BoxDecoration(),
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          obscureText: true,
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 30, 101)),
                          controller: NewPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: _validateNew
                                ? 'New Password cant be empty'
                                : null,
                            labelText: 'New Password',
                          ),
                        ),
                      ),
                      Container(
                        //  decoration: BoxDecoration(),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          obscureText: true,
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 30, 101)),
                          controller: ConfirmNewPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: _validateConfirm
                                ? 'Confirm Password cant be empty'
                                : null,
                            labelText: 'Confirm New Password',
                          ),
                        ),
                      ),
                      Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            textColor: Colors.white,
                            color: Color.fromARGB(255, 86, 30, 101),
                            child: Text('Change Password'),
                            onPressed: () {
                              print(currentPasswordController.text);
                              print(NewPasswordController.text);
                              print(ConfirmNewPasswordController.text);
                              setState(() {
                                currentPasswordController.text.isEmpty
                                    ? _validateCurrent = true
                                    : _validateCurrent = false;
                                NewPasswordController.text.isEmpty
                                    ? _validateNew = true
                                    : _validateNew = false;
                                ConfirmNewPasswordController.text.isEmpty
                                    ? _validateConfirm = true
                                    : _validateConfirm = false;
                              });

                              //verify that all are fine
                              if (_validateCurrent ||
                                  _validateNew ||
                                  _validateConfirm) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Error'),
                                          content: Text('Fill all field'),
                                        ));
                              } else {
                                if (currentPasswordController.text !=
                                    NewPasswordController.text) {
                                  if (NewPasswordController.text ==
                                      ConfirmNewPasswordController.text) {
                                    changePasssword();
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                  'New Password & Confirm New Password must be same.'),
                                            ));
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'New Password should be different from Current password'),
                                          ));
                                }
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}
