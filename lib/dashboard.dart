import 'dart:async';
import 'dart:convert';

import 'package:a_connect/QuotesApproval.dart';
import 'package:a_connect/change_password.dart';
import 'package:a_connect/login.dart';
import 'package:a_connect/securityReset.dart';
import 'package:a_connect/securitycode.dart';
import 'package:a_connect/securitycodeGenerate.dart';
import 'package:a_connect/userdetailmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Dummy.dart';
import 'ModelImage.dart';
import 'MyStrings.dart';
import 'Quotes.dart';
import 'constant.dart';
import 'img.dart';

Constants constant = new Constants();

class DashboardScreen extends StatefulWidget {
  String token, baseurl;
  bool pin_exist;

  DashboardScreen({Key key, this.token, this.baseurl}) : super(key: key);

  @override
  _NavigationDrawerDemoState createState() => _NavigationDrawerDemoState();
  final String title = "DashBoard";
}

class _NavigationDrawerDemoState extends State<DashboardScreen> {
  UserDetailModel userDetailModel;
  String username;
  String userRole;
  static const int MAX = 5;
  List<ModelImage> items = Dummy.getModelImage();
  int page = 0;
  Timer timer;
  ModelImage curObj;

  PageController pageController = PageController(
    initialPage: 0,
  );

  Future<UserDetailModel> currentUser() async {
    print("fetching clock");
    var url = Uri.parse('${widget.baseurl}' + Constants.DEANA_USERDETAIL);
    final response = await http.get(
      url,
      headers: {
        "Authorization": '${widget.token}',
        "Content-Type": "application/json"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var userDetail = jsonDecode(response.body);
        userDetailModel = UserDetailModel.fromJson(userDetail);
        username = userDetailModel.firstName + " " + userDetailModel.lastName;
        userRole = userDetailModel.authorities != null &&
                userDetailModel.authorities.length > 0
            ? userDetailModel.authorities[0]
            : null;
        return userDetailModel;
      } else {
        print(response.body);
        throw Exception("Failed to Load Names");
      }
    });

    if (mounted)
      setState(() {
        print("fetched");
      });
  }

  void pinCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pin_exist = prefs.getBool('isLoggedIn');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
    pinCheck();
    curObj = items[0];
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      page = page + 1;
      if (page >= MAX) page = 0;
      pageController.animateToPage(page,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
      print("animateToPage");
      setState(() {
        curObj = items[page];
      });
    });
  }

  String setTitle() {
    String text = '';
    if ((pin_exist == false || pin_exist == null)) {
      return text = 'Set Pin';
    } else {
      return text = 'Reset Pin';
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null && timer.isActive) timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo_alok_main.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    username ?? "",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_to_photos),
              title: Text('Quotes'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Quotes(
                      token: '${widget.token}', baseurl: '${widget.baseurl}'),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text(setTitle()),
              onTap: () {
                if (pin_exist == false || pin_exist == null) {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new SecurityGen(
                              token: '${widget.token}',
                              baseurl: '${widget.baseurl}')));
                } else {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new SecurityReset(
                              token: '${widget.token}',
                              baseurl: '${widget.baseurl}')));
                  /* showDialog(
                      context: context,
                     builder: (_) => AlertDialog(
                        title: Text('Alert'),
                        content: Text('Pin Already Generate',style: TextStyle(color: Colors.red),),
                      )
                  );*/
                }
              },
            ),
            Visibility(
              child: ListTile(
                leading: Icon(Icons.add_to_photos),
                title: Text('Quotes Approval'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => QuotesApproval(
                        token: '${widget.token}', baseurl: '${widget.baseurl}'),
                  ));
                },
              ),
              visible: userRole != null && (userRole == 'ROLE_USER' || userRole == 'ROLE_ADMIN') ? true : false,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[myPopMenu()],
      ),
      body: Image.asset(
        "assets/images/dashboard.jpg",
        fit: BoxFit.fill,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    setState(() {});
  }

  List<Widget> getImagesHeader() {
    List<Widget> lw = [];
    for (ModelImage mi in items) {
      lw.add(Image.asset(Img.get(mi.image), fit: BoxFit.cover));
    }
    return lw;
  }

  Widget buildDots(BuildContext context) {
    Widget widget;

    List<Widget> dots = [];
    for (int i = 0; i < MAX; i++) {
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 9,
        width: 9,
        decoration: BoxDecoration(
            color: page == i ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 1.5)),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }

  Widget myPopMenu() {
    return PopupMenuButton(
        onSelected: (value) async {
          if (value == "Change Password") {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(
                  token: '${widget.token}', baseurl: '${widget.baseurl}'),
            ));
          }
          if (value == "Sign Out") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool status = prefs.getBool('isLoggedIn');
            print(status);
            if (status == false || status == null) {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Login()));
            } else {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Security()));
            }
            /*Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Login(),
            ));*/
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: "Change Password",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.lock_open_outlined),
                      ),
                      Text('Change Password')
                    ],
                  )),
              PopupMenuItem(
                  value: "Sign Out",
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.logout),
                      ),
                      Text('Sign Out')
                    ],
                  )),
            ]);
  }
}
