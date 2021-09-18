import 'dart:async';
import 'dart:convert';

import 'package:a_connect/customer_name_model.dart';
import 'package:a_connect/item_model.dart';
import 'package:a_connect/pay_term_model.dart';
import 'package:a_connect/payterm_master_greaterModel.dart';
import 'package:a_connect/saveData.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Quotes.dart';
import 'SaveQuotes.dart';
import 'User.dart';
import 'constant.dart';
import 'deliveryValueModel.dart';

Constants constant = new Constants();
bool ismsp = true;

int _counter = 0;
bool ismspDd = false;
bool isSwitched = false;
FocusNode myFocusNode, myFocusNode2, myFocusNodeQuantity, myfocusnodeHiden;

class EnqiuryPage extends StatefulWidget {
  String token, baseurl;

  EnqiuryPage({Key key, this.token, this.baseurl}) : super(key: key);

  @override
  _EnqiuryPage createState() => _EnqiuryPage();
  final String title = "New Enquiry";
}

TextEditingController mspValueCustController = new TextEditingController();
TextEditingController mspValueCustDdController = new TextEditingController();

class _EnqiuryPage extends State<EnqiuryPage> {
  TextEditingController hiddendata = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  TextEditingController sameplequantity = new TextEditingController();
  TextEditingController remarkController = new TextEditingController();
  TextEditingController customerDetail = new TextEditingController();
  TextEditingController PinCodeController = new TextEditingController();

  AutoCompleteTextField searchTextField;
  AutoCompleteTextField searchTextField1;
  AutoCompleteTextField searchTextField2;
  AutoCompleteTextField searchTextField3;
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<customerNameModel>> key1 =
      new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<ItemModel>> key2 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<payTermModel>> key3 = new GlobalKey();
  String customerNameText;

  static List<User> users = new List<User>();
  static List<customerNameModel> customer = new List<customerNameModel>();
  static List<ItemModel> item = new List<ItemModel>();
  static List<payTermModel> payTerm = new List<payTermModel>();

  bool loading = true;
  bool loading1 = true;
  bool loading2 = true;
  bool loading3 = true;
  static var registerBody, responseSaveData;

  bool paytermText = true;
  bool siteTextFieldVisibilty = false;
  bool siteTextVisibilty = true;
  bool itemTextFieldVisibilty = false;
  bool itemTextVisibilty = true;
  bool customerTextFieldVisibilty = false;
  bool customerTextVisibilty = true;
  bool customerpicodeVisibility = false;
  bool paytermVisibility = false;
  bool customerDetailDeatilVisiblity = false;

  bool _customerenable = false;
  bool itemenable = false;
  String itemId;
  String locationPinCode,
      locationDescription,
      locationCode,
      customerCode,
      customerName,
      customerPinCode,
      itemDescription,
      itemCode,
      groupCode,
      groupDecription,
      payCode,
      paytermDecription,
      companyCode,
      companyDescription;
  double mspValue,
      mspValueCust,
      mspValueCustDd,
      mspValueDd,
      pricekg,
      acd,
      creditDays,
      delayDays;
  double payValue, delaycharges;
  List<User> usersDEmo = [];
  Payterm_masrer_greater payterMaster;

