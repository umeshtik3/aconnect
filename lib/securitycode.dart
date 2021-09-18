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

class Security extends StatefulWidget {
  Security() : super();

  @override
  _Security createState() => _Security();
}

String token, baseurl;
bool pin_exist;

class _Security extends State<Security> {
  List<TextEditingController> controllers = <TextEditingController>[
    new TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  TextEditingController codeOne = new TextEditingController();
  TextEditingController PinCodeController = new TextEditingController();

  //codeTwo,codeThree,codeFour;
  String pin;

  Future<void> main() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = "Bearer" + " " + prefs.get('id_token');
    baseurl = prefs.get('baseurl');
  }

  SecurityCodeGenModel securityCodeGenModel;

  Future<SecurityCodeGenModel> FetchCode() async {
    var url = Uri.parse(baseurl + Constants.DEANA_SECURITYFETCH);
    final response = await http
        .post(url,
            headers: {
              "Authorization": token,
              "Content-Type": "application/json"
            },
            body: jsonEncode({"mobilePin": pin}))
        .then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var d = jsonDecode(response.body);
        securityCodeGenModel = SecurityCodeGenModel.fromJson(d);
        if (securityCodeGenModel.pin_exist == true) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      new DashboardScreen(token: token, baseurl: baseurl)));
        }
        return securityCodeGenModel;
      } else {
        Fluttertoast.showToast(
            msg: "Pin was not correct",
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
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(20, 50, 30, 100),
          padding: EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width,
          child: new Text(
            "Security Pin",
            style: TextStyle(
                fontSize: 34.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          width: MediaQuery.of(context).size.width,
          child: new Text(
            "Enter your 4 digit Security Pin",
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        // Container(
        //   alignment: Alignment.center,
        //     margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
        //
        //     padding: EdgeInsets.all(10),
        //   child:
        //   // TextField(
        //   //   controller: PinCodeController,
        //   //   style:TextStyle(fontSize: 27.0,color: Colors.black),
        //   //   decoration: InputDecoration(
        //   //     isDense: true,
        //   //     contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        //   //     hintText:"Enter Pin",
        //   //     hintStyle: TextStyle(fontSize: 17.0,color: Colors.black),
        //   //     enabledBorder: OutlineInputBorder(
        //   //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //   //       borderSide: BorderSide(color: Colors.grey, width: 1),
        //   //     ),
        //   //     focusedBorder: OutlineInputBorder(
        //   //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //   //       borderSide: BorderSide(color:  Colors.grey, width: 1),
        //   //     ),
        //   //   ),
        //   // )
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: pinBoxs(50.0, controllers, Colors.white, Colors.black, context, false),
        //   ),
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
              isTextObscure: true,
              showFieldAsBox: true,
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

        // Container(
        //   alignment: Alignment.center,
        //   child:Row(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Container(
        //         height: 74.0,
        //         width: 66.0,
        //         child: Card(
        //             color:Colors.white,
        //             child: Padding(
        //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //               child: TextEditorForPhoneVerify(this.codeOne),
        //             )
        //         )
        //     ),
        //     Container(
        //         height: 74.0,
        //         width: 66.0,
        //         child: Card(
        //             color:Colors.white,
        //             child: Padding(
        //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //               child: TextEditorForPhoneVerify(this.codeTwo),
        //             )
        //         )
        //     ),
        //     Container(
        //         height: 74.0,
        //         width: 66.0,
        //         child: Card(
        //             color:Colors.white,
        //             child: Padding(
        //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //               child: TextEditorForPhoneVerify(this.codeThree),
        //             )
        //         )
        //     ),
        //     Container(
        //         height: 74.0,
        //         width: 66.0,
        //         child: Card(
        //             color:Colors.white,
        //             child: Padding(
        //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //               child: TextEditorForPhoneVerify(this.codeFour),
        //             )
        //         )
        //     ),
        //   ],),),
        Container(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.70,
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: RaisedButton(
              color: Color.fromARGB(255, 86, 30, 101),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textColor: Colors.white,
              child: Text(
                'Verify',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              onPressed: () {
                print(PinCodeController.text);
                //  pin=PinCodeController.text;
                //  pin=controllers[0].value.text+controllers[1].value.text+controllers[2].value.text+controllers[3].value.text;
                FetchCode();
              },
            )),
        /*Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width ,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  textColor:Colors.white,
                  child: Text('Change Pin',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                  onPressed: () {
                    setState(() {
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => new SecurityReset(token:token,baseurl:baseurl)));

                    });
                  },
                )),*/
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
        obscureText: true,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            hintText: "*",
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)));
  }
}
