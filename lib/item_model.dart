class ItemModel {
  int id;
  String itemCode;
  String itemDescription;
  String flag;
  String createdBy;
  String createdDate;
  int subGroupCode;
  AgItemGroupMaster agItemGroupMaster;
  AgCompanyMaster agCompanyMaster;

  ItemModel(
      {this.id,
      this.itemCode,
      this.itemDescription,
      this.flag,
      this.createdBy,
      this.createdDate,
      this.subGroupCode,
      this.agItemGroupMaster,
      this.agCompanyMaster});

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemCode = json['itemCode'];
    itemDescription = json['itemDescription'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    subGroupCode = json['subGroupCode'];
    agItemGroupMaster = json['agItemGroupMaster'] != null
        ? new AgItemGroupMaster.fromJson(json['agItemGroupMaster'])
        : null;
    agCompanyMaster = json['agCompanyMaster'] != null
        ? new AgCompanyMaster.fromJson(json['agCompanyMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itemCode'] = this.itemCode;
    data['itemDescription'] = this.itemDescription;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['subGroupCode'] = this.subGroupCode;
    if (this.agItemGroupMaster != null) {
      data['agItemGroupMaster'] = this.agItemGroupMaster.toJson();
    }
    if (this.agCompanyMaster != null) {
      data['agCompanyMaster'] = this.agCompanyMaster.toJson();
    }
    return data;
  }
}

class AgItemGroupMaster {
  int id;
  String groupCode;
  String groupDescription;
  String flag;
  bool wastage;
  bool msp;
  bool osp;
  String createdBy;
  String createdDate;

  AgItemGroupMaster(
      {this.id,
      this.groupCode,
      this.groupDescription,
      this.flag,
      this.wastage,
      this.msp,
      this.osp,
      this.createdBy,
      this.createdDate});

  AgItemGroupMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupCode = json['groupCode'];
    groupDescription = json['groupDescription'];
    flag = json['flag'];
    wastage = json['wastage'];
    msp = json['msp'];
    osp = json['osp'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupCode'] = this.groupCode;
    data['groupDescription'] = this.groupDescription;
    data['flag'] = this.flag;
    data['wastage'] = this.wastage;
    data['msp'] = this.msp;
    data['osp'] = this.osp;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

class AgCompanyMaster {
  int id;
  String companyCode;
  String companyDescription;
  String flag;
  String createdBy;
  String createdDate;

  AgCompanyMaster(
      {this.id,
      this.companyCode,
      this.companyDescription,
      this.flag,
      this.createdBy,
      this.createdDate});

  AgCompanyMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyCode = json['companyCode'];
    companyDescription = json['companyDescription'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyCode'] = this.companyCode;
    data['companyDescription'] = this.companyDescription;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
