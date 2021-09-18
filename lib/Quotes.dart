import 'dart:convert';
import 'package:a_connect/Forwardmodel.dart';
import 'package:a_connect/PagingProductRepository.dart';
import 'package:a_connect/pagingProduct.dart';
import 'package:a_connect/paging_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'QuotesDetail.dart';
import 'constant.dart';
import 'dashboard.dart';
import 'enquiryPage.dart';


class Quotes extends StatefulWidget {
  String token, baseurl;

  Quotes({Key key, this.token, this.baseurl}) : super(key: key);

  @override
  QuotesData createState() => QuotesData();
  final String title = "Quotes";
}

List<PagingProduct> _paginatedProductData = [];
List<PagingProduct> _products = [];

class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate
    with DataPagerDelegate, ChangeNotifier {
  CustomSliverChildBuilderDelegate(builder) : super(builder);

  @override
  int get childCount => _paginatedProductData.length;

  @override
  int get rowCount => _products.length;
  var rowsPerPage = 10;
  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (endIndex > _products.length) {
      endIndex = _products.length;
    }
    // await Future.delayed(Duration(milliseconds: 2000));
    _paginatedProductData =
        _products.getRange(startIndex, endIndex).toList(growable: false);
    notifyListeners();
    return true as Future<bool>;
    //return super.handlePageChange(oldPageIndex, newPageIndex);
  }
  /*Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
      int startRowIndex, int rowsPerPage) async {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (endIndex > _products.length) {
      endIndex = _products.length;
    }
    // await Future.delayed(Duration(milliseconds: 2000));
    _paginatedProductData =
        _products.getRange(startIndex, endIndex).toList(growable: false);
    notifyListeners();
    return true;
  }*/

  @override
  bool shouldRebuild(covariant CustomSliverChildBuilderDelegate oldDelegate) {
    //  notifyListeners();
    return true;
  }
}

class QuotesData extends State<Quotes> {
  TextEditingController searchQuotesController = new TextEditingController();
  TextEditingController selectDateFromController = new TextEditingController();
  TextEditingController selectDateToController = new TextEditingController();
  DateTime selectedDateTo = DateTime.now();
  DateTime selectedDateFrom = DateTime.now();
  var selectedDatefrom, selectedDateto;
  int pageno = 0;
  int totalcount;
  bool showLoadingIndicator = false;
  bool forwardbtn_visible = true;
  PagingProductRepository pagingProductRepository = PagingProductRepository();
  static const double dataPagerHeight = 65.0;
  var valueData, _selectedStatus;
  String flag;

  fetch(pageno, valueData, searchQuotesController) async {
    print("fetching");
    var url = Uri.parse('${widget.baseurl}' + Constants.DEANA_QUOTESFILTER);

    final response = await http
        .post(url,
            headers: {
              "Authorization": '${widget.token}',
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "dateFromFormat": selectDateFromController.text != null ? selectDateFromController.text : null,
              "dateToFormat": selectDateToController.text != null ? selectDateToController.text : null,
              "id": searchQuotesController,
              "pageNo": pageno,
              "size": Constants.ITEM_PER_PAGE,
              "sort": "id",
              "sortType": "desc",
              "status": valueData
            }))
        .then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var d = jsonDecode(response.body);
        for (var i = 0; i <= d.length - 1; i++) {
          pagingProductRepository.id.add(PagingProduct.fromJson(d[i]).id);
          pagingProductRepository.locationDescription
              .add(PagingProduct.fromJson(d[i]).locationDescription);
          pagingProductRepository.customerName
              .add(PagingProduct.fromJson(d[i]).customerName);
          pagingProductRepository.itemDescription
              .add(PagingProduct.fromJson(d[i]).itemDescription);
          pagingProductRepository.createdDateFormat
              .add(PagingProduct.fromJson(d[i]).createdDateFormat);
          pagingProductRepository.flag.add(PagingProduct.fromJson(d[i]).flag);
          // bloc.auth;
          // pagingProductRepository.ibSourcingMaster.add(PagingProduct.fromJson(d[i]).ibSourcingMaster);
          // pagingProductRepository.ibCategoryMaster.add(PagingProduct.fromJson(d[i]).ibCategoryMaster);
        }
        _products = List.from(populateData(pagingProductRepository));
        print("ffhfh");
        print(response.headers);
        print(response.headers.values.elementAt(12));
        flag = valueData;
        if (flag == "E") {
          forwardbtn_visible = true;
        } else {
          forwardbtn_visible = false;
        }
        if (response.headers.keys.contains('x-total-count')) {
          totalcount = int.parse(response.headers['x-total-count']);
          print(response.headers['x-total-count']);
        }

        if (totalcount > Constants.ITEM_PER_PAGE &&
            _products.length != totalcount) {
          pageno++;
          if (valueData == null) {
            fetch(pageno, "E", searchQuotesController);
          } else {
            fetch(pageno, valueData, searchQuotesController);
          }
          //    }
        }

//        }

