import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'UserModel.dart';
import 'constant.dart';
import 'dashboard.dart';

Constants constant = new Constants();
String baseurl;
String Username = "";

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class Login extends StatefulWidget {
  Login() : super();

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _validateUser = false;
  bool _validatePassword = false;
  String token;
  String randomKey;
  bool _rememberMeFlag = false;
  UserModel userModel;

  login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    randomKey = prefs.getString('uniqueRandomKey');
    if (randomKey != null) {
    } else {
      randomKey = getRandomString(15);
      prefs.setString('uniqueRandomKey', randomKey);
    }
    try {
      final msg = jsonEncode({
        "username": nameController.text,
        "password": passwordController.text,
        "deviceType": "ANDROID",
        "imei": randomKey,
        "mobileMe": true
      });
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = new IOClient(ioc);
      Response response = await http
          .post(Uri.parse(baseurl + Constants.DEANA_LOGIN_URL),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "charset": "utf-8"
              },
              body: msg)
          .timeout(const Duration(seconds: 60));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", nameController.text);

      var jsonResponse = null;
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        var data = Map<String, dynamic>.from(jsonResponse);
        userModel = UserModel.fromJson(data);
        prefs.setString('id_token', userModel.idToken);
        // prefs.setBool("isLoggedIn", true);
        prefs.setString("baseurl", baseurl);

        prefs.setBool("pin_exist", userModel.pin_exist);
        token = "Bearer" + " " + prefs.get('id_token');
        print(token);
        print(response.body);
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    new DashboardScreen(token: token, baseurl: baseurl)));
        Fluttertoast.showToast(
            msg: "Login successfully", gravity: ToastGravity.BOTTOM);
      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('ERROR'),
                  content: Text(
                    'Invalid credentials...Try Again!!',
                    style: TextStyle(color: Colors.red),
                  ),
                ));
      }
    } on SocketException catch (_) {
      throw (showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('ERROR'),
                content: Text(
                  'No Internet Connection',
                  style: TextStyle(color: Colors.red),
                ),
              )));
    }
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Username = prefs.getString('username');
    if (Username == null || Username == "") {
      Username = "";
    } else {
      nameController = TextEditingController(text: Username);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    constant.setString("http://aconnect.alokindustries.com/");
    baseurl = constant.getString();
    navigateUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Color.fromARGB(255, 86, 30, 101),
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => IPChange(),
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Image.asset(
                            'assets/images/logo_alok.png',
                            fit: BoxFit.contain,
                            width: 90,
                            height: 90,
                          )),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            'Welcome',
                            style: TextStyle(
                                color: Color.fromARGB(255, 86, 30, 101),
                                fontWeight: FontWeight.w500,
                                fontSize: 25),
                          )),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Text(
                            'Sign in to continue',
                            style: TextStyle(
                                color: Color.fromARGB(255, 86, 30, 101),
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          )),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 30, 101)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: Username.toString(),
                            errorText:
                                _validateUser ? 'value cant be empty' : null,
                            labelText: 'User Name',
                          ),
                        ),
                      ),
                      Container(
                        //  decoration: BoxDecoration(),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),

                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 30, 101)),
                          decoration: InputDecoration(
                            errorText: _validatePassword
                                ? 'value cant be empty'
                                : null,
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      /*Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Checkbox(
                                    checkColor:  Colors.white,
                                    activeColor:Color.fromARGB(255, 86, 30, 101),
                                    value:this._rememberMeFlag,
                                    onChanged: (bool value) {
                                      setState(() {
                                        this._rememberMeFlag = value;
                                      });
                                    },
                                  ),
                                  new Text(
                                    "Remember Me",
                                    style:TextStyle(color: Color.fromARGB(255, 86, 30, 101),fontSize: 13),
                                  ),
                                ])),
                            // new Text(
                            //   "Forgot password ?",
                            //    style:  TextStyle(color: Color.fromARGB(255, 86, 30, 101),fontSize: 13),
                            //
                            // )
                          ],
                        ),),*/
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: RaisedButton(
                            color: Color.fromARGB(255, 86, 30, 101),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            textColor: Colors.white,
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              if (baseurl == null || baseurl == "") {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('ERROR'),
                                          content: Text(
                                            'Click on setting button and check IP Address',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ));
                              } else {
                                setState(() {
                                  nameController.text.isEmpty
                                      ? _validateUser = true
                                      : _validateUser = false;
                                  passwordController.text.isEmpty
                                      ? _validatePassword = true
                                      : _validatePassword = false;
                                });
                                //verify that all are fine
                                if (_validateUser || _validatePassword) {
                                } else {
                                  login();
                                }
                              }
                            },
                          )),
                      Container(
                          child: Row(
                        children: <Widget>[
                          Text(
                            'Powered By',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          Image.asset(
                            "assets/images/deanalogo.png",
                            fit: BoxFit.contain,
                            height: 70,
                            width: 90,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      )),
                    ],
                  ))))
    ]);
  }
}

TextEditingController IPAddressController =
    TextEditingController(text: "http://aconnect.alokindustries.com/");

class IPChange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('IP Address'),
      content: TextField(
        controller: IPAddressController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'IP Address',
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Ok"),
          onPressed: () {
            Constants constant = new Constants();
            constant.setString(IPAddressController.text);
            baseurl = constant.getString();
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: baseurl, gravity: ToastGravity.BOTTOM);
          },
        ),
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
