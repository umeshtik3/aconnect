import 'dart:convert';
import 'package:a_connect/password_successfully_changed.dart';
import 'package:a_connect/securityCodeGenModel.dart';
import 'package:a_connect/securitycode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'dashboard.dart';

Constants constant = new Constants();

class SecurityReset extends StatefulWidget {
  String token, baseurl;

  SecurityReset({Key key, this.token, this.baseurl}) : super(key: key);

  @override
  _SecurityReset createState() => _SecurityReset();
}

class _SecurityReset extends State<SecurityReset> {
  // bool _validateCurrent=false;
  // bool _validateNew=false;
  // bool _validateConfirm=false;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController NewPasswordController = TextEditingController();
  TextEditingController ConfirmNewPasswordController = TextEditingController();
  SecurityCodeGenModel securityCodeGenModel;

  resetCode() async {
    if(currentPasswordController.text == null || currentPasswordController.text.length<4) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
                'Invalid Field'
            ),
            content: Text(
              "Current Pin can't be empty or invalid length. ",
              style: TextStyle(color: Colors.red),
            ),
          ),
      );
    } else if(NewPasswordController.text == null || NewPasswordController.text.length<4) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
              'Invalid Field'
          ),
          content: Text(
            "New Pin can't be empty or invalid length. ",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else if(ConfirmNewPasswordController.text == null || ConfirmNewPasswordController.text.length<4) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
              'Invalid Field'
          ),
          content: Text(
            "Confirm New Pin can't be empty or invalid length. ",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else if(NewPasswordController.text != ConfirmNewPasswordController.text) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
              'Invalid Field'
          ),
          content: Text(
            "New Pin and Confirm New Pin must be equal. ",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      var uri = Uri.parse('${widget.baseurl}' + Constants.DEANA_SECURITYRESET);

      var requestBody = {
        "mobilePin": NewPasswordController.text,
        "oldMobilePin": currentPasswordController.text
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
        if (jsonDecode(response.body)['pin_exist'] == true) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new DashboardScreen(token: token, baseurl: baseurl)));
        } else {
          Fluttertoast.showToast(
              msg: "Successfully not ReSet Your Pin",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new Security()));
        }
      } else {
        Fluttertoast.showToast(
            msg: "InCorrect Pin",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
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
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new DashboardScreen(token: token, baseurl: baseurl)));
                    },
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Change Security Pin',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          maxLength: 4,
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 30, 101)),
                          controller: currentPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            // errorText: _validateCurrent ? 'Current password cant be empty' : null,
                            labelText: 'Current Pin',
                          ),
                        ),
                      ),
                      Container(
                        //  decoration: BoxDecoration(),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          maxLength: 4,
                          obscureText: true,
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 30, 101)),
                          controller: NewPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),

                            //errorText: _validateNew ? 'New Password cant be empty' : null,
                            labelText: 'New Pin',
                          ),
                        ),
                      ),
                      Container(
                        //  decoration: BoxDecoration(),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          maxLength: 4,
                          obscureText: true,
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 30, 101)),
                          controller: ConfirmNewPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //errorText: _validateConfirm ? 'Confirm Password cant be empty' : null,
                            labelText: 'Confirm New Pin',
                          ),
                        ),
                      ),
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            textColor: Colors.white,
                            color: Color.fromARGB(255, 86, 30, 101),
                            child: Text('Change Pin'),
                            onPressed: () {
                              resetCode();
                            },
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}
