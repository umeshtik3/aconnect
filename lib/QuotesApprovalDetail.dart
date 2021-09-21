import 'dart:convert';

import 'package:a_connect/QuotesApproval.dart';
import 'package:a_connect/SaveQuotes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'QuotesDetailModel.dart';
import 'constant.dart';

class QuotesApprovalDetail extends StatefulWidget {
  String token, baseurl;
  int id;

  QuotesApprovalDetail({Key key, this.token, this.baseurl, this.id})
      : super(key: key);

  @override
  _QuotesApprovalDetail createState() => _QuotesApprovalDetail();
  final String title = "View Enquiry";
}

TextEditingController mspValueCustController = new TextEditingController();
TextEditingController mspValueCustDdController = new TextEditingController();

class _QuotesApprovalDetail extends State<QuotesApprovalDetail> {
  QuotesDetailModel _quotesDetailModel;
  bool loading = true;
  static var responseSaveData;

  Future<QuotesDetailModel> quotesDetail() async {
    print("fetching quotes Detail");
    var url =
    Uri.parse('${widget.baseurl}' + Constants.DEANA_QUOTESDETAIL + '${widget.id}');
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
        _quotesDetailModel = QuotesDetailModel.fromJson(userDetail);
        mspValueCustController = new TextEditingController(
            text: _quotesDetailModel.mspValueCust.toString());
        mspValueCustDdController = new TextEditingController(
            text: _quotesDetailModel.mspValueCustDd.toString());
        return _quotesDetailModel;
      } else {
        print(response.body);
        throw Exception("Failed to Load Names");
      }
    });

    if (mounted)
      setState(() {
        loading = false;
        print("fetched");
      });
  }

  @override
  void initState() {
    mspValueCustController = new TextEditingController(text: "0.0");
    mspValueCustDdController = new TextEditingController(text: "0.0");
    quotesDetail();
    super.initState();
  }

  Future<void> save() async {
    responseSaveData = jsonEncode({
      "id": _quotesDetailModel.id,
      "acd": _quotesDetailModel.acd,
      "createdDate": "",
      "creditDays": _quotesDetailModel.creditDays,
      "customerCode": _quotesDetailModel.customerCode,
      "customerName": _quotesDetailModel.customerName,
      "customerPinCode": _quotesDetailModel.customerPinCode,
      "delayDays": _quotesDetailModel.delayDays,
      "groupCode": _quotesDetailModel.groupCode,
      "itemCode": _quotesDetailModel.itemCode,
      "itemDescription": _quotesDetailModel.itemDescription,
      "itemId": _quotesDetailModel.itemId,
      "locationCode": _quotesDetailModel.locationCode,
      "locationDescription": _quotesDetailModel.locationDescription,
      "locationPinCode": _quotesDetailModel.locationPinCode,
      "mspValue": _quotesDetailModel.mspValue,
      "mspValueDd":_quotesDetailModel. mspValueDd,
      "mspValueCust": _quotesDetailModel.mspValueCust,
      "mspValueCustDd": _quotesDetailModel.mspValueCustDd,
      "quantity": _quotesDetailModel.quantity,
      "remarks": _quotesDetailModel.remarks,
      "sampleQuantity": _quotesDetailModel.sampleQuantity
    });
    savedata();
  }

  Future<SaveQuotes> savedata() async {
    var url = Uri.parse('${widget.baseurl}' + Constants.DEANA_UPDATEDATA);
    final response = await http
        .post(url,
        headers: {
          "Authorization": '${widget.token}',
          "Content-Type": "application/json"
        },
        body: responseSaveData)
        .then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var d = jsonDecode(response.body);
        SaveQuotes saveQuotes = SaveQuotes.fromJson(d);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              QuotesApproval(
                  token: '${widget.token}', baseurl: '${widget.baseurl}'),
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => QuotesApproval(
                    token: '${widget.token}', baseurl: '${widget.baseurl}'),
              ));
            },
          ),
          backgroundColor: Color.fromARGB(255, 86, 30, 101),
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: loading
              ? CircularProgressIndicator()
              : Column(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                new Text(
                                  "  Quotes# " +
                                      _quotesDetailModel.id.toString(),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: new Text(
                                    "Site",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)),
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    _quotesDetailModel.locationDescription,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: new Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: _quotesDetailModel.locationPinCode ==
                                          null
                                      ? Text(" ")
                                      : Text(
                                          _quotesDetailModel.locationPinCode,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: new Text(
                                    "Customer",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)),
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    _quotesDetailModel.customerName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: new Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: _quotesDetailModel.customerPinCode ==
                                          null
                                      ? Text(" ")
                                      : Text(
                                          _quotesDetailModel.customerPinCode,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: new Text(
                                    "Item",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)),
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    _quotesDetailModel.itemDescription,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
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
                                  child: _quotesDetailModel.itemCode == null
                                      ? Text(" ")
                                      : Text(
                                          _quotesDetailModel.itemCode,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                Container(
                                  width: 150,
                                  child: _quotesDetailModel.groupDescription ==
                                          null
                                      ? Text(" ")
                                      : Text(
                                          _quotesDetailModel.groupDescription,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: new Text(
                                    "Payterm",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)),
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    _quotesDetailModel.payDescription == null
                                        ? ""
                                        : _quotesDetailModel.payDescription,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: new Text(
                                    "Quantity",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)),
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    _quotesDetailModel.quantity == null
                                        ? ""
                                        : _quotesDetailModel.quantity
                                            .toString(),
                                  ),
                                ),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: new Text(
                                    "Sample Quantity",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)),
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    _quotesDetailModel.sampleQuantity == null
                                        ? ""
                                        : _quotesDetailModel.sampleQuantity
                                            .toString(),
                                  ),
                                ),
                              ],
                            ),
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
                        child: Column(children: [
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey)),
                                  child: _quotesDetailModel.mspValue == null
                                      ? Text("0.0")
                                      : Text(
                                          _quotesDetailModel.mspValue
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black),
                                        ),
                                ),
                                Container(
                                  height: 35,
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey)),
                                  child: _quotesDetailModel.mspValueDd == null
                                      ? Text("0.0")
                                      : Text(
                                          _quotesDetailModel.mspValueDd
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: !isSwitched
                                          ? Border.all(color: Colors.black)
                                          : Border.all(color: Colors.white)),
                                  child: TextField(
                                      readOnly: !isSwitched ? false : true,
                                      controller: mspValueCustController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 13.0, color: Colors.black),
                                      onChanged: (data) {
                                        if (data != null) {
                                          _quotesDetailModel.mspValueCust =
                                              double.parse(data);
                                        } else {
                                          _quotesDetailModel.mspValueCust = 0.0;
                                        }
                                      }),
                                ),
                                Container(
                                  height: 35,
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: isSwitched
                                          ? Border.all(color: Colors.black)
                                          : Border.all(color: Colors.white)),
                                  child: TextField(
                                      readOnly: isSwitched ? false : true,
                                      controller: mspValueCustDdController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 13.0, color: Colors.black),
                                      onChanged: (data) {
                                        if (data != null) {
                                          _quotesDetailModel.mspValueCustDd =
                                              double.parse(data);
                                        } else {
                                          _quotesDetailModel.mspValueCustDd =
                                              0.0;
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                          ),
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
                                save();
                              },
                            ),
                          )
                        ]),
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
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: _quotesDetailModel.remarks == null
                                        ? " "
                                        : _quotesDetailModel.remarks,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        child: Container(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: RaisedButton(
                                      color: Color.fromARGB(255, 0, 128, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      textColor: Colors.white,
                                      child: Text(
                                        'Approve',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      onPressed: () {
                                        _showMyApprovalDialog(
                                            _quotesDetailModel.id);
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: RaisedButton(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      textColor: Colors.white,
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      onPressed: () {
                                        _showMyRejectDialog(
                                            _quotesDetailModel.id);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        visible: _quotesDetailModel.flag == 'F' ? true : false),
                  ],
                ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<void> _showMyApprovalDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Dialog'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure to Approve?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                approveAPI(id);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> approveAPI(int id) async {
    var url =
    Uri.parse('${widget.baseurl}' + Constants.DEANA_APPROVE_QUOTES + id.toString());
    final response = await http.get(
      url,
      headers: {
        "Authorization": '${widget.token}',
        "Content-Type": "application/json"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        Fluttertoast.showToast(
            msg: "Approve Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
        Navigator.of(context).pop('REFRESH_DATA');
      } else {
        print(response.body);
        throw Exception("Failed to Load Names");
      }
    });
  }

  Future<void> _showMyRejectDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Dialog'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure to Reject?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                rejectAPI(id);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> rejectAPI(int id) async {
    var url =
    Uri.parse('${widget.baseurl}' + Constants.DEANA_REJECT_QUOTES + id.toString());
    final response = await http.get(
      url,
      headers: {
        "Authorization": '${widget.token}',
        "Content-Type": "application/json"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        Fluttertoast.showToast(
            msg: "Reject Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
        Navigator.of(context).pop('REFRESH_DATA');
      } else {
        print(response.body);
        throw Exception("Failed to Load Names");
      }
    });
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

bool isSwitched = false;

class SwitchClass extends State {
  // var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        if (this.mounted) {
          setState(() {});
        }

        //  textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        if (this.mounted) {
          setState(() {});
        }
        ;

        //  textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Transform.scale(
          scale: 1,
          child: Switch(
            // onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: Colors.white,
            activeTrackColor: Color.fromARGB(255, 86, 30, 101),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Color.fromARGB(255, 86, 30, 101),
          )),
      //  Text('$textValue', style: TextStyle(fontSize: 20),)
    ]);
  }
}
