class customerNameModel {
  int id;
  String customerCode;
  String customerName;
  String pincode;
  double acd;
  double creditDays;
  bool rspCustomer;
  String flag;
  String createdBy;
  String createdDate;
  AgCustGroupMaster agCustGroupMaster;

  customerNameModel(
      {this.id,
      this.customerCode,
      this.customerName,
      this.pincode,
      this.acd,
      this.creditDays,
      this.rspCustomer,
      this.flag,
      this.createdBy,
      this.createdDate,
      this.agCustGroupMaster});

  customerNameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    pincode = json['pincode'];
    acd = json['acd'];
    creditDays = json['creditDays'];
    rspCustomer = json['rspCustomer'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    agCustGroupMaster = json['agCustGroupMaster'] != null
        ? new AgCustGroupMaster.fromJson(json['agCustGroupMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerCode'] = this.customerCode;
    data['customerName'] = this.customerName;
    data['pincode'] = this.pincode;
    data['acd'] = this.acd;
    data['creditDays'] = this.creditDays;
    data['rspCustomer'] = this.rspCustomer;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    if (this.agCustGroupMaster != null) {
      data['agCustGroupMaster'] = this.agCustGroupMaster.toJson();
    }
    return data;
  }
}

class AgCustGroupMaster {
  int id;
  String groupCode;
  String groupDescription;
  String flag;
  String createdBy;
  String createdDate;

  AgCustGroupMaster(
      {this.id,
      this.groupCode,
      this.groupDescription,
      this.flag,
      this.createdBy,
      this.createdDate});

  AgCustGroupMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupCode = json['groupCode'];
    groupDescription = json['groupDescription'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupCode'] = this.groupCode;
    data['groupDescription'] = this.groupDescription;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
