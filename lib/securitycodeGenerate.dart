import 'dart:convert';

import 'package:a_connect/securityCodeGenModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';
import 'dashboard.dart';

class SecurityGen extends StatefulWidget {
  String token, baseurl;

  SecurityGen({Key key, this.token, this.baseurl}) : super(key: key);

  @override
  _SecurityGen createState() => _SecurityGen();
}

class _SecurityGen extends State<SecurityGen> {
  List<TextEditingController> controllers = <TextEditingController>[
    new TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  String pin;
  TextEditingController codeOne = new TextEditingController();
  SecurityCodeGenModel securityCodeGenModel;

  Future<SecurityCodeGenModel> setCode() async {
    var url = Uri.parse('${widget.baseurl}' + Constants.DEANA_SECURITYGEN);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http
        .post(url,
            headers: {
              "Authorization": '${widget.token}',
              "Content-Type": "application/json"
            },
            body: jsonEncode({"mobilePin": pin}))
        .then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var d = jsonDecode(response.body);
        securityCodeGenModel = SecurityCodeGenModel.fromJson(d);
        if (securityCodeGenModel.pin_exist == true) {
          prefs.setBool("isLoggedIn", true);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new DashboardScreen(
                      token: '${widget.token}', baseurl: '${widget.baseurl}')));

          Fluttertoast.showToast(
              msg: "Successfully Set Your Pin",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Successfully not Set Your Pin",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return securityCodeGenModel;
      } else {
        Fluttertoast.showToast(
            msg: "Successfully not Set Your Pin",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        print(response.body);
        throw Exception("Failed to Load Names");
      }
    });

    setState(() {
      print("fetched");
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => DashboardScreen(
                  token: '${widget.token}', baseurl: '${widget.baseurl}'),
            ));
          },
        ),
        backgroundColor: Color.fromARGB(255, 86, 30, 101),
      ),
      body: Column(children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(20, 50, 30, 0),
          padding: EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width,
          child: new Text(
            "Generate Security Code",
            style: TextStyle(
                fontSize: 23.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: MediaQuery.of(context).size.width,
          child: new Text(
            "Enter 4 digit Security Code",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        // Container(
        //     alignment: Alignment.center,
        //     margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
        //
        //     padding: EdgeInsets.all(10),
        //     child:
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: pinBoxs(50.0, controllers, Colors.white, Colors.black, context, false),
        //     ),
        //   // TextField(
        //   //   style: TextStyle(color:Color.fromARGB(255, 86, 30, 101)),
        //   //   controller: codeOne,
        //   //   decoration: InputDecoration(
        //   //     border: OutlineInputBorder(),
        //   //     // errorText: _validateCurrent ? 'Current password cant be empty' : null,
        //   //     labelText: 'Enter Pin',
        //   //   ),
        //   // ),
        // ),
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(0.5),
            child: PinEntryTextField(
              showFieldAsBox: true,
              isTextObscure: true,

              onSubmit: (String pinValue) {
                pin = pinValue;

                // showDialog(
                //     context: context,
                //     builder: (context){
                //       return AlertDialog(
                //         title: Text("Pin"),
                //         content: Text('Pin entered is $pin'),
                //       );
                //     }
                // ); //end showDialog()
              }, // end onSubmit
            ), // end PinEntryTextField()
          ), // end Padding()
        ),

        Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.70,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: RaisedButton(
              color: Color.fromARGB(255, 86, 30, 101),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textColor: Colors.white,
              child: Text(
                'Generate',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              onPressed: () {
                //pin=controllers[0].value.text+controllers[1].value.text+controllers[2].value.text+controllers[3].value.text;
                setCode();
              },
            )),
      ]),
    );
  }
}

class TextEditorForPhoneVerify extends StatelessWidget {
  final TextEditingController code;

  TextEditorForPhoneVerify(this.code);

  @override
  Widget build(BuildContext context) {
    return TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: this.code,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            hintText: "*",
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)));
  }
}