        // print("_products");
        // print(_products);
      } else {
        print(response.body);
        throw Exception("Failed to Load Names");
      }
    });

    if (mounted)
      setState(() {
        print("fetched");
      });
    // notifyListeners();
  }

  ForwardModel forward;

  Future<ForwardModel> getforward(int id) async {
    _showMyDialog(id);
  }

  Future<void> forwardAPI(int id) async {
    var url =
        Uri.parse('${widget.baseurl}' + Constants.DEANA_FORWARD_QUOTES + id.toString());
    final response = await http.get(
      url,
      headers: {
        "Authorization": '${widget.token}',
        "Content-Type": "application/json"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print("connection ok");
        var forwarddata = jsonDecode(response.body);
        forward = ForwardModel.fromJson(forwarddata);
        _products.clear();
        pagingProductRepository.id.clear();
        pagingProductRepository.locationDescription.clear();
        pagingProductRepository.customerName.clear();
        pagingProductRepository.itemDescription.clear();
        pagingProductRepository.createdDateFormat.clear();
        _paginatedProductData = [];
        fetch(pageno, "E", null);
        Fluttertoast.showToast(
            msg: "Forward Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        return forward;
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

  Future<void> _showMyDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Dialog'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure to forward for approval?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                forwardAPI(id);
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

  _selectDateTo(BuildContext context) async {
    selectedDateFrom = null;
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTo,
      firstDate: DateTime(2021),
      lastDate: DateTime(2031),
    );
    if (picked != null && picked != selectedDateTo) {
      setState(() {
        selectedDateTo = picked;

        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        final String formatted = formatter.format(selectedDateTo);
        selectDateToController.text = formatted;
        selectedDateto = formatted;
      });
    }
    //java.util.Date utilDate = new java.util.Date(selectedDate);
    //  java.util.Date utilDate = java.util.Date.from( OffsetDateTime.parse( "2015-‌01-12T05:00:00.000+0‌000" ).toInstant() );

    // Date date = Date.from(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss‌").parse("2015-‌01-12T05:00:00.000+0‌000", ZonedDateTime::from).toInstant());
  }

  _selectDateFrom(BuildContext context) async {
    selectedDatefrom = null;
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom, // Refer step 1
      firstDate: DateTime(2021),
      lastDate: DateTime(2031),
    );
    if (picked != null && picked != selectedDateFrom) {
      setState(() {
        selectedDateFrom = picked;

        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        final String formatted = formatter.format(selectedDateFrom);
        selectDateFromController.text = formatted;
        selectedDatefrom = formatted;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    valueData = "E";
    _selectedStatus = "Pending";
    fetch(pageno, "E", null);

    //AuthChangeNotifier();
    //  _paginatedProductData.ad
  }

  void rebuildList() {
    //AuthChangeNotifier();
    setState(() {});
  }

  Widget loadListView(BoxConstraints constraints) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];

      if (_products.isNotEmpty) {
        stackChildren.add(ListView.custom(
            childrenDelegate: CustomSliverChildBuilderDelegate(indexBuilder)));
      }
      if(stackChildren.length ==0)
        {
          if (showLoadingIndicator) {
            stackChildren.add(Container(
              color: Colors.black12,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
            ));
          }
        }

      return stackChildren;
    }

    return Stack(
      children: _getChildren(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var bloc = Provider.of<AuthChangeNotifier>(context,listen: false);
    //bloc.onNewAuth(pagingProductRepository);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 86, 30, 101),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                    token: '${widget.token}', baseurl: '${widget.baseurl}'),
              ));
            },
          ),
          title: Text('Quotes'),
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 1.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        1.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                height: dataPagerHeight * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.40,
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      padding: EdgeInsets.all(5),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),

                        //background color of box
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                          )
                        ],
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        value: _selectedStatus,
                        items: _dropDownItem(),
                        onChanged: (value) {
                          switch (value) {
                            case "Pending":
                              setState(() {
                                valueData = "E";
                                _selectedStatus = "Pending";
                              });
                              break;
                            case "Forwarded":
                              setState(() {
                                valueData = "F";
                                _selectedStatus = "Forwarded";
                              });
                              break;
                            case "Approved":
                              setState(() {
                                valueData = "A";
                                _selectedStatus = "Approved";
                              });
                              break;
                            case "Rejected":
                              setState(() {
                                valueData = "R";
                                _selectedStatus = "Rejected";
                              });
                              break;
                          }
                        },
                        hint: Text('Pending'),
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                        underline: Container(color: Colors.transparent),
                      ),
                    ),
                    Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.40,
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: TextField(
                          textAlign: TextAlign.justify,
                          textCapitalization: TextCapitalization.characters,
                          maxLines: 1,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                          controller: searchQuotesController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            hintText: 'Quotes ID',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.13,
                        decoration: new BoxDecoration(
                          color: Color.fromARGB(255, 86, 30, 101),
                          borderRadius: BorderRadius.circular(50),
                          //background color of box
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        child: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                print(valueData);
                                print(searchQuotesController.text);
                                _products.clear();
                                pagingProductRepository.id.clear();
                                pagingProductRepository.locationDescription
                                    .clear();
                                pagingProductRepository.customerName.clear();
                                pagingProductRepository.itemDescription.clear();
                                pagingProductRepository.createdDateFormat
                                    .clear();
                                _paginatedProductData = [];
                                // _paginatedProductData.clear();
                                fetch(pageno, valueData,
                                    searchQuotesController.text);
                              });
                            }))
                  ],
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 1.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                height: dataPagerHeight * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.40,
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      color: Colors.white,
                      child: TextField(
                        textAlign: TextAlign.justify,
                        textCapitalization: TextCapitalization.characters,
                        maxLines: 1,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                        controller: selectDateFromController,
                        onTap: () => _selectDateFrom(context),
                        // Re// fer step 3
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          hintText: 'Date From',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                      // RaisedButton(
                      //   color: Colors.white,
                      //   padding: EdgeInsets.all(10),
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   onPressed: () => _selectDateFrom(context), // Re// fer step 3
                      //   child: Text(
                      //     "${selectedDateFrom.toLocal()}".split(' ')[0],
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(fontSize: 12, color: Colors.black),
                      //   ),
                      // ),
                    ),
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.40,
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      color: Colors.white,
                      child: TextField(
                        textAlign: TextAlign.justify,
                        textCapitalization: TextCapitalization.characters,
                        maxLines: 1,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                        controller: selectDateToController,
                        onTap: () => _selectDateTo(context),
                        // Re// fer step 3
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          hintText: 'Date To',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                      // RaisedButton(
                      //   color: Colors.white,
                      //   padding: EdgeInsets.all(10),
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   onPressed: () => _selectDateFrom(context), // Re// fer step 3
                      //   child: Text(
                      //     "${selectedDateFrom.toLocal()}".split(' ')[0],
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(fontSize: 12, color: Colors.black),
                      //   ),
                      // ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.13,
                        decoration: new BoxDecoration(
                          color: Color.fromARGB(255, 86, 30, 101),
                          borderRadius: BorderRadius.circular(90),
                          //background color of box
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => EnqiuryPage(
                                      token: '${widget.token}',
                                      baseurl: '${widget.baseurl}'),
                                ));
                              });
                            }))
                  ],
                ),
              ),
              Container(
                height: constraint.maxHeight - 170,
                child: _products.length == 0
                    ? Text(
                        "No data found",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    : loadListView(constraint),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: dataPagerHeight,
                        child: SfDataPagerTheme(
                            data: SfDataPagerThemeData(
                              selectedItemColor:
                                  Color.fromARGB(255, 86, 30, 101),
                              itemBorderRadius: BorderRadius.circular(5),
                            ),
                            child: _products.length == 0
                                ? Text("")
                                : SfDataPager(
                                 visibleItemsCount: _products.isEmpty
                                        ? 0
                                        : (_products.length <
                                                Constants.ITEM_PER_PAGE
                                            ? _products.length
                                            : Constants.ITEM_PER_PAGE),
                                    onPageNavigationStart: (pageIndex) {
                                      setState(() {
                                        showLoadingIndicator = true;
                                      });
                                    },
                                    onPageNavigationEnd: (pageIndex) {
                                      setState(() {
                                        showLoadingIndicator = false;
                                      });
                                    },
                                    delegate: CustomSliverChildBuilderDelegate(
                                        indexBuilder)
                                      ..addListener(rebuildList), pageCount:_products.length.toDouble(),)),
                      ),
                    ]),
              ),
            ],
          );
        }),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["Pending", "Forwarded", "Approved", "Rejected"];
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  Widget indexBuilder(BuildContext context, int index) {
    final PagingProduct data = _paginatedProductData[index];

    return ListTile(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width,
              height: 85,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                alignment: Alignment.topLeft,
                                child: Text(data.id.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: 15)),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                alignment: Alignment.topLeft,
                                child: data.locationDescription != null
                                    ? Text(data.locationDescription,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 13))
                                    : Text(""),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                alignment: Alignment.topLeft,
                                child: data.createdDateFormat != null
                                    ? RichText(
                                        text: TextSpan(children: [
                                        TextSpan(
                                            text: 'REQ. DATE: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: data.createdDateFormat,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 11))
                                      ]))
                                    : Text(""),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.07,
                                alignment: Alignment.topRight,
                                height: 20,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/edit.png'),
                                  ),
                                ),
                                child: new FlatButton(
                                    onPressed: () {
                                      if (data != null && data.id != null) {
                                        int id = data.id;
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new QuotesDetail(
                                                        token:
                                                            '${widget.token}',
                                                        baseurl:
                                                            '${widget.baseurl}',
                                                        id: id)));
                                      }
                                    },
                                    child: null),
                              ),
                              Visibility(
                                  visible: forwardbtn_visible,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.07,
                                    alignment: Alignment.topRight,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/next.png'),
                                      ),
                                    ),
                                    child: new FlatButton(
                                        onPressed: () {
                                          int id = data.id;
                                          getforward(id);
                                        },
                                        child: null),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.topLeft,
                          child: Text(data.customerName,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 13)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.topLeft,
                          child: Text(data.itemDescription,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
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