  void getUsers() async {
    try {
      final response = await http
          .get(Uri.parse('${widget.baseurl}' + Constants.DEANA_SITE), headers: {
        "Authorization": '${widget.token}',
        "Content-Type": "application/json"
      });
      if (response.statusCode == 200) {
        // if(response.body[0] != "<"){
        print(response.body);
        users = loadUsers(response.body);
        for (int i = 0; i < users.length; i++) {
          site.add(users[i]);
        }
        //}
        print('Users: ${users.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  Future<void> getCustomer(String key) async {
    try {
      if (key != null) {
        customer = new List<customerNameModel>();
        if (searchTextField1.suggestions != null && searchTextField1.suggestions.length>0) {
          for (customerNameModel cust in searchTextField1.suggestions) {
            searchTextField1.removeSuggestion(cust);
          }
        }
        final response = await http.get(
            Uri.parse('${widget.baseurl}' + Constants.DEANA_CUSTOMER_NAME + key),
            headers: {
              "Authorization": '${widget.token}',
              "Content-Type": "application/json"
            });
        if (response.statusCode == 200) {
          customer = loadCustomer(response.body);
          for (customerNameModel cust in customer) {
            searchTextField1.addSuggestion(cust);
          }
          print('Customer: ${customer.length}');
          setState(() {
            loading1 = false;
          });
        } else {
          print("Error getting customers.");
        }
      }
    } catch (e) {
      print("Error getting customers.");
    }
  }

  void getItem(String companyCode, String key) async {
    try {
      if (companyCode != null &&
          companyCode.length > 0 &&
          key != null &&
          key.length > 0) {
        item = new List<ItemModel>();
        if (searchTextField2.suggestions != null && searchTextField2.suggestions.length>0) {
          for (ItemModel cust in searchTextField2.suggestions) {
            searchTextField2.removeSuggestion(cust);
          }
        }
        final response = await http.get(
            Uri.parse('${widget.baseurl}' +
                Constants.DEANA_ITEM +
                companyCode +
                "/" +
                key),
            headers: {
              "Authorization": '${widget.token}',
              "Content-Type": "application/json"
            });
        if (response.statusCode == 200) {
          item = loadItem(response.body);
          for (ItemModel itm in item) {
            searchTextField2.addSuggestion(itm);
          }
          print('Item: ${item.length}');
          setState(() {
            loading2 = false;
          });
        } else {
          print("Error getting users.");
        }
      } else {
        item = new List<ItemModel>();
        if (searchTextField2.suggestions != null && searchTextField2.suggestions.length>0) {
          for (ItemModel cust in searchTextField2.suggestions) {
            searchTextField2.removeSuggestion(cust);
          }
        }
        final response = await http.get(
            Uri.parse('${widget.baseurl}' + Constants.DEANA_ITEM_OLD + key),
            headers: {
              "Authorization": '${widget.token}',
              "Content-Type": "application/json"
            });
        if (response.statusCode == 200) {
          item = loadItem(response.body);
          for (ItemModel itm in item) {
            searchTextField2.addSuggestion(itm);
          }
          print('Item: ${item.length}');
          setState(() {
            loading2 = false;
          });
        } else {
          print("Error getting users.");
        }
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  void getPayterm() async {
    try {
      final response = await http
          .get(Uri.parse('${widget.baseurl}' + Constants.DEANA_PAYTEM), headers: {
        "Authorization": '${widget.token}',
        "Content-Type": "application/json"
      });
      if (response.statusCode == 200) {
        payTerm = loadPayterm(response.body);
        for (int i = 0; i < payTerm.length; i++) {
          payterm.add(payTerm[i]);
        }
        print('Item: ${payTerm.length}');
        setState(() {
          loading3 = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  Future<deliveryValueModel> delivery() async {
    var url = Uri.parse('${widget.baseurl}' + Constants.DEANA_DELIVERYAPI);
    final response = await http
        .post(url,
            headers: {
              "Authorization": '${widget.token}',
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "code": customerPinCode,
              "locationCode": locationCode,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var d = jsonDecode(response.body);
        deliveryValueModel deliveryValue = deliveryValueModel.fromJson(d);
        pricekg = deliveryValue.pricekg;
        return deliveryValue;
      } else {
        print(response.body);
        throw Exception("Failed to Load Names");
      }
    });

    setState(() {
      print("fetched");
    });
  }

  Future<SaveQuotes> savedata() async {
    var url = Uri.parse('${widget.baseurl}' + Constants.DEANA_SAVEDATA);
    final response = await http
        .post(url,
            headers: {
              "Authorization": '${widget.token}',
              "Content-Type": "application/json"
            },
            body: responseSaveData)
        .then((response) {
      if (response.statusCode == 201) {
        print("connection ok");
        var d = jsonDecode(response.body);
        SaveQuotes saveQuotes = SaveQuotes.fromJson(d);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              Quotes(token: '${widget.token}', baseurl: '${widget.baseurl}'),
        ));
        print("successfully save data");
        Fluttertoast.showToast(
            msg: "successfully save data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        return saveQuotes;
      } else {
        print(response.body);
        if (response.headers.keys.contains('x-aconnectapp-error')) {
          print(response.headers['x-aconnectapp-error']);
          Fluttertoast.showToast(
              msg: response.headers['x-aconnectapp-error'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        throw Exception("Failed to Load Names");
      }
    });

    setState(() {
      print("fetched");
    });
  }

  Future<saveData> mapping() async {
    print("fetching saveQutoes");
    var url = Uri.parse('${widget.baseurl}' + Constants.DEANA_EXEC);
    final response = await http
        .post(url,
            headers: {
              "Authorization": '${widget.token}',
              "Content-Type": "application/json"
            },
            body: registerBody)
        .then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var d = jsonDecode(response.body);
        saveData savedata = saveData.fromJson(d);
        mspValueCust = savedata.agItemMasterRmcDetailsBean.mspValueCust;
        mspValueCustDd = savedata.agItemMasterRmcDetailsBean.mspValueCustDd;
        mspValueDd = savedata.agItemMasterRmcDetailsBean.lastPriceDelivery;
        mspValue = savedata.agItemMasterRmcDetailsBean.lastPrice;
        mspValueCustController =
            new TextEditingController(text: mspValueCust.toString());
        mspValueCustDdController =
            new TextEditingController(text: mspValueCustDd.toString());

        // itemId=savedata.id;
        return savedata;
      } else {
        print(response.body);
        if (response.headers.keys.contains('x-aconnectapp-error')) {
          print(response.headers['x-aconnectapp-error']);
          Fluttertoast.showToast(
              msg: response.headers['x-aconnectapp-error'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        throw Exception("Failed to Load Names");
      }
    });

    setState(() {
      print("fetched");
    });
  }

  Future<Payterm_masrer_greater> payterm_master_greater() async {
    var url = Uri.parse('${widget.baseurl}' + Constants.DEANA_PAYTEM_MASTER_GREATER);
    final response = await http.get(
      url,
      headers: {
        "Authorization": '${widget.token}',
        "Content-Type": "application/json"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var payterMasterdata = jsonDecode(response.body);
        payterMaster = Payterm_masrer_greater.fromJson(payterMasterdata);
        delaycharges = payterMaster.percentage;
        return payterMaster;
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

  static List<User> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  static List<customerNameModel> loadCustomer(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed
        .map<customerNameModel>((json) => customerNameModel.fromJson(json))
        .toList();
  }

  static List<ItemModel> loadItem(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<ItemModel>((json) => ItemModel.fromJson(json)).toList();
  }

  static List<payTermModel> loadPayterm(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed
        .map<payTermModel>((json) => payTermModel.fromJson(json))
        .toList();
  }

  @override
  void initState() {
    getUsers();
    getPayterm();
    getCustomer("");
    getItem("", "");
    loading = false;
    loading1 = false;
    loading2 = false;
    loading3 = false;

    // if(searchTextField.textField.controller.text==null) {
    //   searchTextField1.textField.enabled == true;
    // }
    // else{
    //   searchTextField1.textField.enabled == false;
    // }
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNodeQuantity = FocusNode();
    myfocusnodeHiden = FocusNode();
    mspValueCustController = new TextEditingController(text: "0.0");
    mspValueCustDdController = new TextEditingController(text: "0.0");
  }

  yourFunction() {
    print("build completed");
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    myFocusNode2.dispose();
    myFocusNodeQuantity.dispose();
    myfocusnodeHiden.dispose();
    super.dispose();
  }

  List<payTermModel> payterm = new List();

  List<User> site = new List();
  payTermModel paytermdata;
  User sitedata;

  List<DropdownMenuItem<User>> _dropDownItem() {
    return site
        .map((User value) => DropdownMenuItem(
              value: value,
              child: Text(value.locationDescription,
                  style: TextStyle(fontSize: 13.0, color: Colors.black)),
            ))
        .toList();
  }

  List<DropdownMenuItem<payTermModel>> _dropDownItem1() {
    return payterm
        .map((payTermModel value) => DropdownMenuItem(
              value: value,
              child: Text(value.payDescription,
                  style: TextStyle(fontSize: 13.0, color: Colors.black)),
            ))
        .toList();
  }

  Widget row(User user) {
    return users.length == null
        ? Text("data not found")
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  user.locationDescription,
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          );
  }

  Widget row1(customerNameModel user) {
    return customer.length == null
        ? Text("data not found")
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  user.customerName,
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                ),
              )
            ],
          );
  }

  Widget row2(ItemModel user) {
    return item.length == null
        ? Text("data not found")
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  user.itemDescription,
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          );
  }

  Widget row3(payTermModel user) {
    return item.length == null
        ? Text("data not found")
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  user.payDescription,
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          );
  }

  bool _rememberMeFlag = false;

  Widget getTextField() {
    if (customerNameText != null &&
        customerNameText == "NEW DOMESTIC CUSTOMER") {
      customerpicodeVisibility = true;
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey)),
        height: 35,
        width: MediaQuery.of(context).size.width * 0.65,
        child: customerNameText == null
            ? Text("Select Customer")
            : Text(
                customerNameText,
                style: TextStyle(color: Colors.black, fontSize: 13.0),
              ),
      );
    } else {
      customerpicodeVisibility = false;
      if (_customerenable) {
        return Container(
          height: 35,
          width: MediaQuery.of(context).size.width * 0.65,
          child: loading1
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : searchTextField1 = AutoCompleteTextField<customerNameModel>(
                  key: key1,
                  clearOnSubmit: false,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(),
                    hintText: "Search Customer",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                    ),
                  ),
                  //  onFocusChanged: (hasFocus) {},
                  suggestions: customer,
                  suggestionsAmount: 50,
                  style: TextStyle(color: Colors.black, fontSize: 13.0),
                  itemFilter: (item, query) {
                    return item.customerName
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  },
                  textChanged: (item) {
                    if (item.length > 2) {
                      getCustomer(item);
                    }
                  },
                  //  textInputAction: TextInputAction.done,
                  itemSorter: (a, b) {
                    return a.customerName.compareTo(b.customerName);
                  },
                  itemSubmitted: (item) {
                    setState(() {
                      searchTextField1.textField.controller.text = item.customerName;
                      customerPinCode = item.pincode;
                      creditDays = item.creditDays;
                      acd = item.acd;
                      customerName = item.customerName;
                      customerCode = item.customerCode;
                      delivery();
                      if (searchTextField1.textField.controller.text == null) {
                        itemTextFieldVisibilty = false;
                        itemTextVisibilty = true;
                      } else {
                        itemTextFieldVisibilty = true;
                        itemTextVisibilty = false;
                      }

                      delayDays = acd - creditDays;
                      print("acd");
                      print(acd);
                      if (delayDays > 0) {
                        payterm_master_greater();
                      } else {
                        delayDays = 0;
                      }
                      if (acd == 0) {
                        paytermText = false;
                        paytermVisibility = true;
                      } else {
                        paytermVisibility = false;
                        paytermText = true;
                      }
                    });
                  },
                  itemBuilder: (context, item) {
                    // ui for the autocompelete row
                    return row1(item);
                  },
                ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey)),
          height: 35,
          width: MediaQuery.of(context).size.width * 0.65,
          child: customerNameText == null
              ? Text("Select Customer")
              : Text(
                  customerNameText,
                  style: TextStyle(color: Colors.black, fontSize: 13.0),
                ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 86, 30, 101),
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Quotes(
                          token: '${widget.token}',
                          baseurl: '${widget.baseurl}'),
                    ),
                    (e) => false);
              }),
          backgroundColor: Color.fromARGB(255, 86, 30, 101),
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Color.fromARGB(255, 86, 30, 101),
                            value: this._rememberMeFlag,
                            onChanged: (bool value) {
                              setState(() {
                                this._rememberMeFlag = value;
                                if (_rememberMeFlag == true) {
                                  paytermText = false;
                                  paytermVisibility = true;
                                  customerDetailDeatilVisiblity = true;
                                  customerNameText = "NEW DOMESTIC CUSTOMER";
                                  customerCode = "DOMEST";
                                  customerName = "NEW DOMESTIC CUSTOMER";
                                  acd = 0;
                                } else {
                                  paytermVisibility = false;
                                  paytermText = true;
                                  customerDetailDeatilVisiblity = false;
                                  customerNameText = "Select Customer";
                                }
                              });
                            },
                          ),
                          new Text(
                            "New Domestic Customer",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "Site",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: loading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Container(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    //  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    padding: EdgeInsets.all(5),
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(
                                          5), //background color of box
                                    ),
                                    child: DropdownButton(
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black),
                                      underline:
                                          Container(color: Colors.transparent),
                                      isExpanded: true,
                                      value: sitedata,
                                      items: _dropDownItem(),
                                      onChanged: (User value) {
                                        sitedata = value;
                                        setState(() {
                                          this._customerenable = true;
                                          //searchTextField.textField.controller.text = sitedata.locationDescription;
                                          locationPinCode = sitedata.pincode;
                                          locationDescription =
                                              sitedata.locationDescription;
                                          locationCode = sitedata.locationCode;
                                          companyDescription = sitedata
                                              .agCompanyMaster
                                              .companyDescription;
                                          companyCode = sitedata
                                              .agCompanyMaster.companyCode;
                                          // if( searchTextField.textField.controller.text ==null){
                                          //   customerTextFieldVisibilty=false;
                                          //   customerTextVisibilty=true;
                                          // }
                                          // else{
                                          //   customerTextFieldVisibilty=true;
                                          //   customerTextVisibilty=false;
                                          // }
                                        });
                                      },
                                      hint: Text(
                                        "Select Site",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: locationPinCode == null
                                ? Text(" ")
                                : Text(
                                    locationPinCode,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "Customer",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          getTextField(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Visibility(
                            visible: !customerpicodeVisibility,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: customerPinCode == null
                                  ? Text(" ")
                                  : Text(
                                      customerPinCode,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                          Visibility(
                            visible: customerpicodeVisibility,
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: TextField(
                                  controller: PinCodeController,
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.black),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    hintText: "Pincode",
                                    hintStyle: TextStyle(
                                        fontSize: 13.0, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "Item",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Visibility(
                            visible: itemTextFieldVisibilty,
                            child: Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: loading2
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : searchTextField2 =
                                      AutoCompleteTextField<ItemModel>(
                                      key: key2,
                                      clearOnSubmit: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        border: OutlineInputBorder(),
                                        hintText: "Search Item",
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        //contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                                      ),
                                      //  onFocusChanged: (hasFocus) {},
                                      suggestions: item,
                                      suggestionsAmount: 50,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13.0),
                                      itemFilter: (item, query) {
                                        return item.itemDescription
                                            .toLowerCase()
                                            .contains(query.toLowerCase());
                                      },
                                      textChanged: (item) {
                                        if (item.length > 2) {
                                          getItem(companyCode, item);
                                        }
                                      },
                                      //  textInputAction: TextInputAction.done,
                                      itemSorter: (a, b) {
                                        return a.itemDescription
                                            .compareTo(b.itemDescription);
                                      },
                                      itemSubmitted: (item) {
                                        setState(() {
                                          searchTextField2.textField.controller
                                              .text = item.itemDescription;
                                          itemCode = item.itemCode;
                                          itemDescription =
                                              item.itemDescription;
                                          groupCode =
                                              item.agItemGroupMaster.groupCode;
                                          groupDecription = item
                                              .agItemGroupMaster
                                              .groupDescription;
                                          itemId = item.id.toString();
                                          print("groupDecription");
                                          print(groupDecription);
                                        });
                                      },
                                      itemBuilder: (context, item) {
                                        // ui for the autocompelete row
                                        return row2(item);
                                      },
                                    ),
                            ),
                          ),
                          Visibility(
                            visible: itemTextVisibilty,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)),
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                "Select Item",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 50,
                            child: itemCode == null
                                ? Text(" ")
                                : Text(
                                    itemCode,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          Container(
                            width: 150,
                            child: groupDecription == null
                                ? Text(" ")
                                : Text(
                                    groupDecription,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "Payterm",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Visibility(
                            visible: paytermVisibility,
                            child: Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: loading3
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Container(
                                      height: 35,
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      //  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      padding: EdgeInsets.all(5),
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(
                                            5), //background color of box
                                      ),
                                      child: DropdownButton(
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black),
                                        underline: Container(
                                            color: Colors.transparent),
                                        isExpanded: true,
                                        value: paytermdata,
                                        items: _dropDownItem1(),
                                        onChanged: (payTermModel value) {
                                          paytermdata = value;
                                          setState(() {
                                            //   searchTextField3.textField.controller.text = item.payDescription;
                                            payCode = paytermdata.payCode;
                                            paytermDecription =
                                                paytermdata.payDescription;
                                            payValue = paytermdata.percentage;
                                            delaycharges =
                                                paytermdata.percentage;
                                          });
                                        },
                                        hint: Text(
                                          "Select PayTerm",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Visibility(
                            visible: paytermText,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)),
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                "Select Pay Term",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "Quantity",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: TextField(
                                focusNode: myFocusNodeQuantity,
                                keyboardType: TextInputType.number,
                                controller: quantity == null
                                    ? Text("Enter Quantity")
                                    : quantity,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  fillColor: Colors.white70,
                                  disabledBorder: OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: new Text(
                              "Sample Quantity",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: sameplequantity == null
                                    ? Text("Enter Sample Quantity")
                                    : sameplequantity,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  fillColor: Colors.white70,
                                  disabledBorder: OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: RaisedButton(
                          color: Color.fromARGB(255, 86, 30, 101),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          textColor: Colors.white,
                          child: Text(
                            'Fetch Price',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          onPressed: () {
                            if (quantity.text.isEmpty) {
                              quantity.text = "";
                            } else {
                              registerBody = jsonEncode({
                                "code": groupCode.toString(),
                                "customerCode": customerCode.toString(),
                                "ddCharges": pricekg.toString(),
                                "deliveryType": isSwitched,
                                "description": itemId.toString(),
                                "locationCode": locationCode,
                                "quantity": quantity.text
                              });
                              mapping();
                            }
                          },
                        )
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 86, 30, 101),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: new Text(
                                "",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: new Text(
                                "EX. FACTORY",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: new Text(
                                "DOOR DELIVERY",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: new Text(
                                "Company Price",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 35,
                              padding: const EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey)),
                              child: mspValue == null
                                  ? Text("0.0")
                                  : Text(
                                      mspValue.toString(),
                                      style: TextStyle(
                                          fontSize: 13.0, color: Colors.black),
                                    ),
                            ),
                            Container(
                              height: 35,
                              padding: const EdgeInsets.all(8.0),
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey)),
                              child: mspValueDd == null
                                  ? Text("0.0")
                                  : Text(
                                      mspValueDd.toString(),
                                      style: TextStyle(
                                          fontSize: 13.0, color: Colors.black),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: new Text(
                                "Customer Price",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 35,
                              padding: const EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: !isSwitched
                                      ? Border.all(color: Colors.black)
                                      : Border.all(color: Colors.white)),
                              child: TextField(
                                controller: mspValueCustController,
                                keyboardType: TextInputType.number,
                                readOnly: !isSwitched ? false : true,
                                focusNode: myFocusNode,
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                                onChanged: (data) {
                                  if(data != null) {
                                    mspValueCust = double.parse(data);
                                  } else {
                                    mspValueCust = 0.0;
                                  }
                                },
                              ),
                            ),
                            Container(
                              height: 35,
                              padding: const EdgeInsets.all(8.0),
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: isSwitched
                                      ? Border.all(color: Colors.black)
                                      : Border.all(color: Colors.white)),
                              child: TextField(
                                controller: mspValueCustDdController,
                                readOnly: isSwitched ? false : true,
                                focusNode: myFocusNode2,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                                  onChanged: (data) {
                                    if(data != null) {
                                      mspValueCustDd = double.parse(data);
                                    } else {
                                      mspValueCustDd = 0.0;
                                    }
                                  }
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: new Text(
                                "Preference",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: new Text(
                                "Ex.Factory",
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              ),
                            ),
                            Container(
                              child: SwitchScreen(),
                            ),
                            Container(
                              child: new Text(
                                " Door Delivery.",
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: new Text(
                            "Remark",
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: TextField(
                              controller: remarkController,
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
    Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 10, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.94,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: RaisedButton(
                            color: Color.fromARGB(255, 86, 30, 101),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            textColor: Colors.white,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              if (locationDescription == null ||
                                  customerName == null ||
                                  itemDescription == null ||
                                  quantity.text == "" ||
                                  quantity.text == null) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Compulsory Field'),
                                          content: Text(
                                            "Site, Customer, Item and Quantity fields are mandatory. ",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ));
                              } else if (mspValue == null ||
                                  mspValue == 0 ||
                                  mspValueDd == null ||
                                  mspValueDd == 0 ||
                                  mspValueCust == null ||
                                  mspValueCust == 0 ||
                                  mspValueCustDd == null ||
                                  mspValueCustDd == 0) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Prices Error'),
                                          content: Text(
                                            'Prices are not available. Please contact Finance Team.',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ));
                              } else {
                                if (acd == 0) {
                                  responseSaveData = jsonEncode({
                                    "acd": acd,
                                    "companyCode": companyCode,
                                    "createdDate": "",
                                    "creditDays": creditDays,
                                    "customerCode": customerCode,
                                    "customerName": customerName,
                                    "customerPinCode": customerPinCode,
                                    "ddCharges": pricekg,
                                    "delaycharges": delaycharges,
                                    "delayDays": delayDays,
                                    "deliveryType": isSwitched,
                                    "firstTimeApplicable": false,
                                    "groupCode": groupCode,
                                    "groupDescription": groupDecription,
                                    "itemCode": itemCode,
                                    "itemDescription": itemDescription,
                                    "itemId": itemId,
                                    "locationCode": locationCode,
                                    "locationDescription": locationDescription,
                                    "locationPinCode": locationPinCode,
                                    "mspValue": mspValue,
                                    "mspValueDd": mspValueDd,
                                    "mspValueCust": mspValueCust,
                                    "mspValueCustDd": mspValueCustDd,
                                    "quantity": quantity.text,
                                    "remarks": remarkController.text,
                                    "sampleQuantity": sameplequantity.text
                                  });
                                  savedata();
                                } else {
                                  responseSaveData = jsonEncode({
                                    "acd": acd != null ? acd : 0,
                                    "companyCode": companyCode,
                                    "createdDate": "",
                                    "creditDays":
                                        creditDays != null ? creditDays : 0,
                                    "customerCode": customerCode,
                                    "customerName": customerName,
                                    "customerPinCode": customerPinCode,
                                    "ddCharges": pricekg != null ? pricekg : 0,
                                    "delaycharges":
                                        delaycharges != null ? delaycharges : 0,
                                    "delayDays":
                                        delayDays != null ? delayDays : 0,
                                    "deliveryType": isSwitched,
                                    "firstTimeApplicable": false,
                                    "groupCode": groupCode,
                                    "groupDescription": groupDecription,
                                    "itemCode": itemCode,
                                    "itemDescription": itemDescription,
                                    "itemId": itemId,
                                    "locationCode": locationCode,
                                    "locationDescription": locationDescription,
                                    "locationPinCode": locationPinCode,
                                    "mspValue": mspValue,
                                    "mspValueDd": mspValueDd,
                                    "mspValueCust": mspValueCust,
                                    "mspValueCustDd": mspValueCustDd,
                                    "payCode": payCode,
                                    "payDescription": paytermDecription,
                                    "payValue": payValue,
                                    "quantity": quantity.text,
                                    "remarks": remarkController.text,
                                    "sampleQuantity": sameplequantity.text
                                  });
                                  savedata();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirm Exit?',
                style: new TextStyle(color: Colors.black, fontSize: 20.0)),
            content: new Text(
                'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  // this line exits the app.
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: new Text('Yes', style: new TextStyle(fontSize: 18.0)),
              ),
              new FlatButton(
                onPressed: () => Navigator.pop(context),
                // this line dismisses the dialog
                child: new Text('No', style: new TextStyle(fontSize: 18.0)),
              )
            ],
          ),
        ) ??
        false;
  }
}

class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  // var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    print(value);
    Future.delayed(const Duration(microseconds: 1000), () {
      myFocusNodeQuantity.requestFocus();
    });
    setState(() {
      isSwitched = !isSwitched;
      if (isSwitched) {
        ismsp = false;
        ismspDd = true;
        myFocusNode2.requestFocus();
      } else {
        ismsp = true;
        ismspDd = false;
        myFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Transform.scale(
          scale: 1,
          child: Switch(
            onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: Colors.white,
            activeTrackColor: Color.fromARGB(255, 86, 30, 101),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Color.fromARGB(255, 86, 30, 101),
          )),
      //  Text('$textValue', style: TextStyle(fontSize: 20),)
    ]);
  }

// void changeSwitchState(bool state) async {
//   setState(() {
//     isSwitched = !isSwitched;
//   });
//   await Future.delayed(Duration(milliseconds: 100));
//   if (isSwitched) {
//     myFocusNode.requestFocus();
//   } else {
//     myFocusNode.requestFocus();
//   }
// }

}
